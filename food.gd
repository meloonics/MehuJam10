extends Area2D

@export_range(1, 50) var min_rats : int = 1

@onready var radius : float = $CollisionShape2D.shape.radius

func _physics_process(delta: float) -> void:
	var rats = get_overlapping_bodies()
	if rats.size() >= min_rats:
		for i in get_overlapping_bodies():
			if i is Rat:
				var force : Vector2 = global_position - i.global_position
				var dist : float = i.global_position.distance_to(global_position)
				#force *= ((radius - dist) / radius)
				i.food_force = force
	
	$CPUParticles2D.emitting = rats.size() >= min_rats
	queue_redraw()

func _draw() -> void:
	draw_circle(Vector2.ZERO, 5, Color.RED)


func _on_body_exited(body: Node2D) -> void:
	if body is Rat:
		body.food_force = Vector2.ZERO
