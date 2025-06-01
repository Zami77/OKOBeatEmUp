class_name LevelManager
extends Node2D

enum LevelName { LEVEL_ONE }

const level_name_to_soundtrack_map = {
	LevelName.LEVEL_ONE: AudioManager.LevelSoundtrack.LEVEL_ONE
}

@export var level_name: LevelName = LevelName.LEVEL_ONE

@onready var camera: Camera2D = $LevelCamera
@onready var player: PlayableCharacter = $EntityContainer/PlayableCharacter

func _ready() -> void:
	AudioManager.play_level_theme(level_name_to_soundtrack_map[level_name])

func _process(delta: float) -> void:
	if player.position.x > camera.position.x:
		camera.position.x = player.position.x
