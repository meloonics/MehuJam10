extends Line2D

func _ready() -> void:
	$Path2D.curve.clear_points()
	for i in points:
		$Path2D.curve.add_point(i)
