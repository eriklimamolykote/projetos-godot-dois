extends Button

export(String, FILE) var stage

export(String, FILE) var music

func _ready():
	pass 


func _on_stage_button_pressed():
	get_tree().call_group("game", "stage_selected", self)
