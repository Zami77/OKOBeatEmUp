class_name SettingsMenu
extends Node2D

signal back_to_main_menu

@onready var fullscreen_toggle: CheckButton = $PanelContainer/VBoxContainer/FullscreenToggle
@onready var master_vol_slider: HSlider = $PanelContainer/VBoxContainer/MasterVolSlider
@onready var music_vol_slider: HSlider = $PanelContainer/VBoxContainer/MusicVolSlider
@onready var sound_effect_slider: HSlider = $PanelContainer/VBoxContainer/SoundEffectVolSlider
@onready var main_menu_button: DefaultButton = $MainMenuButton

enum SliderType { MASTER, MUSIC, SFX }

func _ready():
	master_vol_slider.value = DataManager.game_data.settings.master_vol
	music_vol_slider.value = DataManager.game_data.settings.music_vol
	sound_effect_slider.value = DataManager.game_data.settings.sfx_vol
	
	master_vol_slider.value_changed.connect(_on_slider_value_changed.bind(SliderType.MASTER))
	music_vol_slider.value_changed.connect(_on_slider_value_changed.bind(SliderType.MUSIC))
	sound_effect_slider.value_changed.connect(_on_slider_value_changed.bind(SliderType.SFX))

	main_menu_button.pressed.connect(_on_main_menu_button_pressed)
	
	fullscreen_toggle.toggled.connect(SettingsManager.set_fullscreen)

func _on_main_menu_button_pressed() -> void:
	emit_signal("back_to_main_menu")

func _on_slider_value_changed(slider_value: float, slider_type: SliderType) -> void:
	match slider_type:
		SliderType.MASTER:
			SettingsManager.set_master_vol(slider_value)
		SliderType.MUSIC:
			SettingsManager.set_music_vol(slider_value)
		SliderType.SFX:
			SettingsManager.set_sfx_vol(slider_value)
