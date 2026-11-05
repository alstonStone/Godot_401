class_name World
extends Node2D


const BULLET := preload("res://scenes/bullet/bullet.tscn")


func _on_player_shot_fired(global_position: Vector2, global_rotation: float, damage: int) -> void:
	var new_bullet := BULLET.instantiate()
	new_bullet.global_position = global_position
	new_bullet.global_rotation = global_rotation
	new_bullet.damage = damage
	add_child(new_bullet)
