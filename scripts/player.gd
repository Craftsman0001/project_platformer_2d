extends CharacterBody2D

const SPEED: float = 180.0
const JUMP_VELOCITY: float = -400.0

@onready var animated_sprite_2d: AnimatedSprite2D = $Marker2D/AnimatedSprite2D
@onready var marker_2d: Marker2D = $Marker2D
@onready var attack_zone: CollisionShape2D = $Marker2D/AnimatedSprite2D/PlayerAttackZone/CollisionShape2D

var is_attacking: bool = false

func _physics_process(delta: float) -> void:
	handle_gravity(delta)
	handle_jump_and_attack()
	handle_direction()
	handle_animation()
	handle_movement()
	move_and_slide()

func handle_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

func handle_jump_and_attack() -> void:
	if is_attacking:
		return
	# Handle jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
			
	# Handle attack
	if Input.is_action_just_pressed("attack") and is_on_floor():
		animated_sprite_2d.play("attack")
		is_attacking = true
		attack_zone.disabled = false
		velocity.x = 0

func handle_direction() -> void:
	if is_attacking:
		return
	
	# Get the input direction : -1, 0, 1
	var direction := Input.get_axis("move_left", "move_right")
	
	# Flip the sprite
	if direction > 0:
		marker_2d.scale.x = 1
	elif direction < 0:
		marker_2d.scale.x = -1

func handle_animation() -> void:
	if is_attacking:
		return
	
	var direction := Input.get_axis("move_left", "move_right")
	
	# Play animations
	if is_on_floor():
		if direction == 0:
			animated_sprite_2d.play("idle")
		else:
			animated_sprite_2d.play("run")
	else:
		if velocity.y < 0:
			animated_sprite_2d.play("jump")
		else:
			animated_sprite_2d.play("fall")

func handle_movement() -> void:
	var direction := Input.get_axis("move_left", "move_right")
	
	# Apply movement
	if not is_attacking:
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	else:
		velocity.x = 0

func _on_animated_sprite_2d_animation_finished() -> void:
		if animated_sprite_2d.animation == "attack":
			attack_zone.disabled = true
			is_attacking = false
