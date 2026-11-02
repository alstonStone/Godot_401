class_name Player
extends CharacterBody2D

var speed: int = 4000

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("move_left","move_right","move_up","move_down")
	velocity = (direction * speed) * delta 
	move_and_slide()
