extends StaticBody2D

@onready var damage_receiver: DamageReceiver = $DamageReceiver
@onready var sprite := $Sprite2D
@export var knockback_intensity: float = 50

enum BarrelState { IDLE, DESTROYED }

var velocity := Vector2.ZERO
var height:= 0.0
var height_speed := 0.0
var barrel_state = BarrelState.IDLE

func _ready() -> void:
	damage_receiver.damage_received.connect(_on_receive_damage.bind())

func _process(delta: float) -> void:
	position += velocity * delta
	sprite.position = Vector2.UP * height
	_handle_air_time(delta)

func _on_receive_damage(_damage_received: int, direction: Vector2, hit_type: DamageReceiver.HitType) -> void:
	if barrel_state == BarrelState.IDLE:
		sprite.frame = 1 # TODO: Should use animation player
		barrel_state = BarrelState.DESTROYED
		velocity = direction * knockback_intensity
		height_speed = knockback_intensity

func _handle_air_time(delta: float) -> void:
	if barrel_state == BarrelState.DESTROYED:
		modulate.a -= delta
		height += height_speed * delta
		if height <= 0:
			height = 0
			queue_free()
		else:
			height_speed -= Constants.GRAVITY * delta
