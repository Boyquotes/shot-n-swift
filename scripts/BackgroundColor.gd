extends CanvasLayer

onready var color = $ColorRect
onready var tween = $Tween

var colors = [
	"122025", #green blue
	"121225",
	"252512", #green yellow
	"251217",
	"121825",
]
var color_index = null

func _ready():
	start()
	pass

func start():
	if Global.level >= 10:
		color_index = 0
	if Global.level >= 20:
		color_index = 1
	if Global.level >= 30:
		color_index = 2
	if Global.level >= 40:
		color_index = 3
	if Global.score >= 50:
		color_index = 4
	
	if color_index == null: 
		color_index = 0
		return
	var new_color = Color(colors[color_index])
	tween.start()
	tween.interpolate_property(color, "color", color.color, new_color, 3, Tween.TRANS_BACK, Tween.EASE_OUT)
	
	pass

func change_background():
	var new_color = Color(colors[color_index])
	if color_index < colors.size() - 1: color_index += 1
	else: color_index = 0
	tween.start()
	tween.interpolate_property(color, "color", color.color, new_color, 3, Tween.TRANS_BACK, Tween.EASE_OUT)
	
