extends Sprite2D

func _ready() -> void:
	frame = randi() % 4
	#$CPUParticles2D.emitting = true
	$AudioStreamPlayer2D.play()
	await get_tree().create_timer(0.1).timeout
	Events.rat_died.emit()

func splat() -> void:
	$CPUParticles2D.emitting = true
	
