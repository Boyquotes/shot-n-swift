extends KinematicBody2D

var speed : int = 100
var vel : Vector2 = Vector2(0,0)

onready var obstacle_spawner  = get_parent().get_parent()
onready var obstacles = get_parent().get_parent().obstacles
onready var rotating_body = $CollisionShape2D
onready var tween = $Node2D/Tween
onready var timer = $Timer
onready var anim = $Node2D/AnimationPlayer
onready var swap_anim = $Node2D/SwapAnimation
onready var delay = $DelayTimer

onready var sprite = $CollisionShape2D/Sprite
onready var coin_sprite = $CollisionShape2D/CoinSprite

var rotating = false
enum difficulties {
	ROTATE,
	SWAP,
	MOVE_X,
	MOVE_Y
}

var difficulty = ""
var move_offset = 40

func _ready():
	start()
	pass

func start():
	rotating_body.rotation_degrees = rand_range(0, 360)
	set_difficulty()
	match_difficulty()
	pass
	
func set_difficulty():
	randomize()
	if Global.level >= 4:
		var rand = randi()%2
		if rand == 0: difficulty = difficulties.ROTATE
	if Global.level >= 8:
		var rand = randi()%4
		if rand == 0: difficulty = difficulties.MOVE_X
	if Global.level >= 12:
		var rand = randi()%4
		if rand == 0: difficulty = difficulties.MOVE_Y
	if Global.level >= 16:
		var rand = randi()%4
		if rand == 0: difficulty = difficulties.MOVE_X
		if rand == 1: difficulty = difficulties.MOVE_Y
	if Global.level >= 30:
		var rand = randi()%4
		if rand == 0: difficulty = difficulties.SWAP
		if rand == 1: 
			var rand2 = randi()%8
			if rand2 == 0: difficulty = difficulties.MOVE_X
			if rand2 == 1: difficulty = difficulties.MOVE_Y
	if Global.level >= 40:
		var rand = randi()%10
		if rand == 0: difficulty = difficulties.SWAP
		if rand == 1: 
			var rand2 = randi()%2
			if rand2 == 0: difficulty = difficulties.MOVE_X
			if rand2 == 1: difficulty = difficulties.MOVE_Y
	pass

func match_difficulty():
	#lowest = 0.01 highest for highest  0.5, 0.2
	randomize()
	var rand = rand_range(0.1, 1.1)
	timer.wait_time = rand
	match difficulty:
		difficulties.ROTATE:
			rotating = true
		difficulties.MOVE_X:
			rotating = true
			timer.start()
		difficulties.MOVE_Y:
			rotating = true
			timer.start()
		difficulties.SWAP:
			rotating = true
			timer.start()
			coin_sprite.show()
			sprite.hide()
			rotating_body.disabled = true
	pass

func move_x():
	randomize()
	var moving_rand = 0
	var rand = randi()%2
	if rand == 0: moving_rand = move_offset
	else: moving_rand = -move_offset
	
	tween.start()
	tween.interpolate_property(rotating_body, "position:x", 0, moving_rand, 0.5, Tween.TRANS_ELASTIC, Tween.EASE_OUT )
	pass

func move_y():
	randomize()
	var moving_rand = 0
	var rand = randi()%2
	if rand == 0: moving_rand = move_offset + 40
	else: moving_rand = -move_offset - 40
	
	
	tween.start()
	tween.interpolate_property(rotating_body, "position:y", 0, moving_rand, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN )
	pass

func swap():
	swap_anim.play("New Anim")
	rotating_body.disabled = false
	pass

func setParams(_speed: int) -> void:
	speed = _speed
	vel.y = -speed

func _process(delta) -> void:
	if rotating: rotating_body.rotate(0.05)
	var move_and_collide = move_and_collide(vel * delta)
	pass

func _on_VisibilityNotifier2D_screen_exited() -> void:
	call_deferred("queue_free")
	pass


func _on_Timer_timeout():
	anim.play("New Anim")
	delay.start()
	yield(delay, "timeout")
	match difficulty:
		difficulties.MOVE_X:
			move_x()
		difficulties.MOVE_Y:
			move_y()
		difficulties.SWAP:
			swap()
	pass # Replace with function body.
