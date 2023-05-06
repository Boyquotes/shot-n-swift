extends Control

onready var main_scene = load("res://scenes/mainmenu/MainMenu.tscn")
onready var world_scene = load("res://scenes/world/World.tscn")
onready var timer = $Timer
onready var anim = $AnimationPlayer

func _ready():
	anim.play("fade_in")
	$Tween.start()
	$Tween.interpolate_property($body/TextureRect,"rect_scale",Vector2(0.5,0.5),Vector2(1,1),0.8,Tween.TRANS_BOUNCE,Tween.EASE_IN)
#INSTANCE NEXT SCENE 
func _next():
	var menu = main_scene.instance()
	var world = world_scene.instance()
	menu.world = world
	world.main_scene = menu
	get_parent().add_child(menu)
	get_parent().add_child(world)
	call_deferred("queue_free")
	pass


func _on_Tween_tween_completed(object, key):
	timer.start()
	yield(timer, "timeout")
	anim.play("fade_out")
	pass # Replace with function body.
