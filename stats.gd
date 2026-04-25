class_name Stats extends Resource

@export var health := 1 :
	set(value):
		var pre_value = health
		health = value
		if pre_value != health: health_changed.emit(health)
		if health <= 0: no_health.emit()


@export var max_health := 1

signal health_changed(value)
signal no_health()
