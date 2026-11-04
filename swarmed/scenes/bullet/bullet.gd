class_name Bullet
extends AnimatableBody2D


var speed := 300

func _physics_process(delta: float) -> void:
	var direction := Vector2.from_angle(global_rotation)
	move_and_collide(direction * speed * delta)


func _on_screen_exited() -> void:
	queue_free()
