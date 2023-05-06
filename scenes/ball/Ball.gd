extends Area2D

onready var tween = $Tween
onready var controller = get_parent().get_parent()
onready var trail = $Trail
onready var anim = $AnimationPlayer
onready var indicator = $body/indicator
onready var rotate_tween = $RotationTween
onready var tween_tween = $TweenTween
onready var endslowmo_timer = $endSlowmoTimer
onready var raycastarea = $body/RayCastArea
onready var indicator_anim = $IndicatorAnim
onready var splashball_scene = preload("res://scenes/splashball/SplashBall.tscn")


var hit_value = 25

var next_target = null
var push_vel = null
var move_speed = 0.0
var move_angle = 0

var raycast_colliding = false
var is_ricochet_playing = false
var ricochet_mode = false

func _ready():
	pass

func start_ricochet():
	monitoring = false
	ricochet_mode = true
	$Line2D.show()
#	$body.hide()
	pass

func end_ricochet():
#	$Line2D.hide()
	monitoring = true
	is_ricochet_playing = false
	ricochet_mode = false
	yield(get_tree().create_timer(0.2), 'timeout')
	controller.can_click = true
	controller.set_process_input(true)
	pass

func set_indicator(target):
	next_target = target
	
	if indicator and indicator.is_inside_tree():
		push_vel = (target.global_position - global_position).normalized()
		var angle = (target.global_position - global_position).angle()
		move_angle = angle
		raycastarea.global_rotation = angle
		rotate_tween.start()
		rotate_tween.interpolate_property(indicator, "global_rotation", global_rotation, angle, 0.4, Tween.TRANS_BACK,Tween.EASE_OUT)
	pass


func start_slowmo(speed):
	ricochet_mode = true
	tween.playback_speed = 0
	tween_tween.start()
	tween_tween.interpolate_property(tween, "playback_speed", tween.playback_speed, speed, 0.01, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
	pass

func end_slowmo(speed):
	endslowmo_timer.start()
	yield(endslowmo_timer, "timeout")
	tween.playback_speed = 0.2
	tween_tween.start()
	tween_tween.interpolate_property(tween, "playback_speed", tween.playback_speed, speed, 0.08, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	yield(tween_tween, "tween_completed")
	tween.playback_speed = 1
	controller.shake_camera(0.22)
	ricochet_mode = false
	pass

func moveToTarget(target_pos: Vector2, target_rot, speed) -> void:
	indicator_anim.play("fade-in")
	if !ricochet_mode: 
		anim.play("shrink")
		trail.emitting = true
		$Line2D.hide()
	tween.start()
	tween.interpolate_property(self, "position", position, target_pos.rotated(target_rot), speed, Tween.TRANS_LINEAR, Tween.EASE_IN)

	yield(tween, "tween_completed")
	controller.push_back(push_vel)
	if !ricochet_mode: controller.spawn_splash_particle(target_pos)
	set_indicator(next_target)
	
	
	if Global.currentPoints < Global.levelPoints and !Global.is_levelup:
		Global.currentPoints += controller.player_damage
	Global.score += 1
	controller.set_points()
	controller.play_score_anim()
	controller.show_damage()
	trail.emitting = false
	indicator_anim.play_backwards("fade-in")
	if is_ricochet_playing:
		end_ricochet()
	else:
		controller.can_click = true
		pass
	pass

func gameover() -> void:
	controller.set_gameover()
	pass

func die():
	call_deferred("queue_free")
	spawn_balls()
	controller.flash()
	Global.gameover = true
	pass
	
func _on_Ball_body_entered(body):
	if body.get_groups().has("obstacle"):
		gameover()
		die()
	pass # Replace with function body.

func spawn_balls():
	randomize()
	var rand_amount = int(rand_range(5,10))

	for i in rand_amount:
		randomize()
		var item = splashball_scene.instance()
		var speed_y = rand_range(-2000,2000)
		var speed_x = rand_range(1000, 1800)
		var scale = rand_range(0.8,1)
		var random_color = Color(randf(), randf(), randf())
		var random_bounce = rand_range(0.1,0.4)
		
		item.position = position
		item.get_node("Sprite").scale = Vector2(scale, scale)
		item.get_node("Sprite").modulate = random_color
		item.linear_velocity = Vector2(-speed_x,speed_y)
		item.bounce = random_bounce
		
		get_parent().call_deferred("add_child", item)
	
	for i in rand_amount:
		randomize()
		var item = splashball_scene.instance()
		var speed_y = rand_range(-2000,2000)
		var speed_x = rand_range(1000, 1800)
		var scale = rand_range(0.8,1)
		var random_color = Color(randf(), randf(), randf())
		var random_bounce = rand_range(0.1,0.4)
		
		item.position = position
		item.get_node("Sprite").scale = Vector2(scale, scale)
		item.get_node("Sprite").modulate = random_color
		item.linear_velocity = Vector2(speed_x,speed_y)
		item.bounce = random_bounce
		
		get_parent().call_deferred("add_child", item)
	pass

# >>>>>>> PowerUps Implementation
func powerup_ricochet(amt):
	controller.ball_ricochet(amt)
	pass



# <<<<<<<

func _on_Tween_tween_completed(object, key):
	pass # Replace with function body.


func _on_RayCastArea_area_entered(_area):
	raycast_colliding = true
	pass # Replace with function body.


func _on_RayCastArea_area_exited(_area):
	raycast_colliding = false
	pass # Replace with function body.


func _on_CoinArea_body_entered(body):
	if body.get_groups().has("coin"):
		body.kill()
#		body.knockback(push_vel)
		Global.coins += 1
#		if !is_ricochet_playing:
#			controller.ball_ricochet(8)
	if body.get_groups().has("powerup"):
		body.set_powerup(self)
		controller.show_powerup_notif(body.powerup)
	pass # Replace with function body.
