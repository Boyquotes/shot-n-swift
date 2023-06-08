extends Control

onready var tween = $Animations/Tween
onready var game_title = $GameTitle
onready var game_title_anim = $Animations/GameTitleAnim
var world = null
onready var timer = $Timers/Timer
onready var highscore_label = $GameTitle/CenterContainer/VBoxContainer2/Score/HBoxContainer/Label2

onready var sound_node = $GameTitle/CenterContainer/VBoxContainer2/VBoxContainer/HBoxContainer/Panel/TextureRect
var soundon_image = "res://assets/icons/audioOn.png"
var soundoff_image = "res://assets/icons/audioOff.png"

func _ready():
	if Global.sound: sound_node.texture = load(soundon_image)
	else: sound_node.texture = load(soundoff_image)
	
	highscore_label.text = str(format_number(Global.highscore))
	game_title_anim.play("intro")
#	game_title.rect_position.y = 0
	pass

func format_number(value):
	var result = value
	if value >= 1000: result = str(stepify(value /1000.0, 0.1)) + "K"
	if value >= 1000000: result = str(stepify(value /1000000.0, 0.1)) + "M"
	if value >= 1000000000: result = str(stepify(value /1000000000.0, 0.1)) + "G"
	return result
	pass

func get_screen():
	return get_viewport_rect().size
	pass

func _intro() -> void:
	Global.saveData()
	Global.level = Global.main_level
	Global.currentPoints = 0
	Global.levelPoints = Global.mainPoints
	highscore_label.text = str(format_number(Global.highscore))
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


func _on_Panel2_gui_input(event):
	if event is InputEventMouseButton:
		OS.shell_open("https://twitter.com/ragehive")
	pass # Replace with function body.


func _on_Panel_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		Global.sound = !Global.sound
		Global.saveData()
		
		if Global.sound: sound_node.texture = load(soundon_image)
		else: sound_node.texture = load(soundoff_image)
		
		if Global.sound: AudioServer.set_bus_mute(0, true)
		else: AudioServer.set_bus_mute(0, false)
	pass # Replace with function body.
