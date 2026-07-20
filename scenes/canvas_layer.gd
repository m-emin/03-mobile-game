extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player = get_node("../Player")
	player.hp_changed.connect(_on_hp_changed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_hp_changed(new_hp: int) -> void:
	$ProgressBar.value = new_hp
