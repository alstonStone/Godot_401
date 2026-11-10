class_name UI
extends CanvasLayer

@export var player: Player = null
@export var game_duration_min: int = 20

@onready var time_left_label: Label = $TimeLeftLabel
@onready var coin_label: Label = $CoinLabel
@onready var health_labels: Label = $HealthLabels

var secs_since_start := 0.0

func _process(delta: float) -> void:
	secs_since_start += delta
	if player != null:
		
		pass
