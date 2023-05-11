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
	"Exp Increase",
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
		"Exp Increase":
			label.text = "E"
		"Ricochet":
			ricochet_amt = clamp(int(Global.level + 1), 2, 8)
			label.text = str(ricochet_amt) + "R"
	pass

func set_powerup(ball):
	randomize()
	match powerup:
		"More Coins":
			var rand = randi()%8
			if rand == 0: Global.pow_coin += 1
		"Exp Increase":
			var rand = int(rand_range(1,3))
			print(rand, "exp increase")
			Global.pow_exp += rand
		"Ricochet":
			ball.powerup_ricochet(ricochet_amt)
	
	kill()
	pass

func setParams(_speed: int) -> void:
	speed = _speed
	vel.y = -speed

func kill() -> void:
	print("powerup deleted")
	call_deferred("queue_free")
	pass

func _physics_process(delta) -> void:
	var move_and_collide = move_and_collide(vel * delta)

func _on_VisibilityNotifier2D_screen_exited() -> void:
	if !dead: call_deferred("queue_free")
	pass
