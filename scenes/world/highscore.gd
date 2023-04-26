extends Label

onready var controller = $"../../../../../../PlayerController"
onready var score_label = preload("res://scenes/coin/CoinNumberLabel.tscn")
onready var label_container = $"../TextureRect"

func _ready():
	controller.connect("show_score_label", self, "show_score_label")
	pass

func _process(delta) -> void:
	if text != str(Global.score):
		text = str(Global.score)
	pass

func show_score_label():
	var item = score_label.instance()
	add_child(item)
	pass
