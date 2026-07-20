extends Area2D

var player_ref: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	player_ref = body
	if body.is_in_group("player"):
		player_ref._take_dmg(10)
		$Timer.start()

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		$Timer.stop()
	

func _on_timer_timeout() -> void:
	player_ref._take_dmg(10)
