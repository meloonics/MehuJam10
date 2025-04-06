extends Node2D

@export var NRats : int = 1
var rat_scene = preload("res://rat.tscn")
var cam_speed : float = 500.0
const spread : float = 50.0
var time : int = 0

func _ready() -> void:
	
	Events.rat_died.connect(update_rats)
	Events.rat_spawned.connect(update_rats)
	
	time = 0
	for i in NRats:
		var rar = rat_scene.instantiate()
		add_child(rar)
		rar.position = Vector2(randf() * spread, randf() * spread)
		
	
	
	var bounds : Rect2 = $Walls.get_used_rect()
	$Bounds/Left.global_position.x = bounds.position.x * 32
	$Bounds/Top.global_position.y = bounds.position.y * 32
	$Bounds/Right.global_position.x = bounds.position.x * 32 + bounds.size.x * 32
	$Bounds/Bottom.global_position.y = bounds.position.y * 32 + bounds.size.y * 32
	
	update_rats()
	update_saved()
	update_time()



func _physics_process(delta: float) -> void:
	var vel : Vector2 = Input.get_vector("left", "right", "up", "down") * cam_speed
	$Cam.velocity = vel
	$Cam.move_and_slide()
	

func update_rats() -> void:
	var current_rats = get_tree().get_nodes_in_group("rat").size()
	$HUD/HBoxContainer/Rats.set_text("Rats: " + str(current_rats))
	update_saved()

func update_time() -> void:
	time += 1
	$HUD/HBoxContainer/Time.set_text("Time: " + str(time))

func update_saved() -> void:
	if get_tree().get_nodes_in_group("rat").size() <= 0:
		get_tree().reload_current_scene()
		return
	var percent : float = float($Goal.get_overlapping_bodies().size()) / get_tree().get_nodes_in_group("rat").size()
	percent = snapped(percent, 0.01) * 100.0
	$HUD/HBoxContainer/Saved.set_text("Saved: " + str(percent) + "%")


func _on_goal_body_entered(body: Node2D) -> void:
	print("AY")
	if body is Rat:
		update_saved()

func _on_goal_body_exited(body: Node2D) -> void:
	if body is Rat:
		update_saved()
