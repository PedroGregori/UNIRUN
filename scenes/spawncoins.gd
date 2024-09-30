extends Timer

var coin_scene = preload("res://scenes/coin.tscn")  # Apenas pré-carregue a cena

func _on_timeout() -> void:
	randomize()
	
	var coin = coin_scene.instantiate()  # Instancia a moeda toda vez que o timer expira
	coin.position = Vector2(randf_range(10, 200), randf_range(10, 200))
	add_child(coin)  # Adiciona a nova moeda à cena
	print("dim dim")
	wait_time = randf_range(0.5, 1.5)
