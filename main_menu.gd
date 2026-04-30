extends Control


@onready var start_button: Button = $BoxContainer/StartButton
@onready var quit_button: Button = $BoxContainer/QuitButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_button.button_down.connect(func():
		get_tree().change_scene_to_file("res://world/world.tscn")
	)
	quit_button.button_down.connect(func():
		get_tree().quit()
	)
