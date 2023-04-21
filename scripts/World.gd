extends Node2D

onready var obstacle_spawner = $ObstacleSpawner
onready var player_controller = $PlayerController
onready var tween = $Animations/Tween
onready var gameover = $GUI/Gameover
onready var spots = $PlayerController/Spots
onready var anim = $Animations/AnimationPlayer
onready var label_anim = $GUI/Stats/Coin/VBoxContainer/HBoxContainer2/AnimationPlayer
var main_scene = null
func _ready():
	hide()
	reset()
	pass

func reset():
#	Global.highscore = 0
	Global.gameover = false
	pass

func play_score_anim():
	label_anim.play("scale")
	pass

func get_screen():
	return get_viewport_rect().size
	pass

func _start():
	show()
	enter()
	pass

func enter():
	spots.position.y = get_screen().y
	anim.play("enter")
	tween.start()
	tween.interpolate_property(spots, "position:y", get_screen().y, 0, 0.4, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	
	yield(tween, "tween_completed")
	obstacle_spawner._start()
	player_controller._start()
	player_controller.instanceBall()
	reset()
	
	pass

func exit():
	tween.start()
	tween.interpolate_property(spots, "position:y", position.y, -get_screen().y, 0.45, Tween.TRANS_BACK, Tween.EASE_IN)
	anim.play("exit")
	
	yield(tween, "tween_completed")
	main_scene._intro()
#	queue_free()
	pass

func _on_GameoverBtn_pressed():
#	get_tree().reload_current_scene()
	player_controller.gameover()
	exit()
	gameover.hide()
	pass # Replace with function body.

