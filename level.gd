extends Node2D

@export var NRats : int = 10
var rat_scene = preload("res://rat.tscn")
const spread : float = 50.0
func _ready() -> void:
	for i in NRats:
		var rar = rat_scene.instantiate()
		add_child(rar)
		rar.position = Vector2(randf() * spread, randf() * spread)
