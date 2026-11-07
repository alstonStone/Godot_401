class_name World
extends Node2D


const BULLET := preload("res://scenes/bullet/bullet.tscn")
const DAMAGE_LABEL_INDICATOR = preload("res://scenes/damage_label_indicator/damage_label_indicator.tscn")


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
