extends Node2D

onready var tween = $Tween
onready var body = $Body
func _ready():
	wiggle()
	pass

func wiggle():
	tween.start()
	tween.interpolate_property(body, "scale:x", 1, 1.2, 0.4,Tween.TRANS_BOUNCE,Tween.EASE_IN)
