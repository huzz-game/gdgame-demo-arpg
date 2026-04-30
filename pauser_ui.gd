extends Node

@onready var pause_audio_stream_player: AudioStreamPlayer = $PauseAudioStreamPlayer
@onready var unpause_audio_stream_player: AudioStreamPlayer = $UnpauseAudioStreamPlayer

@onready var h_box_container: HBoxContainer = $HBoxContainer
@onready var continue_button: Button = $HBoxContainer/ContinueButton
@onready var back_main_menu_button: Button = $HBoxContainer/BackMainMenuButton

func _ready() -> void:
	continue_button.button_down.connect(func():
		pause_audio_stream_player.play()
		get_tree().paused = false
		h_box_container.visible = false
	)
	back_main_menu_button.button_down.connect(func():
		get_tree().paused = false
		get_tree().change_scene_to_file("res://main_menu.tscn")
	)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		var is_paused = get_tree().paused
		if is_paused: 
			unpause_audio_stream_player.play()
			h_box_container.visible = false
		else: 
			pause_audio_stream_player.play()
			h_box_container.visible = true
		get_tree().paused = not is_paused
	
