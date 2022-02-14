extends KinematicBody2D

const velX = 500
const grav = 1500
var velocity = Vector2(500, 0)
var jump = false
var jump_release = false
var was_on_floor = false

func _ready():
	set_process_input(true)
	
func _physics_process(delta):
	velocity.y += grav * delta
	velocity.x = velX
	velocity = move_and_slide(velocity, Vector2(0, -1))
	
	if is_on_floor():
		if not was_on_floor:
			$anim_landed.play("boing")
		$sprite.play("walk")
		if jump:
			velocity.y = -1000
	else:
		$sprite.play("jump")
		if jump_release:
			velocity.y *= .3	
	
	was_on_floor = is_on_floor()		
	jump = false
	jump_release = false	

func _input(event):
	if Input.is_action_pressed("ui_jump"):
		if event.pressed:
			jump = true
		else:
			jump_release = true
				
	pass
		
