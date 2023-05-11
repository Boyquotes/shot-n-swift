extends Control

onready var level1 = $ProgressBar/LevelPoint1/Label
onready var level2 = $ProgressBar/LevelPoint2/Label
onready var progress = $ProgressBar
onready var level2circle = $ProgressBar/LevelPoint2
onready var tween = $ProgressBar/Tween
onready var controller = $"../.."
var _modulate = "ffee34"

var completed = false

func _ready():
	start()
	pass


func start():
	level1.text = str(Global.level)
	level2.text = str(Global.level + 1)
	progress.value = 0
	progress.max_value = Global.levelPoints
	level2circle.modulate = ColorN("white")
	pass

func enter():
	$AnimationPlayer.play("enter")
	pass

func exit():
	$AnimationPlayer.play_backwards("exit")
	pass
	

func set_points():
	if completed:
		Global.level += 1
		Global.levelPoints += (Global.levelPoints * 0.5)
#		progress.value = 0
		Global.currentPoints = 0
		start()
		tween.start()
		tween.interpolate_property(progress, "value", progress.value, 0, 0.5, Tween.TRANS_ELASTIC, Tween.EASE_IN)
		completed = false
		
		controller.level_up()
		get_tree().get_nodes_in_group("parrallax")[0].set_difficulty()
		return
	
	var value = Global.currentPoints
	if !completed:
		tween.start()
		tween.interpolate_property(progress, "value", progress.value, Global.currentPoints, 0.5, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	
	if value >= Global.levelPoints:
		level2circle.modulate = Color(_modulate)
		completed = true
	pass

	pass
