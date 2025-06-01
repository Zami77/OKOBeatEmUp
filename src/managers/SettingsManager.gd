extends Node

func load_settings() -> void:
	set_fullscreen(DataManager.game_data.settings.fullscreen)
	set_music_vol(DataManager.game_data.settings.music_vol)
	set_sfx_vol(DataManager.game_data.settings.sfx_vol)
	set_master_vol(DataManager.game_data.settings.master_vol)

func set_fullscreen(toggle: bool) -> void:
	if toggle:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
	DataManager.game_data.settings.fullscreen = toggle
	DataManager.save_game()

func set_music_vol(db: float) -> void:
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index(AudioManager.bus_music),
		linear_to_db(db)
	)
	DataManager.game_data.settings.music_vol = db
	DataManager.save_game()

func set_sfx_vol(db: float) -> void:
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index(AudioManager.bus_sound_effects),
		linear_to_db(db)
	)
	DataManager.game_data.settings.sfx_vol = db
	DataManager.save_game()
	
func set_master_vol(db: float) -> void:
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index(AudioManager.bus_master),
		linear_to_db(db)
	)
	DataManager.game_data.settings.master_vol = db
	DataManager.save_game()
