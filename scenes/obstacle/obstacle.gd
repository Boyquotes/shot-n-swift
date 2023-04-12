extends KinematicBody2D

var speed : int = 100
var vel : Vector2 = Vector2(0,0)

onready var obstacle_spawner  = get_parent().get_parent()
onready var obstacles = get_parent().get_parent().obstacles

var rotating = false
func _ready():
	$Sprite.rotation_degrees = rand_range(0, 360)
	pass

func setParams(_speed: int) -> void:
	speed = _speed
	vel.y = -speed

func _process(delta) -> void:
	if rotating: $Sprite.rotate(0.05)
	var move_and_collide = move_and_collide(vel * delta)
	pass

func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()
	pass
