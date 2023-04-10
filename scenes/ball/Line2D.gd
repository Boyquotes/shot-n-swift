extends Line2D

export var length = 5
func _ready():
	pass

func _process(delta):
	global_position = Vector2(0,0)
	global_rotation = 0
	add_point(get_parent().global_position)
	
	while get_point_count() > length:
		remove_point(0)
