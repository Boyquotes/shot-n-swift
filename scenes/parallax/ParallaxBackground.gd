extends ParallaxBackground


export (float) var scrolling_speed = 80.0
onready var layer1 = $ParallaxLayer

func _ready():
#	init_parrallax()
	pass

func _physics_process(delta):
	scroll_offset.y += scrolling_speed * delta
	scroll_offset.x += scrolling_speed * delta
