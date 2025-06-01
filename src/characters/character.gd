extends CharacterBody2D

class_name Character

@export var damage: int = 3
@export var health: int = 10
@export var speed: float = 30

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var character_sprite: Sprite2D = $CharacterSprite
@onready var damage_emitter: Area2D = $DamageEmitter

enum CharacterState { IDLE, WALK, ATTACK }

var character_state = CharacterState.IDLE

func _ready() -> void:
	damage_emitter.area_entered.connect(_on_emit_damage.bind())
	
func _process(delta: float) -> void:
	_handle_input()
	_handle_movement()
	_handle_animations()
	_flip_sprites()
	move_and_slide()

func _handle_movement():
	if not can_move():
		velocity = Vector2.ZERO
		return
	
	if velocity.length() == 0:
		character_state = CharacterState.IDLE
	else:
		character_state = CharacterState.WALK

func _handle_input():
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction  * speed
	
	if Input.is_action_just_pressed("attack") and can_attack():
		character_state = CharacterState.ATTACK

func _handle_animations() -> void:
	match character_state:
		CharacterState.IDLE:
			animation_player.play("idle")
		CharacterState.WALK:
			animation_player.play("walk")
		CharacterState.ATTACK:
			animation_player.play("punch")

func _flip_sprites():
	if velocity.x > 0:
		character_sprite.flip_h = false
		damage_emitter.scale.x = 1
	elif velocity.x < 0:
		character_sprite.flip_h = true
		damage_emitter.scale.x = -1

func can_attack() -> bool:
	return character_state == CharacterState.IDLE or character_state == CharacterState.WALK

func can_move() -> bool:
	return character_state == CharacterState.IDLE or character_state == CharacterState.WALK

func _on_action_complete() -> void:
	character_state = CharacterState.IDLE

func _on_emit_damage(damage_receiver: DamageReceiver) -> void:
	var direction := Vector2.LEFT if damage_receiver.global_position.x < global_position.x else Vector2.RIGHT
	damage_receiver.damage_received.emit(damage, direction)
	print(damage_receiver)
