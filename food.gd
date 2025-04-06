extends Area2D

@export_range(1, 50) var min_rats : int = 1

@onready var radius : float = $CollisionShape2D.shape.radius
var reward_scene = preload("res://reward.tscn")
var rats_left : int
var progress : float = 0.0

func _ready() -> void:
	$Sprite2D.frame = randi() % 9


func _physics_process(delta: float) -> void:
	var rats = get_overlapping_bodies()
	rats_left = min_rats - rats.size()
	%RatCount.visible = rats_left > 0 and min_rats > 1
	%RatCount.set_text(str(rats_left))
	if rats.size() >= min_rats:
		for i in rats:
			if i is Rat:
				var force : Vector2 = global_position - i.global_position
				var dist : float = i.global_position.distance_to(global_position)
				#force *= ((radius - dist) / radius)
				i.food_force = force
	
	$CPUParticles2D.emitting = rats.size() >= min_rats
	queue_redraw()
	handle_progress(delta)
	if progress > 0.0:
		handle_shake()

func _draw() -> void:
	if rats_left <= 0:
		draw_circle(Vector2.ZERO, radius, Color.GREEN, false)
	elif rats_left < min_rats:
		draw_circle(Vector2.ZERO, radius, Color.RED, false)

func _on_body_exited(body: Node2D) -> void:
	if body is Rat:
		body.food_force = Vector2.ZERO

func handle_progress(delta : float):
	$ProgressBar.visible = rats_left <= 0
	var deltabit = delta / (min_rats * 1.5)
	if $ProgressBar.visible:
		progress += deltabit + abs(rats_left) * deltabit
		progress = min(1.0, progress)
		$ProgressBar/nom.position.y = -$ProgressBar/nom.size.y * progress
		$ProgressBar.value = progress
	else:
		progress = 0.0
		$Sprite2D.offset = Vector2.ZERO
	
	if progress >= 1.0:
		reward()

func handle_shake() -> void:
	
	var min_shake : float = 0.25
	var max_shake : float = 3.0
	var shake : float = lerp(min_shake, max_shake, progress * progress)
	var offs = Vector2.RIGHT.rotated(randf() * TAU) * shake
	$Sprite2D.offset = offs

func reward() -> void:
	var rew = reward_scene.instantiate()
	get_parent().add_child(rew)
	rew.reward(global_position, min_rats)
	queue_free()
