extends Node2D

onready var ball_scene = load("res://scenes/ball/Ball.tscn")
onready var spots = $Spots
onready var ball_container = $BallContainer
onready var tween = $Animations/Tween
onready var slowmoController = $SlowmoController
onready var camera = $GUI/Camera2D

onready var progress_timer = $Timers/ProgressTimer
onready var progress_tween = $Animations/ProgressTween

onready var splash_particle_scene = preload("res://scenes/particles/Rect_particle.tscn")
onready var particles = $Particles

onready var level_system = $Score/LevelSystem
onready var levelup_anim = $Score/LevelUpAnim
onready var levelup_anim_timer = $Score/LevelUpAnim/Timer

var progress_bar = null
var hit_value = 25

var ball = null
var next_target = null
var ball_destination = null

const main_speed: float = 0.16
const slowmo_speed: float = 5.0
onready var speed = main_speed



var can_click = false
var _modulate = null

onready var anim = $Animations/AnimationPlayer


func _ready():
	_modulate = spots.get_child(1).get_child(0).modulate
	randomize()
	setCenter()
	pass

func _start():
	can_click = true
	Global.currentPoints = 0
	Global.highscore = 0
	level_system.start()
	level_system.enter()
#	anim.play("shake")

func level_up():
	level_system.exit()
	levelup_anim_timer.start()
	levelup_anim.get_node("AnimationPlayer").play("enter")
	levelup_anim.get_node("Shower/AnimationPlayer").play("New Anim")
	Global.is_levelup = true
	
	yield(levelup_anim_timer, "timeout")
	levelup_anim.get_node("AnimationPlayer").play_backwards("exit")
	levelup_anim.get_node("Shower/AnimationPlayer").stop()
	level_system.enter()
	Global.is_levelup = false
	Global.emit_signal("diff_increase")
	pass

func push_back(vel):
	var magnitude = 8
	var offset = vel * magnitude
	tween.start()
	tween.interpolate_property(spots, "position", spots.position, offset, 0.1,Tween.TRANS_LINEAR,Tween.EASE_OUT)
	
	yield(tween , "tween_completed")
	
	tween.start()
	tween.interpolate_property(spots, "position", spots.position, Vector2.ZERO, 0.1,Tween.TRANS_LINEAR,Tween.EASE_OUT)
	pass

func set_points():
	level_system.set_points()
	
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
	
	var hit_value = 20
	var pbar : ProgressBar =  child.get_node("ProgressBar")
	var second_progress = pbar.get_node("ProgressBar2")
	progress_bar = pbar
	pbar.show()
	second_progress.value = pbar.max_value
	pbar.value = pbar.max_value
	
	if !Global.gameover: progress_timer.start()
	
	pass

func stop_blink(child):
	child.get_node("dot").hide()
	child.get_node("AnimationPlayer").stop()
	
	var pbar =  child.get_node("ProgressBar")
	pbar.hide()
	progress_timer.stop()
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
	item.position = child.position
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
	
	yield(get_tree().create_timer(0.2),"timeout")
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
	ball.moveToTarget(next_target.position, move_speed)
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

#func ball_ricochet(amt):
#	var move_speed = 0.1
#	var time_speed = 0.1
#
#	ball.monitoring = false
#	for i in amt:
#		ball.moveToTarget(next_target.position, move_speed)
#		nextTarget()
#		ball.set_indicator(next_target)
#		if i == (amt - 2): 
#			#slow down
#			print("slow down")
#		yield(get_tree().create_timer(time_speed),"timeout")
#
#
#	ball.monitoring = true
#	can_click = true
#	pass

func start_slowmo():
	can_click = false
#	speed = slowmo_speed
	if ball: ball.start_slowmo(0.1)

func end_slowmo():
	can_click = true
#	speed = main_speed
	if ball: ball.end_slowmo(4)

func _input(event):
	if can_click and ball:
		if Input.is_action_just_pressed("click"):
			moveBall(speed)
			
		if event is InputEventMouseButton and event.is_pressed():
			if ball.raycast_colliding:
				slowmoController.enter_slowmo()
			moveBall(speed)
			can_click = false

func set_gameover() -> void:
	ball = null
	shake_camera(0.4)
	get_tree().get_nodes_in_group("gameover")[0].show()
	progress_timer.stop()

func _on_ProgressTimer_timeout():
	var value = 0
	if progress_bar: 
		var second_progress = progress_bar.get_node("ProgressBar2")
		value = progress_bar.value - hit_value
		progress_tween.start()
		progress_tween.interpolate_property(progress_bar, "value", progress_bar.value, progress_bar.value - hit_value, 0.3, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
		progress_tween.interpolate_property(second_progress, "value", second_progress.value, second_progress.value - hit_value, 0.3, Tween.TRANS_BOUNCE, Tween.EASE_IN)

	if value <= 0: 
		ball.die()
		set_gameover()
	pass # Replace with function body.
