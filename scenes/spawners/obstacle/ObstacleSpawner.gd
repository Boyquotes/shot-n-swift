extends Node2D

onready var obstacle_scene = load("res://scenes/obstacle/obstacle.tscn")
onready var coin_scene = load("res://scenes/coin/Coin.tscn")
onready var powerup_scene = load("res://scenes/powerup/PowerUp.tscn")
onready var obstacles = $obstacles
onready var coins = $coins
onready var spawn_timer = $Timer

var obs_speed =  00
var spawn_y_offset : int = 200

var can_spawn = true
var coin_scarce = 1

onready var spawn_pos = get_spawn_pos()

func _ready():
	randomize()
	Global.connect("diff_increase", self, "increase_diff")
	pass

func _start():
	spawn_timer.wait_time = 0.5
	obs_speed = 600
	
	spawn_timer.start()
	
	pass

func increase_diff():
	#highest speed 700, lowest wai time 0.3
	obs_speed += 25
	if spawn_timer.wait_time > 0.2: spawn_timer.wait_time -= 0.025
	pass


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
				var rand = randi()&2
				if rand == 0: instancePowerUp()
				else: instanceCoin() #randCoin()
#				Global.can_spawn_powerup = false
			else: instanceCoin() #randCoin()
		else: instanceCoin()
	can_spawn = !can_spawn
	pass # Replace with function body.


func _on_swapTimer_timeout():
	pass # Replace with function body.

