class_name MainMenu
extends Node2D

signal option_selected(option: Option)

@onready var play_game_button: DefaultButton = $VBoxContainer/PlayGameButton
@onready var settings_button: DefaultButton = $VBoxContainer/SettingsButton
@onready var credits_button: DefaultButton = $VBoxContainer/CreditsButton
@onready var exit_button: DefaultButton = $VBoxContainer/ExitGameButton

enum Option { PLAY_GAME, SETTINGS, CREDITS, EXIT_GAME }

func _ready():
	AudioManager.play_menu_theme()
	
	play_game_button.pressed.connect(_on_button_press.bind(Option.PLAY_GAME))
	settings_button.pressed.connect(_on_button_press.bind(Option.SETTINGS))
	credits_button.pressed.connect(_on_button_press.bind(Option.CREDITS))
	exit_button.pressed.connect(_on_button_press.bind(Option.EXIT_GAME))


func _on_button_press(option: Option) -> void:
	emit_signal("option_selected", option)
