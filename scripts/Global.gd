extends Node

var score = 0
var highscore = 0
var coins = 0
var gameover = false
var sound = true

var level = 1
var main_level = 1
var currentPoints = 0
var levelPoints = 10
var mainPoints = 10

var is_levelup = false
var can_spawn_powerup = true
#save levelup timer waittime

signal diff_increase

var pow_coin = 1
var pow_exp = 1

var data = {
	"score" : 0,
	"coin": 0,
	"sound": true
}
var data_path = "user://data.json"
var data_file = File.new()

func _ready():
	loadData()
	if sound: AudioServer.set_bus_mute(0, true)
	else: AudioServer.set_bus_mute(0, false)
	pass

func format_number(value):
	var result = value
	if value >= 1000: result = str(stepify(value /1000.0, 0.1)) + "K"
	if value >= 1000000: result = str(stepify(value /1000000.0, 0.1)) + "M"
	if value >= 1000000000: result = str(stepify(value /1000000000.0, 0.1)) + "G"
	return result
	pass

func loadData():
	if not data_file.file_exists(data_path):
		return
	data_file.open(data_path,File.READ)
	data = parse_json(data_file.get_as_text())
	highscore = data["score"]
	score = data["score"]
	coins = data["coins"]
	sound = data["sound"]

func saveData():
	data["score"] = highscore
	data["coins"] = coins
	data["sound"] = sound
	data_file.open(data_path,File.WRITE)
	data_file.store_line(to_json(data))
	data_file.close()
