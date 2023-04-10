extends Node

var slowmo_active: bool = false
export (float) var normal_time_scale: float = 1.0
export (float) var slow_mo_time_scale: float = 0.06


export (float) var enter_time: float = 0.1
export (float) var exit_time: float = 0.28

onready var tween = $Tween
onready var timer = $Timer

func _ready():
	pass

func enter_slowmo():
	get_parent().start_slowmo()
	tween.stop_all()
	tween.interpolate_property(Engine, "time_scale", Engine.time_scale, slow_mo_time_scale, enter_time, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()
	timer.start()
	yield(tween, "tween_completed")
	yield(timer, "timeout")
	exit_slowmo()
	pass

func exit_slowmo():
	tween.stop_all()
	tween.interpolate_property(Engine, "time_scale", Engine.time_scale, normal_time_scale, exit_time, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()
	
	get_parent().end_slowmo()
	yield(tween, "tween_completed")
#	end_slowmo()
	pass

func start_slowmo():
	Engine.time_scale = slow_mo_time_scale
	slowmo_active = true
	pass

func end_slowmo():
	Engine.time_scale = normal_time_scale
	slowmo_active = false
	pass

#func request_slowmo_change():
#	print("request slowmo", slowmo_active)
#	if !slowmo_active:
#		enter_slowmo()
#	else:
#		exit_slowmo()
#	pass
