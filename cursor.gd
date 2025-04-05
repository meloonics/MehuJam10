extends Area2D

@onready var radius = $CollisionShape2D.shape.radius

func _ready() -> void:
	$Sprite2D.texture.width = radius * 2
	$Sprite2D.texture.height = radius * 2


func _physics_process(delta: float) -> void:
	global_position = get_global_mouse_position()
	#print(get_overlapping_bodies().size())
	
	for i in get_overlapping_bodies():
		if i is Rat:
			var force : Vector2 = i.global_position.direction_to(global_position)
			var dist : float = i.global_position.distance_to(global_position)
			if Input.is_action_pressed("LeftClick"):
				force *= (dist / radius)
				modulate = Color.GREEN
				i.cursor_force = force
			elif Input.is_action_pressed("RightClick"):
				force *= ((radius - dist) / radius)
				i.cursor_force = -force
				modulate = Color.RED
			else:
				i.cursor_force = Vector2.ZERO
				modulate = Color.WHITE


func _on_body_exited(body: Node2D) -> void:
	if body is Rat:
		body.cursor_force = Vector2.ZERO
