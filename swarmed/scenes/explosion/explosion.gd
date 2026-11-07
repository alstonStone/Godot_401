class_name Explosion
extends Area2D

var splash_damage: int = 0


func set_splash_damage(amount: int) -> void:
	splash_damage = amount

func explode() -> void:
	if splash_damage > 0:
		for body: Node2D in get_overlapping_bodies():
			if body is Enemy:
				body.take_damage(splash_damage)
	self.queue_free()
