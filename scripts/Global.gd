extends Node

var score = 0
var highscore = 0
var coins = 0
var gameover = false

var level = 1
var currentPoints = 0
var levelPoints = 1

var is_levelup = false
var can_spawn_powerup = true
#save levelup timer waittime

signal diff_increase

var pow_coin = 1
var pow_exp = 1

func _ready():
	pass

func format_number(value):
	var result = value
	if value >= 1000: result = str(stepify(value /1000.0, 0.1)) + "K"
	if value >= 1000000: result = str(stepify(value /1000000.0, 0.1)) + "M"
	if value >= 1000000000: result = str(stepify(value /1000000000.0, 0.1)) + "G"
	return result
	pass
