extends Node2D

var rat_scene = preload("res://rat.tscn")
var spread = 20.0

func reward(pos : Vector2, nrats : int) -> void:
	global_position = pos
	$CPUParticles2D.emitting = true
	$Label.set_text("Rat + " + str(nrats))
	$AudioStreamPlayer2D.play()
	for i in nrats:
		var rar = rat_scene.instantiate()
		get_tree().root.add_child(rar)
		rar.position = pos + Vector2.RIGHT.rotated(randf() * TAU) * randf() * spread
		

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == &"new_animation":
		queue_free()
