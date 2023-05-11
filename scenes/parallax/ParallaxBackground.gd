extends ParallaxBackground
# slowest speed = 50 highest speed = 400

var scrolling_speed = 50 
onready var layer1 = $ParallaxLayer

func _ready():
#	init_parrallax()
	set_difficulty()
	pass
	
func set_difficulty():
	randomize()
	if Global.level >= 4:
		scrolling_speed = 70
		pass
	if Global.level >= 8:
		scrolling_speed = 90
		pass
	if Global.level >= 10:
		scrolling_speed = 120
		pass
	if Global.level >= 12:
		scrolling_speed = 140
		pass
	if Global.level >= 16:
		scrolling_speed = 160
		pass
	if Global.level >= 20:
		scrolling_speed = 200
		pass
	if Global.level >= 30:
		scrolling_speed = 250
		pass
	if Global.level >= 40:
		scrolling_speed = 300
		pass
	if Global.level >= 80:
		scrolling_speed = 400
		pass
	pass

func _process(delta):
	scroll_offset.y += scrolling_speed * delta
	scroll_offset.x += scrolling_speed * delta
