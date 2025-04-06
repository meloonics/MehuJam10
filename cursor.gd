extends Area2D

@onready var radius = $CollisionShape2D.shape.radius
var state : int = 3
func _physics_process(delta: float) -> void:
	global_position = get_global_mouse_position()
	#print(get_overlapping_bodies().size())
	queue_redraw()
	for i in get_overlapping_bodies():
		if i is Rat:
			var force : Vector2 = i.global_position.direction_to(global_position)
			var dist : float = i.global_position.distance_to(global_position)
			if Input.is_action_pressed("LeftClick"):
				state = 1
				force *= (dist / radius)
				modulate = Color.GREEN
				i.cursor_force = force
			elif Input.is_action_pressed("RightClick"):
				state = 2
				force *= ((radius - dist) / radius)
				i.cursor_force = -force
				modulate = Color.RED
			else:
				state = 3
				i.cursor_force = Vector2.ZERO
				modulate = Color.WHITE

func _draw() -> void:
	match state:
		1:
			draw_circle(Vector2.ZERO, radius, Color.GREEN, false, 2.0)
		2: 
			draw_circle(Vector2.ZERO, radius, Color.RED, false, 2.0)
		3:
			draw_circle(Vector2.ZERO, radius, Color(1.0, 1.0, 1.0, 0.5), false, 2.0)

func _on_body_exited(body: Node2D) -> void:
	if body is Rat:
		body.cursor_force = Vector2.ZERO
