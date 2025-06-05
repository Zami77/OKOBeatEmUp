class_name PlayableCharacter
extends Character

func _handle_input():
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction  * speed
	
	if Input.is_action_just_pressed("attack") and can_attack():
		character_state = CharacterState.ATTACK
	
	if can_jump() and Input.is_action_just_pressed("jump"):
		character_state = CharacterState.TAKEOFF
	
	if can_jumpkick() and Input.is_action_just_pressed("attack"):
		character_state = CharacterState.JUMPKICK
