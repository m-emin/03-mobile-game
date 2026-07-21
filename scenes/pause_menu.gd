extends CanvasLayer

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		_toggle_pause()

func _on_button_pressed() -> void:
	_toggle_pause()

func _toggle_pause() -> void:
	get_tree().paused = !get_tree().paused
	visible = !visible
