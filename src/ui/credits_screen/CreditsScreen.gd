class_name CreditsScreen
extends Node2D

signal back_to_main_menu

@onready var main_menu_button: DefaultButton = $MainMenuButton

func _ready():
	main_menu_button.pressed.connect(_on_main_menu_button_pressed)

func _on_main_menu_button_pressed() -> void:
	emit_signal("back_to_main_menu")
