extends CharacterBody2D


var speed = 500.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("run") and is_on_floor():
		speed = 1000.0
	elif not Input.is_action_pressed("run") or not is_on_floor():
		speed = 500.0
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	elif Input.is_action_pressed("jump") and not is_on_floor():
		pass
		#$AnimatedSprite2D.play("Jump")

	if Input.is_action_pressed("left"):
		$AnimatedSprite2D.flip_h = true
		#$AnimatedSprite2D.play("Walk")
	elif Input.is_action_pressed("right"):
		$AnimatedSprite2D.flip_h = false
		#$AnimatedSprite2D.play("Walk")
	else:
		$AnimatedSprite2D.play("Idle")
	
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		

	move_and_slide()
