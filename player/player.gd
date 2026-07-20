extends CharacterBody2D

@export var game_over: PackedScene = preload("res://scenes/game_over.tscn")

const SPEED: int = 100
const DOUBLE_TAP_WINDOW: int = 300
var current_speed: int
var last_press_time: Dictionary = {}

var is_attacking: bool = false
var is_interacting: bool = false
var is_running: bool = false
var is_holding: bool = false
var is_hit: bool = false

var hp: int = 100

func _take_dmg(amount: int) -> void:
	$AnimationPlayer.play("hit_flash")
	is_hit = true
	$Timer.start()
	hp -= amount
	if hp <= 0:
		await get_tree().create_timer(0.3).timeout
		get_tree().call_deferred("change_scene_to_packed", game_over)

func _check_double_tap(action: String) -> bool:
	if not Input.is_action_just_pressed(action):
		return false
		
	var now: int = Time.get_ticks_msec()
	var last: int = last_press_time.get(action, -DOUBLE_TAP_WINDOW)
	last_press_time[action] = now
	return (now - last) < DOUBLE_TAP_WINDOW


func _physics_process(_delta: float) -> void:

	var direction = Vector2.ZERO
	
	for action in ["move_up", "move_down", "move_right", "move_left", "interact", "attack", "hold"]:
		if _check_double_tap(action):
			is_running = true
		
		if Input.is_action_pressed(action):
			match action:
				"move_up": direction.y -= 1
				"move_down": direction.y += 1
				"move_right": direction.x += 1
				"move_left": direction.x -= 1
				"interact": is_interacting = true
				"attack": is_attacking = true
				"hold": is_holding = true
				
		elif Input.is_action_just_released(action):
			is_attacking = false
			is_interacting = false
			is_running = false
			is_holding = false
				
	direction = direction.normalized()
	
	if is_hit:
		$AnimatedSprite2D.play("hit")
		current_speed = 0
	elif is_attacking:
		$AnimatedSprite2D.play("attack")
		current_speed = 0
	elif is_holding:
		$AnimatedSprite2D.play("hold")
		current_speed = 0
	elif is_interacting:
		$AnimatedSprite2D.play("interact")
		current_speed = 0
	elif is_running and is_attacking == false:
		$AnimatedSprite2D.play("run")
		current_speed = SPEED * 2
	elif direction.length() > 0 and is_running == false:
		$AnimatedSprite2D.play("walk")
		current_speed = SPEED
	else:
		$AnimatedSprite2D.play("idle")
		current_speed = 0
	
	if direction.x > 0:
		$AnimatedSprite2D.flip_h = false
	elif direction.x < 0:
		$AnimatedSprite2D.flip_h = true
	
	velocity = direction * current_speed
	move_and_slide()


func _on_timer_timeout() -> void:
	is_hit = false
	
	
