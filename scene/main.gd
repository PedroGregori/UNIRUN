extends Node

const CHARACTER_START_POS := Vector2i(101, 535)
const CAM_START_POS := Vector2i(576, 324)

var speed: float
const START_SPEED: float = 10.0
const MAX_SPEED: int = 25
var screen_size : Vector2i

# Called when the node enters the scene tree for the first time.
func _ready():	
	screen_size = get_window().size
	new_game()

func new_game():
	#reset the nodes
	$Character.position = CHARACTER_START_POS
	$Character.velocity = Vector2i(0, 0)
	$Camera2D.position = CAM_START_POS
	$Road.position = Vector2i(0, 0)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	speed = START_SPEED
	
	#Move character and camera
	$Character.position.x += speed
	$Camera2D.position.x += speed
	
	#update ground position
	if $Camera2D.position.x - $Road.position.x > screen_size.x * 1.5:
		$Road.position.x += screen_size.x
