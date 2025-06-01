class_name CameraManager
extends Camera2D

@export var max_trauma = 25.0
@export var decay = 10.0  

const SMALL_BUMP = 4.0
const MEDIUM_BUMP = 6.0
const LARGE_BUMP = 10.0

var trauma = 0.0  # Current shake strength.

func _ready():
	randomize()

func _process(delta):
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		_shake()

func _shake():
	offset = _get_shake_offset()

func _get_shake_offset() -> Vector2:
	return Vector2(randi_range(-trauma, trauma), randi_range(-trauma, trauma))

# To add shake call like below in game manager class: 
# camera.add_trauma(CameraManager.LARGE_BUMP)
func add_trauma(amount):
	trauma = min(trauma + amount, max_trauma)
