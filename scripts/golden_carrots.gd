extends Node2D

signal carrots_finished

func _ready():
	#play(3)
	pass

func play(carrots):
	carrots = clamp(carrots, 0, 3)
	for c in range(carrots):
		var carrot = get_child(c)
		carrot.play()
		yield(carrot, "finished")
	emit_signal("carrots_finished")
