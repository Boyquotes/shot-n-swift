extends Node

var score = 0
var highscore = 0
var coins = 0
var gameover = false

var level = 1
var currentPoints = 0
var levelPoints = 20

var is_levelup = false
var can_spawn_powerup = true
#save levelup timer waittime

signal diff_increase

func _ready():
	pass
