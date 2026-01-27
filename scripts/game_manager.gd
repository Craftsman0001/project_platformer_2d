extends Node

var coins = 0

@onready var coins_value: Label = $GUI/CoinsValue

func _process(_delta: float) -> void:
	coins_value.text = str(coins)
