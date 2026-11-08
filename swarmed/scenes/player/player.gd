class_name Player
extends CharacterBody2D

signal shot_fired(global_position: Vector2, global_rotation: float, damage: int)

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var weapon_pivot: Node2D = $WeaponPivot
@onready var body_sprite: Sprite2D = $BodySprite
@onready var weapon: Weapon = $WeaponPivot/Weapon
@onready var gun_tip: Marker2D = $WeaponPivot/GunTip
@onready var attack_timer: Timer = $AttackTimer

var speed: int = 4000
@export var fire_rate := 4.0 #shots per second
@export var damage_min := 3
@export var damage_max := 8
@export var coins_collected := 0



func _ready() -> void:
	attack_timer.start(1 / fire_rate)


func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("move_left","move_right","move_up","move_down")
	velocity = (direction * speed) * delta
	move_and_slide()
	if direction != Vector2.ZERO :
		animation_player.play("walk")
	else:
		animation_player.play("idle")
	aim_at(get_global_mouse_position())


func aim_at(target: Vector2) -> void:
	var weapon_direction := weapon_pivot.global_position.direction_to(target)
	weapon_pivot.rotation = weapon_direction.angle()
	if target.x < global_position.x :
		weapon_pivot.scale.y = -1
		body_sprite.flip_h = true
	else:
		weapon_pivot.scale.y = 1
		body_sprite.flip_h = false


func shoot() -> void:
	weapon.shoot()
	var damage := randi_range(damage_min,damage_max)
	shot_fired.emit(gun_tip.global_position, gun_tip.global_rotation,damage)


func get_random_spawn_position() -> Vector2:
	var random_angle := randf_range(0, TAU)
	return position + Vector2.from_angle(random_angle) * 250
	

func add_coin(amount: int) -> void:
	coins_collected += amount
	print("coins: %d" % coins_collected)
