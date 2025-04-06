extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body is Rat:
		body.kill()
		$Sprite2D.frame = 1
		
