extends CharacterBody2D

const GRAVITY: int = 2100
const JUMP_SPEED: int = -850

func _physics_process(delta):
	# Aplique a gravidade
	velocity.y += GRAVITY * delta
	
	# Verifique se o personagem está no chão
	if is_on_floor():
		if not get_parent().game_running:
			$AnimatedSprite2D.play("idle")
		else:
			if Input.is_action_pressed("ui_accept"):
				velocity.y = JUMP_SPEED  # Pula
			else:
				$AnimatedSprite2D.play("run")
	else:
		# Se não estiver no chão
		if Input.is_action_pressed("Slide"):  # Verifica se a tecla "S" está pressionada
			velocity.y = 1000  # Faz com que o personagem caia rapidamente
		$AnimatedSprite2D.play("jump")
	
	move_and_slide()
