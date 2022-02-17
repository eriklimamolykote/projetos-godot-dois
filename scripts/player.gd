extends KinematicBody2D

const velX = 500
const grav = 1500
var velocity = Vector2(500, 0)
var jump = false
var jump_release = false
var was_on_floor = false
var controlled_jump = false

onready var mask = collision_mask
onready var layer = collision_layer

enum {IDLE, RUNNING, FLYING, DEAD, VICTORY}

var status = IDLE

func _ready():
	add_to_group("player")
	$sprite.play("idle")
	set_process_input(true)
	
func _physics_process(delta):
	if status == RUNNING:
		$wings.visible = false
		running(delta)
	elif status == FLYING:
		$wings.visible = true
		flying(delta)
	elif status == DEAD:
		dead(delta)
	
	if status != DEAD:
		if position.y > ProjectSettings.get_setting("display/window/size/height"):
			killed()
						
	jump = false
	jump_release = false	

func running(delta):
	velocity.y += grav * delta
	velocity.x = velX
	velocity = move_and_slide(velocity, Vector2(0, -1))
	
	if is_on_floor():
		if not was_on_floor:
			$anim_landed.play("boing")
			$dust/anim.play("dust")
		$sprite.play("walk")
		if jump:
			jump(770, true)
			$jump.play()
	else:
		$sprite.play("jump")
		if jump_release and velocity.y < 0 and controlled_jump:
			velocity.y *= .3
			
	was_on_floor = is_on_floor()
	
func dead(delta):
	$sprite.play("hurt")
	translate(velocity * delta)
	velocity.y += grav * delta
	if global_position.y > ProjectSettings.get_setting("display/window/size/height") + 100:
		get_tree().call_group("game", "player_died")						

func _input(event):
		if event is InputEventScreenTouch or Input.is_action_pressed("ui_jump"):
			if event.pressed:
				jump = true	
			else:
				jump_release = true
			
func flying(delta):
	velocity.y += grav * delta
	velocity.x = velX
	velocity = move_and_slide(velocity, Vector2(0, -1))
	if jump:
		$wings/anim.play("flap")
		jump(800, true)
		$flap.play()
		
	if is_on_floor():
		if status == RUNNING:
			get_tree().call_group("power_up_bar", "stop")
			powerup_finished()					
						
func jump(force, controlled):
	velocity.y = -force
	controlled_jump = controlled

func killed():
	if status != DEAD:
		status = DEAD
		collision_mask = 0
		collision_layer = 0
		velocity = Vector2(0, -1000)
		$dead.play()
		get_tree().call_group("power_up_bar", "stop")
		get_tree().call_group("game", "player_dying")

func fly():
	$sprite.play("jump")
	jump(800, true)
	status = FLYING
	$wings.visible = true

func victory():
	powerup_finished()
	$sprite.play("victory")
	status = VICTORY
	get_tree().call_group("game", "player_victory")

func powerup_finished():
	if status != DEAD:
		status = RUNNING
		$wings.hide()

func start():
	status = RUNNING
