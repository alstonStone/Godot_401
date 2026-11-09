class_name Player
extends CharacterBody2D

signal shot_fired(global_position: Vector2, global_rotation: float, damage: int)

enum State {Moving, Hurting, Dying}
var state := State.Moving

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var weapon_pivot: Node2D = $WeaponPivot
@onready var body_sprite: Sprite2D = $BodySprite
@onready var weapon: Weapon = $WeaponPivot/Weapon
@onready var gun_tip: Marker2D = $WeaponPivot/GunTip
@onready var attack_timer: Timer = $AttackTimer
@onready var magnet_area: Area2D = $MagnetArea
@onready var magnet_sphere: CollisionShape2D = $MagnetArea/MagnetSphere
@onready var hitbox_area: Area2D = $HitboxArea

@onready var current_health: int = max_health

@export var speed: int = 4000
@export var fire_rate: float = 4.0 #shots per second
@export var damage_min: int = 3
@export var damage_max: int = 8
@export var magnet_strength: float = 20.0
@export var max_health: int = 3

@export var coins_collected: int = 0



func _ready() -> void:
	attack_timer.start(1 / fire_rate)
	magnet_sphere.shape.radius = magnet_strength


func _physics_process(delta: float) -> void:
	if state != State.Dying:
		var direction := Input.get_vector("move_left","move_right","move_up","move_down")
		velocity = (direction * speed) * delta
		move_and_slide()
		play_moving_animation(direction)
		aim_at(get_global_mouse_position())
		attract_coins(delta)


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
	if state != State.Dying:
		weapon.shoot()
		var damage := randi_range(damage_min,damage_max)
		shot_fired.emit(gun_tip.global_position, gun_tip.global_rotation,damage)


func get_random_spawn_position() -> Vector2:
	var random_angle := randf_range(0, TAU)
	return position + Vector2.from_angle(random_angle) * 250
	

func add_coin(amount: int) -> void:
	coins_collected += amount
	print("coins: %d" % coins_collected)


func attract_coins(delta: float) -> void: 
	for area: Area2D in magnet_area.get_overlapping_areas():
		if area is Coin:
			var coin: Coin = area
			var coin_direction = coin.global_position.direction_to(global_position)
			coin.position += coin_direction * magnet_strength * delta


func check_for_overlapping_enemies(body: Node2D) -> void:
	if body is Enemy and state == State.Moving:
		current_health -= 1
		if current_health <= 0:
			state = State.Dying
			print("im dead")
		else:
			state = State.Hurting
			animation_player.play("hurt")

func play_moving_animation(direction: Vector2) -> void:
		if state == State.Moving:
			if direction != Vector2.ZERO :
				animation_player.play("walk")
			else:
				animation_player.play("idle")

func finish_hurting() -> void:
	state = State.Moving
	animation_player.play("walk")
	for body in hitbox_area.get_overlapping_bodies():
		check_for_overlapping_enemies(body)
