extends RigidBody2D


func _ready():
	pass


func _on_VisibilityNotifier2D_screen_exited():
	call_deferred("queue_free")
	pass # Replace with function body.
