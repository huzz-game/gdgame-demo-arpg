extends Control

@onready var empty_hearts: TextureRect = $EmptyHearts
@onready var full_hearts: TextureRect = $FullHearts

@export var player_stats: Stats

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_empty_hearts(player_stats.max_health)
	set_full_hearts(player_stats.health)
	player_stats.health_changed.connect(set_full_hearts)

func set_empty_hearts(value: int) -> void:
	empty_hearts.size.x = value * 15
	
func set_full_hearts(value: int) -> void:
	full_hearts.size.x = value * 15
