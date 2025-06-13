class_name PlayableCharacter
extends Character

@onready var enemy_slots: Array  = $EnemySlots.get_children()

func _handle_input():
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction  * speed
	
	if Input.is_action_just_pressed("attack") and can_attack():
		character_state = CharacterState.ATTACK
	
	if can_jump() and Input.is_action_just_pressed("jump"):
		character_state = CharacterState.TAKEOFF
	
	if can_jumpkick() and Input.is_action_just_pressed("attack"):
		character_state = CharacterState.JUMPKICK

func reserve_slot(enemy: BasicEnemy) -> EnemySlot:
	var open_slots := enemy_slots.filter(func(slot): return slot.is_free())
	
	if not open_slots:
		return null
	
	open_slots.sort_custom(func (a: EnemySlot, b: EnemySlot):
		var dist_a := (enemy.global_position - a.global_position).length()
		var dist_b := (enemy.global_position - b.global_position).length()
		return dist_a < dist_b
	)
	
	open_slots[0].occupy(enemy)
	
	return open_slots[0]
	
func free_slot(enemy: BasicEnemy) -> void:
	var slot_to_free: Array[EnemySlot] = enemy_slots.filter(
		func(slot: EnemySlot):
			return slot.occupant == enemy
	)
	
	if not slot_to_free:
		return
	
	slot_to_free[0].free_slot()
