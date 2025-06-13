class_name BasicEnemy
extends Character

@export var player : PlayableCharacter
@export var player_adjacency_threshold: int = 1

var target_player_slot: EnemySlot = null

func _handle_input() -> void:
	if not player:
		return
	
	if not can_move():
		return
	
	if not target_player_slot:
		target_player_slot = player.reserve_slot(self)
	
	if target_player_slot:
		if position.distance_to(target_player_slot.global_position) <= player_adjacency_threshold:
			velocity = Vector2.ZERO
			return
	
		var direction := (target_player_slot.global_position - global_position).normalized()
		velocity = direction * speed
	
func _on_receive_damage(damage_received: int, direction: Vector2, hit_type: DamageReceiver.HitType) -> void:
	if current_health == 0 and target_player_slot:
		target_player_slot.free_slot()
	super._on_receive_damage(damage_received, direction, hit_type)
