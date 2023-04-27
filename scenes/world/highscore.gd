extends Label

func _ready():
	pass

func _process(delta) -> void:
	if text != str(Global.score):
		text = str(Global.score)
	pass
