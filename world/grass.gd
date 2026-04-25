extends Node2D

@export var GRASS_EFFECT: PackedScene

@onready var hurtbox: Hurtbox = $Hurtbox

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hurtbox.area_entered.connect(_on_hurt)

func _on_hurt(_area_2d: Area2D) -> void:
	if _area_2d is Hitbox:
		var grass_effect_instance = GRASS_EFFECT.instantiate()
		get_tree().current_scene.add_child(grass_effect_instance)
		grass_effect_instance.global_position = global_position
		queue_free()
