extends KinematicBody2D

var speed : int = 100
var vel : Vector2 = Vector2(0,0)

onready var sprite = $ColorRect
onready var obstacle_spawner  = get_parent().get_parent()
onready var collision = $CollisionShape2D

onready var end_anim = $AnimationPlayer2
onready var coin_label_scene = preload("res://scenes/coin/CoinLabel.tscn")
var dead = false

func _ready():
	pass

func setParams(_speed: int) -> void:
	speed = _speed
	vel.y = -speed

func add_label():
	var coin_label = coin_label_scene.instance()
	coin_label.global_position = global_position
	obstacle_spawner.add_child(coin_label)
	pass

func kill() -> void:
	collision.set_deferred("disabled", true)
	sprite.hide()
	add_label()
	
	set_physics_process(false)
	end_anim.play("fade_out")
	
	yield(end_anim, "animation_finished")
	
	call_deferred("queue_free")
	pass

func _physics_process(delta) -> void:
	var move_and_collide = move_and_collide(vel * delta)

func _on_VisibilityNotifier2D_screen_exited() -> void:
	if !dead: call_deferred("queue_free")
	pass
