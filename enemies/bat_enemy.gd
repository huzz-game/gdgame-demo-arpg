class_name BatEnemy extends CharacterBody2D

const SPEED = 30
const FRICTION = 500

const HIT_EFFECT = preload("uid://da3oyyvdwewj2")
const DEATH_EFFECT = preload("uid://d2f1am4ln1hg")

@export var min_range := 4
@export var max_range := 128
@export var stats : Stats

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback = animation_tree.get("parameters/StateMachine/playback") as AnimationNodeStateMachinePlayback
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var hurtbox: Hurtbox = $Hurtbox
@onready var center: Marker2D = $Center

func _ready() -> void:
	stats = stats.duplicate()
	stats.no_health.connect(die)
	hurtbox.hurt.connect(take_hit.call_deferred)

func _physics_process(delta: float) -> void:
	var state = playback.get_current_node()
	match state:
		"IdleState": pass
		"ChaseState": 
			var player = get_player()
			if player is Player:
				velocity = global_position.direction_to(player.global_position) * SPEED
				sprite_2d.scale.x = sign(velocity.x)
			else:
				velocity = Vector2.ZERO
			move_and_slide()
		"HitState":
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			move_and_slide()

func take_hit(other_hitbox: Hitbox) -> void:
	var hit_effect = HIT_EFFECT.instantiate() as AnimatedSprite2D
	hit_effect.global_position = center.global_position
	get_tree().current_scene.add_child(hit_effect)
	
	stats.health -= other_hitbox.damage
	velocity = other_hitbox.knockback_direction * other_hitbox.knockback_amount
	playback.start("HitState")

func die() -> void:
	var death_effect = DEATH_EFFECT.instantiate() as AnimatedSprite2D
	death_effect.global_position = global_position
	get_tree().current_scene.add_child(death_effect)
	queue_free()

func get_player() -> Player:
	return get_tree().get_first_node_in_group("player")

func is_player_in_range() -> bool:
	var result = false
	var player := get_player()
	if player is Player:
		var distance_to_player = global_position.distance_to(player.global_position)
		if distance_to_player < max_range and distance_to_player > min_range:
			result = true
	return result

func can_see_player() -> bool:
	if not is_player_in_range(): return false
	var player := get_player()
	ray_cast_2d.target_position = player.global_position - global_position
	var has_los_to_player := !ray_cast_2d.is_colliding()
	return has_los_to_player
