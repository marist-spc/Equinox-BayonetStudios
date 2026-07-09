extends CharacterBody2D


const SPEED = 800.0
const JUMP_VELOCITY = -600.0
const DASHSPEED = 1300
var canDash = true
var left

func _physics_process(delta: float) -> void:
		
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
		$AnimatedSprite2D.play("Run")
		left = true
	elif Input.is_action_pressed("right"):
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play("Run")
		left = false
	else:
		$AnimatedSprite2D.play("Idle")
	
	var direction := Input.get_axis("left", "right")
	
	if direction:
		velocity.x = direction * SPEED
		
	#elif Input.is_action_just_pressed("run") and canDash:
		#velocity.x = direction * DASHSPEED
		#await get_tree().create_timer(1).timeout 
		#canDash = false
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	#if not canDash:
		#await get_tree().create_timer(1).timeout 
		#canDash = true
	
	
	var bulletSprite = Sprite2D.new()
	bulletSprite.texture = load("res://Art/Player/Bullet.png")
#	-1373, 1838
	if Input.is_action_just_pressed("shoot"):
		
		bulletSprite.scale = Vector2(.3, .3)
		if left:
			bulletSprite.global_position = Vector2(self.global_position.x, self.global_position.y)
			bulletSprite.rotation = PI
		else:
			bulletSprite.global_position = Vector2(self.global_position.x, self.global_position.y)
		add_child(bulletSprite)
			
		var tween = get_tree().create_tween()
		tween.tween_property(bulletSprite, "position", Vector2(self.global_position.x * 1.2, self.global_position.y), 0.40)
		tween.tween_callback(bulletSprite.hide.bind())
		

	move_and_slide()
