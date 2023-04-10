extends Node2D

var speed = 10
func _ready():
	rotation_degrees = rand_range(0,360)
	pass

func _process(delta):
	move_local_y(speed)
