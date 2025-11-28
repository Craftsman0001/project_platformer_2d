extends CharacterBody2D

const SPEED = 180.0
const JUMP_VELOCITY = -400.0

@onready var animated_sprite_2d: AnimatedSprite2D = $Marker2D/AnimatedSprite2D
@onready var marker_2d: Marker2D = $Marker2D
@onready var attack_zone: CollisionShape2D = $Marker2D/AnimatedSprite2D/AttackZone/CollisionShape2D

var is_attacking = false

func _physics_process(delta: float) -> void:
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if is_attacking == false:
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			
		# Handle attack
		if Input.is_action_just_pressed("attack") and is_on_floor():
			animated_sprite_2d.play("attack")
			is_attacking = true
			attack_zone.disabled = false
			velocity.x = 0

	# Get the input direction : -1, 0, 1
	var direction := Input.get_axis("move_left", "move_right")
	
	# Flip the sprite
	if not is_attacking:
		if direction > 0:
			#animated_sprite_2d.flip_h = false
			marker_2d.scale.x = 1
		elif direction < 0:
			#animated_sprite_2d.flip_h = true
			marker_2d.scale.x = -1
	
	# Play animations
	if is_attacking == false:
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
	
	# Apply movement
	if not is_attacking:
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	else:
		velocity.x = 0
	move_and_slide()

func _on_animated_sprite_2d_animation_finished() -> void:
		if animated_sprite_2d.animation == "attack":
			attack_zone.disabled = true
			is_attacking = false
