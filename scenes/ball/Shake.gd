extends Node2D

onready var body = $"../body/Sprite"
export var decay = 0.8  # How quickly the shaking stops [0, 1].
export var max_offset = Vector2(10, 10)  # Maximum hor/ver shake in pixels.
export var max_roll = 0.1  # Maximum rotation in radians (use sparingly).

var trauma = 0.0  # Current shake strength.
var trauma_power = 2  # Trauma exponent. Use [2, 3].

func _ready():
	randomize()

func add_trauma(amount):
	trauma = min(trauma + amount, 1.0)

func _process(delta):
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		shake()

func shake():
	var amount = pow(trauma, trauma_power)
	rotation = max_roll * amount * rand_range(-1, 1)
	body.offset.x = body.offset.x * amount * rand_range(-1, 1)
	body.offset.y = body.offset.y * amount * rand_range(-1, 1)