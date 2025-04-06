extends Area2D

var active : bool = true : set = set_active

func _ready() -> void:
	set_active(active)

func set_active(val: bool) -> void:
	active = val
	$Sprite2D.frame = int(active)
	monitoring = active
	$AudioStreamPlayer2D.play()

func _on_body_entered(body: Node2D) -> void:
	if body is Rat:
		body.kill()
