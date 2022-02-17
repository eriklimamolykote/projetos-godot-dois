extends Node

enum {MENU, LOADING, LOADED}

var status = MENU

var current_music
var current_stage
var loaded_stage
var ref_stage
var stage_coins

func _ready():
	add_to_group("game")
	$HUD/stage_exit.hide()

func stage_selected(button):
	if status == MENU:
		status = LOADING
		current_stage = button.stage
		current_music = button.music
		$interface.hide()
		load_stage()
		$HUD/controls.show()
		$HUD/stage_exit.show()
		status = LOADED

func load_stage():
	stage_coins = 0
	$HUD/controls/coin_counter.coins = 0
	if loaded_stage != null && ref_stage.get_ref() != null:
		loaded_stage = queue_free()
	loaded_stage = load(current_stage).instance()
	ref_stage = weakref(loaded_stage)
	if current_music:
		$music.stream = load(current_music)
	add_child(loaded_stage)	
	$HUD/countdown/anim.play("count")
	yield($HUD/countdown/anim, "animation_finished")
	get_tree().call_group("player", "start")
	play_music()
	print(stage_coins)

func player_died():
	stop_music()
	load_stage()
	
func player_dying():
	stop_music()	

func player_victory():
	stop_music()
	$stage_victory.play()
	var t = get_tree().create_timer(4)
	yield(t, "timeout")
	exit_stage()
	print(float($HUD/controls/coin_counter.coins) / float(stage_coins))
	
func _on_stage_exit_pressed():
	stop_music()
	exit_stage()	
	
func exit_stage():
	stop_music()
	loaded_stage.queue_free()
	$interface.show()
	$HUD/controls.hide()
	$HUD/stage_exit.hide()
	$HUD/countdown.hide()
	status = MENU	

func play_music():
	if current_music:
		$music.play()

func stop_music():
	$music.stop()

func add_stage_coins():
	stage_coins += 1
