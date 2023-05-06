extends Node2D

onready var ball_scene = load("res://scenes/ball/Ball.tscn")
onready var spots = $Spots
onready var ball_container = $BallContainer
onready var tween = $Animations/Tween
onready var slowmoController = $SlowmoController
onready var camera = $GUI/Camera2D

onready var score_label = preload("res://scenes/coin/CoinNumberLabel.tscn")
onready var splash_particle_scene = preload("res://scenes/particles/Rect_particle.tscn")
onready var particles = $Particles

onready var level_system = $Score/LevelSystem
onready var levelup_anim = $Score/LevelUpAnim
onready var levelup_anim_timer = $Score/LevelUpAnim/Timer
onready var powerup_notif_anim = $PowerupNotif/AnimationPlayer
onready var powerup_notif_label = $PowerupNotif/Body/TextureRect/Label

var ball = null
var next_target = null
var prev_target = null
var ball_destination = null

const main_speed: float = 0.142
const slowmo_speed: float = 5.0
onready var speed = main_speed

var ricochet_speed = 0.1
var next_target_time = 0.1

var can_click = false
var control_click = true

var _modulate = null

onready var flash_anim = $GUI/Flash/AnimationPlayer
onready var control_timer = $Timers/ControlTimer
onready var anim = $Animations/AnimationPlayer

var player_damage = 0

func _ready():
	_modulate = spots.get_child(1).get_child(0).modulate
	randomize()
	setCenter()
	pass

func set_points():
	level_system.set_points()
	pass

func level_up():
	level_system.exit()
	levelup_anim_timer.start()
	levelup_anim.get_node("AnimationPlayer").play("enter")
#	levelup_anim.get_node("Shower/AnimationPlayer").play("New Anim")
	Global.is_levelup = true
	
	yield(levelup_anim_timer, "timeout")
	levelup_anim_timer.wait_time += 0.5
	levelup_anim.get_node("AnimationPlayer").play_backwards("exit")
#	levelup_anim.get_node("Shower/AnimationPlayer").stop()
	level_system.enter()
	Global.is_levelup = false
	Global.can_spawn_powerup = true
	Global.emit_signal("diff_increase")
	pass

func show_powerup_notif(text):
	powerup_notif_label.text = text
	powerup_notif_anim.play("New Anim")
	pass

func _start():
	can_click = true
	Global.score = 0
#	Global.highscore = 0
#	anim.play("shake")
	level_system.start()
	level_system.enter()


func push_back(vel):
	var magnitude = 8
	var offset = vel * magnitude
	tween.start()
	tween.interpolate_property(spots, "position", spots.position, offset, 0.1,Tween.TRANS_LINEAR,Tween.EASE_OUT)
	
	yield(tween , "tween_completed")
	
	tween.start()
	tween.interpolate_property(spots, "position", spots.position, Vector2.ZERO, 0.1,Tween.TRANS_LINEAR,Tween.EASE_OUT)
	pass

func flash():
	flash_anim.play("flash")
	pass

func gameover():
	level_system.exit()
	if next_target:
		next_target.get_child(0).modulate = _modulate
		stop_blink(next_target)
	pass

func play_blink(child):
	child.get_node("dot").show()
	child.get_node("AnimationPlayer").play("blink")
	pass

func stop_blink(child):
	child.get_node("dot").hide()
	child.get_node("AnimationPlayer").stop()
	pass

func play_fade(child):
	child.get_node("AnimationPlayer").stop()
	child.get_node("AnimationPlayer").play("fade")

func setCenter() -> void:
	var offset = 80
	var rect = get_viewport_rect().size/2
	camera.position = rect
	rect.y += offset
	position = rect
	pass

func play_score_anim():
	get_parent().play_score_anim()
	pass


func setParams(item) -> void:
	# set ball instance --->
	ball = item
	# <-----
	var children = spots.get_children()
	var child = children[randi()%spots.get_child_count()]
	next_target = child
	ball_destination = child.position
	item.position = child.position.rotated(child.global_rotation)
	print(child.global_rotation, "child position")
	pass

func nextTarget() -> void:
	var children : Array = spots.get_children()
	
	#getting next target
	var targets : Array = children.duplicate()
	var options : Array = []
	if next_target: targets.erase(next_target)
	if next_target:
		var next_target_location = next_target.get_index()
		var index = next_target_location % 2
		for i in spots.get_child_count():
			if i % 2 != index: options.append(spots.get_child(i))
	else: options = targets
	
	var child = options[randi()%options.size()]
	var pos = child
	
	yield(get_tree().create_timer(next_target_time),"timeout")
	#highlight next target
	next_target.get_child(0).modulate = _modulate
	stop_blink(next_target)
#	play_fade(next_target)
	next_target = pos
	if ball:
		ball.set_indicator(next_target)
	child.get_child(0).modulate = Color("f61d3d")
	play_blink(child)

func moveBall(move_speed) -> void:
	prev_target = next_target
	ball.moveToTarget(next_target.position, next_target.global_rotation, move_speed)
	nextTarget()
	pass

func shake_camera(amount):
	camera.add_trauma(amount)
pass

func instanceBall() -> void:
	var item = ball_scene.instance()
	setParams(item)
	ball_container.add_child(item)
	nextTarget()
#	item.set_indicator(next_target)
	pass

func spawn_splash_particle(pos):
	for i in 2:
		var item = splash_particle_scene.instance()
		item.position = pos
		particles.add_child(item)
	pass

func ball_ricochet(amt):
	if !ball: return
	var move_speed = 0.1
	var time_speed = 0.1
	self.set_process_input(false)
	yield(get_tree().create_timer(0.1),"timeout")
	ball.start_ricochet()
	for i in amt:
		if !ball: break
		if i == (amt -1):
			slowmoController.enter_slowmo_ricochet()
			ball.is_ricochet_playing = true
#			time_speed = 0.01
		prev_target = next_target
		ball.moveToTarget(next_target.position, next_target.global_rotation, move_speed)
		nextTarget()
		ball.set_indicator(next_target)
		yield(get_tree().create_timer(time_speed),"timeout")

#	can_click = true
	pass

func show_damage():
	if prev_target.global_position.x > get_viewport_rect().size.x/2:
		show_score_label(prev_target.position, Vector2(60, 0))
	else:
		show_score_label(prev_target.position, Vector2(-60, 0))
	pass

func show_score_label(pos, offset):
	var item = score_label.instance()
	item.global_position = pos + offset
	item.get_node("Body/Label").text = str(exp_damage())
	particles.add_child(item)
	pass

func exp_damage():
	randomize()
	var damage = int(rand_range(1, 2))
	player_damage = damage
	return damage
	pass


func start_slowmo():
	can_click = false
#	speed = slowmo_speed
	if ball: ball.start_slowmo(0.1)

func end_slowmo():
#	can_click = true
#	speed = main_speed
	if ball: ball.end_slowmo(4)

func _input(event):
	if can_click and ball and control_click:
		if Input.is_action_just_pressed("click"):
			if ball.raycast_colliding:
				slowmoController.enter_slowmo()
			moveBall(speed)
			can_click = false
#			Global.energy += 10
			
		if event is InputEventMouseButton and event.is_pressed():
			if ball.raycast_colliding:
				slowmoController.enter_slowmo()
			moveBall(speed)
			can_click = false
			control_timer.start()
			control_click = false
#			Global.emit_signal("add_energy")
		if Input.is_action_just_pressed("special attack"):
			ball_ricochet(8)

func set_gameover() -> void:
	ball = null
	shake_camera(0.4)
	get_tree().get_nodes_in_group("gameover")[0].show()

func _on_ControlTimer_timeout():
	control_click = true
	pass # Replace with function body.
