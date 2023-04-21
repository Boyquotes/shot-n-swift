extends CenterContainer

onready var progress = $VBoxContainer/TextureProgress
onready var increase_tween = $VBoxContainer/Tween
onready var reduce_tween = $VBoxContainer/Tween2
onready var controller = $"../../../PlayerController"

var energy_amt = 20
var energy_reduce = 400

var ricochet_amt = 10
var ricochet_playing = false

func _ready():
	Global.connect("add_energy", self, "add_energy")

func add_energy():
	increase_tween.start()
	increase_tween.interpolate_property(progress, "value", progress.value, progress.value + energy_amt, 0.4, Tween.TRANS_ELASTIC,Tween.EASE_OUT)
	
	print(progress.value, " :progress value")
	yield(increase_tween, "tween_completed")
	if progress.value >= 60 and (!ricochet_playing):
		print("yes ricochet")
		ricochet_playing = true
		controller.ball_ricochet(ricochet_amt)
		progress.value = 0
	pass

func _process(delta):
	if progress.value:
		progress.value = move_toward(progress.value, 0, energy_reduce * delta)
