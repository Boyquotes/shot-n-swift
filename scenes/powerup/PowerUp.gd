extends KinematicBody2D

var speed : int = 100
var vel : Vector2 = Vector2(0,0)

onready var sprite = $ColorRect
onready var obstacle_spawner  = get_parent().get_parent()
onready var collision = $CollisionShape2D
onready var label = $Label
onready var end_anim = $AnimationPlayer2
var dead = false

var type = [
	"More Coins",
	"More Score",
	"Ricochet"
	]

var powerup = ""
var ricochet_amt = 0

func _ready():
	start()
	pass

func start():
	randomize()
	powerup = type[randi()%type.size()]
	match powerup:
		"More Coins":
			label.text = "C"
		"More Score":
			label.text = "S"
		"Ricochet":
			ricochet_amt = int(rand_range(2,10))
			label.text = str(ricochet_amt) + "R"
	pass

func set_powerup(ball):
	randomize()
	match powerup:
		"More Coins":
			print("More Coin activated")
		"More Score":
			print("More Score activated")
		"Ricochet":
			ball.powerup_ricochet(ricochet_amt)
	
	kill()
	pass

func setParams(_speed: int) -> void:
	speed = _speed
	vel.y = -speed

func kill() -> void:
	print("powerup deleted")
	queue_free()
	pass

func _physics_process(delta) -> void:
	var move_and_collide = move_and_collide(vel * delta)

func _on_VisibilityNotifier2D_screen_exited() -> void:
	if !dead: queue_free()
	pass
