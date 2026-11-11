class_name UI
extends CanvasLayer

signal restart_game

@export var player: Player = null
@export var game_duration_min: int = 5

@onready var time_left_label: Label = $TimeLeftLabel
@onready var coin_label: Label = $CoinLabel
@onready var health_labels: Label = $HealthLabels
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var game_over_panel: TextureRect = $GameOverPanel
@onready var game_over_time_label: Label = $GameOverPanel/GameOverTimeLabel
@onready var game_won_score_label: Label = $GameWonPanel/GameWonScoreLabel

var secs_since_start := 0.0
var player_is_alive: bool =  true

func _ready() -> void:
	player.dead.connect(_on_player_dead)


func _process(delta: float) -> void:
	secs_since_start += delta
	if player != null and player_is_alive:
		update_coin_label(player.coins_collected)
		update_health_label(player.current_health,player.max_health)
		update_time_left_label()


func update_coin_label(amount: int) -> void:
	coin_label.text = "%04d" % amount

func update_health_label(current: int, max: int) -> void:
	health_labels.text = "%02d/%02d"%[current,max]

func update_time_left_label() -> void:
	var seconds_left: int= (game_duration_min * 60) - secs_since_start
	if seconds_left <= 0:
		player_wins()
	var mins: int = seconds_left / 60
	var secs: int = seconds_left - (mins * 60)
	time_left_label.text = "%02d:%02d" %[mins,secs]


func _on_player_dead() -> void:
	player_is_alive = false
	animation_player.play("gameover")
	game_over_time_label.text = "TIME LEFT:  "+time_left_label.text
	get_tree().paused = true

func player_wins() -> void:
	player_is_alive = false
	game_won_score_label.text = "SCORE:  "+str(player.coins_collected)
	animation_player.play("youwin")
	
	get_tree().paused = true

func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	game_over_panel.visible = false
	restart_game.emit()
