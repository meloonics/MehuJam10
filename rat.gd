extends CharacterBody2D
class_name Rat

@export var max_speed : float = 500
@export var accel : float = 1500
@export_range(0.0, 10.0) var cursor_weight = 1.0
@export_range(0.0, 10.0) var separation_weight = 0.5
@export_range(0.0, 10.0) var alignment_weight = 0.4
@export_range(0.0, 10.0) var cohesion_weight = 0.4
const max_influence : int = 20
var cursor_force : Vector2 = Vector2.ZERO


var desire : Vector2 = Vector2.ZERO
@onready var influence_radius = $Influence/CollisionShape2D.shape.radius

func _physics_process(delta: float) -> void:
	desire = Vector2.ZERO
	desire += cursor_force * cursor_weight
	desire += get_separation_force()
	desire += get_alignment_force() * delta
	desire += get_cohesion_force()
	velocity += desire * accel * delta
	velocity = velocity.limit_length(max_speed)
	move_and_slide()
	rotation = lerp(rotation, velocity.angle(), 30 * (velocity.length()/max_speed)*delta)
	if cursor_force.is_zero_approx():
		velocity *= 0.95

func get_separation_force() -> Vector2:
	var separation : Vector2 = Vector2.ZERO
	var count : int = 0
	for i in $Influence.get_overlapping_bodies():
		if i is Rat and i != self:
			var force : Vector2 = global_position.direction_to(i.global_position)
			var dist : float = i.global_position.distance_to(global_position)
			force *= ((influence_radius - dist) / influence_radius)
			separation -= force
			count += 1
			if count >= max_influence:
				break
	if count > 1:
		separation /= count
	return separation * separation_weight

func get_alignment_force() -> Vector2:
	var alignment : Vector2 = Vector2.ZERO
	if not cursor_force.is_zero_approx():
		var count : int = 0
		for i in $Influence.get_overlapping_bodies():
			if i is Rat and i != self:
				alignment += i.velocity
				count += 1
				if count >= max_influence:
					break
		
		if count > 0:
			alignment /= count
	return alignment * alignment_weight * cursor_force.length()

func get_cohesion_force() -> Vector2:
	var cohesion : Vector2 = Vector2.ZERO
	var count : int = 0
	for i in $Influence.get_overlapping_bodies():
		if i is Rat and i != self:
			cohesion += i.global_position - global_position
			count += 1
			if count >= max_influence:
				break
			
	if count > 1: 
		cohesion /= count
	
	return cohesion.normalized() * cohesion_weight
