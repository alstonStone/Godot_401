class_name Coin
extends Area2D

enum CoinType {Bronze, Jade, Diamond, Sapphire}
var type := CoinType.Bronze

@onready var coin_sprite: Sprite2D = $CoinSprite


func _ready() -> void:
	coin_sprite.frame = type



func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		var amount := 0
		match type:
			CoinType.Bronze:
				amount = 1
			CoinType.Jade:
				amount = 3
			CoinType.Diamond:
				amount = 5
			CoinType.Sapphire:
				amount = 10
		body.add_coin(amount)
		self.queue_free()
