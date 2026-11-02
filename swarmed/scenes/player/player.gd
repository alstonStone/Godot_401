class_name Player
extends CharacterBody2D

var speed: int = 4000

func _physics_process(delta: float) -> void:
	var x_dir:= 0
	var y_dir := 0
	if Input.is_action_pressed("move_down"):
		y_dir+=1
	if Input.is_action_pressed("move_up"):
		y_dir-=1
	if Input.is_action_pressed("move_left"):
		x_dir-=1
	if Input.is_action_pressed("move_right"):
		x_dir+=1
		
	var direction := Vector2(x_dir,y_dir)
	velocity = (direction * speed) * delta 
	move_and_slide()
