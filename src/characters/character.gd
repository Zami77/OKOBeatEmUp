extends CharacterBody2D

class_name Character

@export var damage: int = 3
@export var max_health: int = 10
@export var speed: float = 30
@export var jump_intensity: float = 100
@export var knockback_intensity := 0.0
@export var knockdown_intensity := 30
@export var grounded_duration:= 10

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var character_sprite: Sprite2D = $CharacterSprite
@onready var damage_emitter: Area2D = $DamageEmitter
@onready var damage_receiver: DamageReceiver = $DamageReceiver
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

enum CharacterState { IDLE, WALK, ATTACK, TAKEOFF, JUMP, LANDING, JUMPKICK, HURT, FALL, GROUNDED }

const state_animation_map := {
	CharacterState.IDLE: "idle",
	CharacterState.WALK: "walk",
	CharacterState.ATTACK: "punch",
	CharacterState.TAKEOFF: "takeoff",
	CharacterState.JUMP: "jump",
	CharacterState.LANDING: "landing",
	CharacterState.JUMPKICK: "jumpkick",
	CharacterState.HURT: "hurt",
	CharacterState.FALL: "fall",
	CharacterState.GROUNDED: "grounded"
}
var character_state = CharacterState.IDLE
var height := 0.0
var height_speed := 0.0
var current_health := 0
var time_since_grounded := Time.get_ticks_msec()

func _ready() -> void:
	damage_emitter.area_entered.connect(_on_emit_damage.bind())
	damage_receiver.damage_received.connect(_on_receive_damage.bind())
	current_health = max_health
	
func _process(delta: float) -> void:
	_handle_input()
	_handle_movement()
	_handle_animations()
	_handle_airtime(delta)
	_flip_sprites()
	move_and_slide()
	_state_adjustments()

func _state_adjustments():
	if character_state == CharacterState.GROUNDED:
		collision_shape.disabled = true
	else:
		collision_shape.disabled = false
		

func _handle_movement():
	if can_move():
		if velocity.length() == 0:
			character_state = CharacterState.IDLE
		else:
			character_state = CharacterState.WALK
	
func _handle_input() -> void:
	pass

func _handle_animations() -> void:
	animation_player.play(state_animation_map[character_state])

func _handle_airtime(delta: float) -> void:
	if not [CharacterState.JUMP, CharacterState.JUMPKICK, CharacterState.FALL].has(character_state):
		return
	
	height += height_speed * delta
	
	if height < 0:
		height = 0
		
		if character_state == CharacterState.FALL:
			character_state = CharacterState.GROUNDED
		else:
			character_state = CharacterState.LANDING
		
		velocity = Vector2.ZERO			
	else:
		height_speed -= Constants.GRAVITY * delta
	
	character_sprite.position = Vector2.UP * height
		
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

func can_jump() -> bool:
	return character_state == CharacterState.IDLE or character_state == CharacterState.WALK

func can_jumpkick() -> bool:
	return character_state == CharacterState.JUMP
 
func _on_action_complete() -> void:
	character_state = CharacterState.IDLE

func _on_takeoff_complete() -> void:
	character_state = CharacterState.JUMP
	height_speed = jump_intensity

func _on_landing_complete() -> void:
	character_state = CharacterState.IDLE

func _on_emit_damage(target_damage_receiver: DamageReceiver) -> void:
	var hit_type := DamageReceiver.HitType.NORMAL
	
	if character_state == CharacterState.JUMPKICK:
		hit_type = DamageReceiver.HitType.KNOCKDOWN
	
	var direction := Vector2.LEFT if target_damage_receiver.global_position.x < global_position.x else Vector2.RIGHT
	target_damage_receiver.damage_received.emit(damage, direction, hit_type)
	print(target_damage_receiver)

func _on_receive_damage(damage_received: int, direction: Vector2, hit_type: DamageReceiver.HitType) -> void:
	character_state = CharacterState.HURT
	current_health = clamp(current_health - damage_received, 0, max_health)
	
	if current_health == 0 or hit_type == DamageReceiver.HitType.KNOCKDOWN:
		character_state = CharacterState.FALL
		height_speed = knockdown_intensity
		
	
	velocity = direction * knockback_intensity
	
	AudioManager.play_hit_sfx()
	
	if current_health <= 0:
		queue_free()
