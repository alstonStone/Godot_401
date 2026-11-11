class_name World
extends Node2D


const BULLET := preload("res://scenes/bullet/bullet.tscn")
const DAMAGE_LABEL_INDICATOR := preload("res://scenes/damage_label_indicator/damage_label_indicator.tscn")
const EXPLOSION := preload("res://scenes/explosion/explosion.tscn")
const ENEMY := preload("res://scenes/enemy/enemy.tscn")
const COIN = preload("res://scenes/coin/coin.tscn")

@onready var player: Player = $Player


func _ready() -> void:
	spawn_enemies()
	pass


func spawn_enemies() -> void:
	for i: int in 3:
		var new_enemy := ENEMY.instantiate() as Enemy
		new_enemy.hit.connect(_on_enemy_hit)
		new_enemy.explode.connect(_on_enemy_explode)
		new_enemy.drop_coin.connect(spawn_coin)
		new_enemy.player = player
		new_enemy.global_position = player.get_random_spawn_position()
		add_child(new_enemy)
		


func _on_player_shot_fired(global_position: Vector2, global_rotation: float, damage: int) -> void:
	var new_bullet := BULLET.instantiate() as Bullet
	new_bullet.global_position = global_position
	new_bullet.global_rotation = global_rotation
	new_bullet.damage = damage
	add_child(new_bullet)


func _on_enemy_hit(global_position: Vector2, amount: int) -> void:
	var new_damage_label := DAMAGE_LABEL_INDICATOR.instantiate() as DamageLabelIndicator
	add_child(new_damage_label)
	new_damage_label.global_position = global_position
	new_damage_label.set_damage(amount)


func _on_enemy_explode(global_position: Vector2, amount: int) -> void:
	var new_explosion := EXPLOSION.instantiate() as Explosion
	new_explosion.set_splash_damage(amount)
	new_explosion.global_position = global_position
	call_deferred("add_child", new_explosion)
	

func spawn_coin(global_position: Vector2, coin_type: Coin.CoinType) -> void:
	var new_coin := COIN.instantiate() as Coin
	new_coin.type = coin_type
	new_coin.global_position = global_position
	#add_child.call_deferred(new_coin)      Another way of doing call deffered
	call_deferred("add_child", new_coin)


func _on_ui_restart_game() -> void:
	get_tree().reload_current_scene()
