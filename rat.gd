extends CharacterBody2D
class_name Rat

@export var max_speed : float = 100
@export var accel : float = 500
@export_range(0.0, 10.0) var cursor_weight = 1.0
@export_range(0.0, 10.0) var separation_weight = 0.5
@export_range(0.0, 10.0) var alignment_weight = 0.4
@export_range(0.0, 10.0) var cohesion_weight = 0.4
@export_range(0.0, 10.0) var food_weight = 3.0
const max_influence : int = 10
var cursor_force : Vector2 = Vector2.ZERO
var food_force : Vector2 = Vector2.ZERO

var desire : Vector2 = Vector2.ZERO
@onready var influence_radius = $Influence/CollisionShape2D.shape.radius

var corpse_scene = preload("res://blood_splatter.tscn")

func _ready() -> void:
	Events.rat_spawned.emit()

func _physics_process(delta: float) -> void:
	desire = Vector2.ZERO
	desire += cursor_force * cursor_weight
	desire += food_force * food_weight * delta
	#if food_force.is_zero_approx():
		#
	desire += get_separation_force()
	desire += get_alignment_force() * delta
	desire += get_cohesion_force()
	
	velocity += desire * accel * delta
	velocity = velocity.limit_length(max_speed)
	move_and_slide()
	rotation = lerp(rotation, velocity.angle(), 50 * (velocity.length()/max_speed)*delta)
	
	if cursor_force.is_zero_approx():
		velocity *= 0.95
		$AnimationPlayer.play("idle")
	else:
		$AnimationPlayer.play("walk")
	
	set_animation_speed()

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

func set_animation_speed() -> void:
	var amin_speed = 1.0
	var amax_speed = 10.0
	var speed_range = amax_speed - amin_speed
	var current_speed = velocity.length() / max_speed
	$AnimationPlayer.speed_scale = amin_speed + speed_range * current_speed
	

func kill() -> void:
	var splat = corpse_scene.instantiate()
	get_parent().add_child(splat)
	splat.global_position = global_position
	splat.splat()
	queue_free()
