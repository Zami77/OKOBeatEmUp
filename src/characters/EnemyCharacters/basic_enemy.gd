class_name BasicEnemy
extends Character

@export var player : PlayableCharacter

func _handle_input() -> void:
	if not player:
		return
	
	if not can_move():
		return
		
	if position.distance_to(player.position) < 10:
		return
	
	var direction := (player.position - position).normalized()
	velocity = direction * speed
	
