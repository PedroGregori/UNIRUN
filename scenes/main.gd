extends Node

#Preload obstacles
var trashCan_scene = preload("res://scenes/trashCan.tscn")
var car_scene = preload("res://scenes/car1.tscn")
var obstacles_type := [trashCan_scene]
var obstacles: Array
var car_heights := []

#Game variables
const CHARACTER_START_POS := Vector2i(101, 535)
const CAM_START_POS := Vector2i(576, 324)
var score: int 
const SCORE_MODIFIER: int = 20
var speed: float
const START_SPEED: float = 10.0
const SPEED_MODIFIER: int = 2500
const MAX_SPEED: int = 25
var screen_size : Vector2i
var game_running: bool

# Called when the node enters the scene tree for the first time.
func _ready():	
	screen_size = get_window().size
	new_game()

func new_game():
	#Reset variables
	score = 0
	show_score()
	#Reset the nodes
	$Character.position = CHARACTER_START_POS
	$Character.velocity = Vector2i(0, 0)
	$Camera2D.position = CAM_START_POS
	$Road.position = Vector2i(0, 0)
	#Reset hud
	$HUD.get_node("ScoreLabel").show()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if game_running:
		speed = START_SPEED + score / SPEED_MODIFIER
		if speed > MAX_SPEED:
			speed = MAX_SPEED
		#print(speed)
		
		#Move character and camera
		$Character.position.x += speed
		$Camera2D.position.x += speed
		
		#Update score
		score += speed
		show_score()
		
		#Update ground position
		if $Camera2D.position.x - $Road.position.x > screen_size.x * 1.5:
			$Road.position.x += screen_size.x
	else:
		if Input.is_action_pressed("ui_accept"):
			game_running = true
			$HUD.get_node("StartLabel").hide()
func show_score():
	$HUD.get_node("ScoreLabel").text = "SCORE: " + str(score/SCORE_MODIFIER)
