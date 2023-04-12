extends KinematicBody2D

var speed : int = 100
var vel : Vector2 = Vector2(0,0)

onready var obstacle_spawner  = get_parent().get_parent()

var dead = false

func _ready():
	pass

func setParams(_speed: int) -> void:
	speed = _speed
	vel.y = -speed

func kill() -> void:
	queue_free()
	pass

func _physics_process(delta) -> void:
	var move_and_collide = move_and_collide(vel * delta)

func _on_VisibilityNotifier2D_screen_exited() -> void:
	if !dead: 
		queue_free()
	pass
