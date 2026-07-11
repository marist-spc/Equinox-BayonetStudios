extends CharacterBody2D

const SPEED = 600.0 
const JUMP_VELOCITY = -600.0
const DASH_SPEED = 1800.0

var health: int = 4
var can_dash = true
var is_dashing = false
var left = false

var can_shoot: bool = true
@export var shoot_cooldown: float = 0.4 

var bullet = preload("res://bullet.tscn")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("left", "right")

	if direction < 0:
		$AnimatedSprite2D.flip_h = true
		left = true
	elif direction > 0:
		$AnimatedSprite2D.flip_h = false
		left = false

	if is_on_floor():
		if direction != 0:
			$AnimatedSprite2D.play("Run")
		else:
			$AnimatedSprite2D.play("Idle")

	if Input.is_action_just_pressed("run") and can_dash and direction != 0:
		start_dash(direction)

	if is_dashing:
		pass 
	elif direction != 0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	if Input.is_action_just_pressed("shoot") and can_shoot:
		shoot_bullet()

func start_dash(dir: float) -> void:
	is_dashing = true
	can_dash = false
	velocity.x = dir * DASH_SPEED
	
	await get_tree().create_timer(0.2).timeout
	is_dashing = false
	
	await get_tree().create_timer(1.0).timeout
	can_dash = true

func shoot_bullet() -> void:
	can_shoot = false
	
	var bullet_instance = bullet.instantiate()
	bullet_instance.global_position = global_position
	if left:
		bullet_instance.set_direction(-1)
	else:
		bullet_instance.set_direction(1)
	get_parent().add_child(bullet_instance)
	
	await get_tree().create_timer(shoot_cooldown).timeout
	can_shoot = true

func take_damage(amount: int) -> void:
	health -= amount
	print("Player hit! Remaining Health: ", health)
	if health <= 0:
		die()

func die() -> void:
	get_tree().change_scene_to_file("res://restart.tscn")
