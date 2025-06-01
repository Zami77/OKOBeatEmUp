class_name TransitionScreen
extends CanvasLayer


@onready var animation_player = $AnimationPlayer

signal faded_to_black
signal faded_to_scene

func fade_to_black():
	visible = true
	animation_player.play("fade_to_black")
	await animation_player.animation_finished
	emit_signal("faded_to_black")
	visible = false

func fade_to_scene():
	visible = true
	animation_player.play("fade_to_scene")
	await animation_player.animation_finished
	emit_signal("faded_to_scene")
	visible = false
