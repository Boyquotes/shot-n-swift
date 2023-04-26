extends Node

var slowmo_active: bool = false
export (float) var normal_time_scale: float = 1.0
export (float) var slow_mo_time_scale: float = 0.06


export (float) var enter_time: float = 0.1
export (float) var exit_time: float = 0.2

onready var tween = $Tween
onready var timer = $Timer

func _ready():
	pass

func enter_slowmo():
	get_parent().next_target_time = 0.4
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
	get_parent().next_target_time = 0.1
#	end_slowmo()
	pass

func enter_slowmo_ricochet():
	get_parent().next_target_time = 0.4
	get_parent().start_slowmo()
	tween.stop_all()
	tween.interpolate_property(Engine, "time_scale", Engine.time_scale, 0.2, enter_time, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()
#	timer.start()
	yield(tween, "tween_completed")
#	yield(timer, "timeout")
	exit_slowmo_ricochet()
	pass

func exit_slowmo_ricochet():
	tween.stop_all()
	tween.interpolate_property(Engine, "time_scale", Engine.time_scale, normal_time_scale, exit_time, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()
	
	get_parent().end_slowmo()
	yield(tween, "tween_completed")
	get_parent().next_target_time = 0.1
#	end_slowmo()
	pass
