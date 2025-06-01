class_name DefaultButton
extends Button

func _ready():
	pass
	pressed.connect(_on_button_pressed)
	mouse_entered.connect(_on_mouse_entered)

func _on_button_pressed() -> void:
	AudioManager.play_button_press()

func _on_mouse_entered() -> void:
	AudioManager.play_button_hover()
