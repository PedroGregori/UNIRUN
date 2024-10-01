extends Node

# Preload obstacles
var trashCan_scene = preload("res://scenes/trashCan.tscn")
var car_scene = preload("res://scenes/car1.tscn")
var coin_scene = preload("res://scenes/coin.tscn")  # Pré-carregar a cena da moeda
var obstacles_type := [trashCan_scene]
var obstacles: Array = []
var car_heights := [100, 390]

# Game variables
const CHARACTER_START_POS := Vector2i(101, 535)
const CAM_START_POS := Vector2i(576, 324)
var difficulty
const MAX_DIFFICULTY: int = 2
var score: int 
var high_score: int
const SCORE_MODIFIER: int = 10
var speed: float
const START_SPEED: float = 10.0
const SPEED_MODIFIER: int = 5000
const MAX_SPEED: int = 25
var screen_size: Vector2i
var road_height: int
var game_running: bool
var last_obs
var last_coin  # Para armazenar a última moeda gerada

# Called when the node enters the scene tree for the first time.
func _ready():	
	screen_size = get_window().size
	road_height = $Road.get_node("Sprite2D").texture.get_height()
	$GameOver.get_node("Button").pressed.connect(new_game)
	new_game()

func new_game():
	# Reset variables
	score = 0
	Globals.coins = 0
	show_score()
	game_running = false
	get_tree().paused = false
	difficulty = 0
	
	# Delete all obstacles and coins
	for obs in obstacles:
		obs.queue_free()
	obstacles.clear()

	for coin in get_children():  # Remove as moedas
		if coin.name == "Coin":  # Verifique se o nome da cena da moeda é "Coin"
			coin.queue_free()

	# Reset the nodes
	$Character.position = CHARACTER_START_POS
	$Character.velocity = Vector2i(0, 0)
	$Camera2D.position = CAM_START_POS
	$Road.position = Vector2i(0, 0)
	# Reset HUD and game over screen
	$HUD.get_node("ScoreLabel").show()
	$HUD.get_node("StartLabel").show()
	$GameOver.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if game_running:
		# Speed up and adjust difficulty
		speed = START_SPEED + score / SPEED_MODIFIER
		if speed > MAX_SPEED:
			speed = MAX_SPEED
		adjust_difficulty()
		
		# Generate obstacles and coins
		generate_obs()
		generate_coins()  # Chama a função para gerar moedas
		
		# Move character and camera
		$Character.position.x += speed
		$Camera2D.position.x += speed
		
		# Update score
		score += speed
		show_score()
		
		# Update ground position
		if $Camera2D.position.x - $Road.position.x > screen_size.x * 1.5:
			$Road.position.x += screen_size.x
			
		# Remove obstacles and coins that have gone off screen
		for obs in obstacles:
			if obs.position.x < ($Camera2D.position.x - screen_size.x):
				remove_obs(obs)

		for coin in get_children():  # Verifica as moedas
			if coin.name == "Coin" and coin.position.x < ($Camera2D.position.x - screen_size.x):
				coin.queue_free()  # Remove a moeda se estiver fora da tela
	else:
		if Input.is_action_pressed("ui_accept"):
			game_running = true
			$HUD.get_node("StartLabel").hide()

func generate_obs():
	# Generate ground obstacles
	if obstacles.is_empty() or last_obs.position.x < score + randi_range(300, 500):
		var obs_type = obstacles_type[randi() % obstacles_type.size()]
		var obs
		var max_obs = difficulty + 1
		for i in range(randi() % max_obs + 1):
			obs = obs_type.instantiate()
			var obs_height = obs.get_node("Sprite2D").texture.get_height()
			var obs_scale = obs.get_node("Sprite2D").scale
			var obs_x: int = screen_size.x + score + 100 + (i * 100)
			var obs_y: int = screen_size.y - road_height - (obs_height * obs_scale.y / 5) + 25
			last_obs = obs
			add_obs(obs, obs_x, obs_y)

func generate_coins():
	# Generate coins
	if last_coin == null or last_coin.position.x < score + randi_range(50, 100):
		var coin = coin_scene.instantiate()  # Instancia a moeda
		var coin_x: int = screen_size.x + score + 200
		var coin_y: int = screen_size.y - road_height + -25  # Ajuste para a altura desejada
		last_coin = coin
		add_coin(coin, coin_x, coin_y)

func add_obs(obs, x, y):
	obs.position = Vector2i(x, y)
	obs.body_entered.connect(hit_obs)
	add_child(obs)
	obstacles.append(obs)

func add_coin(coin, x, y):
	coin.position = Vector2i(x, y)
	add_child(coin)  # Adiciona a nova moeda à cena

func remove_obs(obs):
	obs.queue_free()
	obstacles.erase(obs)

func hit_obs(body):
	if body.name == "Character":
		game_over()

func show_score():
	$HUD.get_node("ScoreLabel").text = "SCORE: " + str(score / SCORE_MODIFIER)

func check_high_score():
	if score > high_score:
		high_score = score
		$HUD.get_node("HighScoreLabel").text = "HIGH SCORE: " + str(high_score / SCORE_MODIFIER)

func adjust_difficulty():
	difficulty = score / SPEED_MODIFIER
	if difficulty > MAX_DIFFICULTY:
		difficulty = MAX_DIFFICULTY

func game_over():
	check_high_score()
	get_tree().paused = true
	game_running = false
	$GameOver.show()
