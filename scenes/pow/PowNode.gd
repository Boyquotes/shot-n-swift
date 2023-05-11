extends Node2D

onready var tween = $Tween
onready var body = $Body

func _ready():
	start()
	pass

func start():
	tween.start()
	tween.interpolate_property(body, "scale", Vector2(0.2,0.2), Vector2(1,1), 0.1, Tween.TRANS_BOUNCE,Tween.EASE_OUT)
	
	yield(tween,"tween_completed")
	$AnimationPlayer.play("New Anim")
	pass
