extends Control

@onready var coins_counter: Label = $TextureRect/coins_counter


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	coins_counter.text = str(Globals.coins)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	coins_counter.text = str(Globals.coins)
