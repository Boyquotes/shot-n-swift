extends Control

onready var tween = $Animations/Tween
onready var game_title = $GameTitle
onready var game_title_anim = $Animations/GameTitleAnim
var world = null
onready var timer = $Timers/Timer
onready var highscore_label = $GameTitle/CenterContainer/VBoxContainer2/Score/HBoxContainer/Label2

func _ready():
#	_intro()
	highscore_label.text = str(Global.highscore)
	game_title_anim.play("intro")
#	game_title.rect_position.y = 0
	pass

func get_screen():
	return get_viewport_rect().size
	pass

func _intro() -> void:
	highscore_label.text = str(Global.highscore)
	game_title_anim.play("intro")
	tween.start()
	tween.interpolate_property(game_title, "rect_position:y", -get_screen().y/1.5, 0, 0.35, Tween.TRANS_CIRC, Tween.EASE_OUT)
	pass

func _outro() -> void:
	game_title_anim.play("outro")
	tween.start()
	tween.interpolate_property(game_title, "rect_position:y", 0, -get_screen().y, 0.45, Tween.TRANS_BACK, Tween.EASE_IN)
	
	yield(tween, "tween_completed")
	world._start()
	
	pass

func enter_gameover():
	
	pass

func exit_gameover():
	pass
	
func _on_startButton_pressed():
	_outro()
	pass # Replace with function body.
