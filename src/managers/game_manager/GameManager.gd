class_name GameManager
extends Node2D

@export_file("*.tscn", "*.scn") var default_scene = "res://src/ui/main_menu/MainMenu.tscn"

@onready var transition_screen: TransitionScreen = $TransitionScreen
@onready var camera: CameraManager = $CameraManager

var current_scene = null

func _ready():
	DataManager.load_game()
	SettingsManager.load_settings()
	transition_screen.visible = false
	_load_scene(default_scene)

func _load_scene(scene_path: String) -> void:
	DataManager.save_game()
	transition_screen.fade_to_black()
	await transition_screen.faded_to_black
	
	var new_packed_scene = load(scene_path) as PackedScene
	var new_scene = new_packed_scene.instantiate()
	
	if current_scene:
		current_scene.queue_free()
	
	current_scene = new_scene
	transition_screen.fade_to_scene()
	add_child(new_scene)
	
	if current_scene is MainMenu:
		current_scene.option_selected.connect(_on_main_menu_option_selected)
	
	if current_scene is CreditsScreen:
		current_scene.back_to_main_menu.connect(_on_back_to_main_menu)
		
	if current_scene is SettingsMenu:
		current_scene.back_to_main_menu.connect(_on_back_to_main_menu)
	
	await transition_screen.faded_to_scene

func _on_back_to_main_menu() -> void:
	_load_scene(ScenePaths.main_menu)

func _on_main_menu_option_selected(option: MainMenu.Option) -> void:
	match option:
		MainMenu.Option.PLAY_GAME:
			push_error("There's no game to go to! Add your game scene here!")
			#_load_scene("PUT_YOUR_GAME_SCENE_PATH_HERE")
		MainMenu.Option.SETTINGS:
			_load_scene(ScenePaths.settings_menu)
		MainMenu.Option.CREDITS:
			_load_scene(ScenePaths.credits_screen)
		MainMenu.Option.EXIT_GAME:
			get_tree().quit()

