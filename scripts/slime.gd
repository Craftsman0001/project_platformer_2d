extends CharacterBody2D

const SPEED: float = 20.0

@onready var ray_cast_bottom_right: RayCast2D = $RayCastBottom
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var killzone: Area2D = $Killzone

var direction: int = 1
var is_dead: bool = false

func add_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	else :
		velocity.y = 0

func move_enemy() -> void:
	if not is_dead:
		velocity.x = direction * SPEED
	else:
		velocity.x = 0
	move_and_slide()

func change_direction() -> void:
	if not ray_cast_bottom_right.is_colliding() or ray_cast_right.is_colliding():
		direction *= -1
		animated_sprite_2d.scale.x = direction
		ray_cast_bottom_right.position.x *= -1
		ray_cast_right.position.x *= -1
		ray_cast_right.scale.x *= -1 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	add_gravity(delta)
	move_enemy()
	change_direction()

func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation == "death":
		queue_free()


func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.name == "PlayerAttackZone":
		is_dead = true
		killzone.set_deferred("monitoring", false)
		killzone.set_deferred("monitorable", false)
		animated_sprite_2d.play("death")
