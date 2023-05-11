extends Node2D

onready var obstacle_scene = load("res://scenes/obstacle/obstacle.tscn")
onready var coin_scene = load("res://scenes/coin/Coin.tscn")
onready var powerup_scene = load("res://scenes/powerup/PowerUp.tscn")
onready var obstacles = $obstacles
onready var coins = $coins
onready var spawn_timer = $Timer

#slowest speed 600 highest speed 
var main_speed = 600
onready var obs_speed = main_speed
var main_wait_time = 0.5
onready var wait_time = main_wait_time

var spawn_y_offset : int = 200

var can_spawn = true
var coin_scarce = 1

onready var spawn_pos = get_spawn_pos()

func _ready():
	randomize()
	Global.connect("diff_increase", self, "set_difficulty")
	pass

func _start():
	spawn_timer.wait_time = 0.5
	obs_speed = 600
	
	set_difficulty()
	spawn_timer.start()
	pass
	
func set_difficulty():
	var time = 0.01
	var speed = -50
	
	randomize()
	if Global.level >= 4:
		time = 0.025
		speed = 10
		pass
	if Global.level >= 8:
		time = 0.05
		speed = 30
		pass
	if Global.level >= 10:
		time = 0.1
		speed = 40
		pass
	if Global.level >= 12:
		time = 0.15
		speed = 50
		pass
	if Global.level >= 16:
		time = 0.16
		speed = 100
		pass
	if Global.level >= 20:
		time = 0.17
		speed = 150
		pass
	if Global.level >= 30:
		time = 0.18
		speed = 250
		pass
	if Global.level >= 40:
		time = 0.2
		speed = 300
		pass
	if Global.level >= 80:
		time = 0.2
		speed = 400
		pass
	
	obs_speed = main_speed + speed
	
	wait_time = main_wait_time - time
	spawn_timer.wait_time = wait_time
	pass

#func increase_diff():
#	#highest speed 700, lowest wai time 0.3
#	obs_speed += 15
#	if spawn_timer.wait_time > 0.2: spawn_timer.wait_time -= 0.015
#	pass


func get_spawn_pos():
	var rect = get_viewport_rect().size
	var x = rect.x/2
	var y = rect.y + spawn_y_offset
	return Vector2(x, y)
	pass


func setParams(item) -> void:
	item.setParams(obs_speed)
	item.position = spawn_pos
	pass

func instanceEnemy() -> void:
	var item = obstacle_scene.instance()
	setParams(item)
	obstacles.add_child(item)
	pass

func instanceCoin() -> void:
	var item = coin_scene.instance()
	setParams(item)
	coins.add_child(item)
	pass

func instancePowerUp() -> void:
	var item = powerup_scene.instance()
	setParams(item)
	coins.add_child(item)
	pass

func randCoin() -> void:
	randomize()
	var rand_num = randi()% (coin_scarce + 1)
	if rand_num == 0: instanceCoin()

func _on_Timer_timeout() -> void:
	if Global.gameover:  
		spawn_timer.stop()
		return
	if can_spawn: 
		if !Global.is_levelup: 
			var rand = randi()&2
			if rand == 0: instanceEnemy()
			else: instanceCoin()
		else: instanceCoin()
		pass
	else:
		if !Global.is_levelup:
			if Global.can_spawn_powerup:
				randomize()
				var rand = randi()&8
				if rand == 0: 
					instancePowerUp()
					Global.can_spawn_powerup = false
				else: instanceCoin() #randCoin()
			else: instanceCoin() #randCoin()
		else: 
			if (Global.level) % 5 == 0: instancePowerUp()
			else: instanceCoin()
	can_spawn = !can_spawn
	pass # Replace with function body.


func _on_swapTimer_timeout():
	pass # Replace with function body.

