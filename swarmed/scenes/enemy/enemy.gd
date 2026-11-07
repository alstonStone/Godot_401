class_name Enemy
extends CharacterBody2D

signal hit(global_position: Vector2, amount: int)

enum State {Moving, Hurting, Dying}

var state := State.Moving

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_start_timer: Timer = $AnimationStartTimer
@onready var body_sprite: Sprite2D = $BodySprite
@onready var current_health := max_health
@onready var damage_label_position: Marker2D = $DamageLabelPosition

@export var player: Player = null
@export var speed: float = 500.0
@export var max_health := 15




func _ready() -> void:
	animation_start_timer.start(randf_range(0,0.6))

func _physics_process(delta: float) -> void:
	if player != null:
		if state == State.Moving:
			var direction := position.direction_to(player.position)
			body_sprite.flip_h = (direction.x < 0)
			velocity = (direction * speed) * delta
		else:
			velocity = Vector2.ZERO
	move_and_slide()


func _on_animation_start_timer_timeout() -> void:
	animation_player.play("walk")


func _on_bullet_detection_area_body_entered(body: Node2D) -> void:
	if body is Bullet:
		hit.emit(damage_label_position.global_position,body.damage)
		current_health = clamp(current_health - body.damage,0,max_health)
		if current_health > 0:
			state = State.Hurting
			animation_player.play("hurt")
		else:
			state = State.Dying
			self.queue_free()
		body.queue_free()

func take_damage(amount: int) -> void:
	pass


func recover() -> void:
	animation_player.play("walk")
	state = State.Moving
