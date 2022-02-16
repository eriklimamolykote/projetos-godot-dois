extends Node2D

func _ready():
	pass 

func _on_head_body_entered(body):
	$hurt.play()
	$sprite.visible = false
	$body.collision_mask = 0
	body.jump(800, false)
	#yield($hurt, "finished")
	#queue_free()

func _on_body_body_entered(body):
	print("_on_body_body_entered")
	body.killed()
