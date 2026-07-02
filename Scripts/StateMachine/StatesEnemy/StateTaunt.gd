extends StateEnemy

@export var tauntDuration : float = 2.0
var timePassed : float = 0.0

func process(delta: float) -> void:
	timePassed += delta
	if timePassed >= tauntDuration:
		timePassed = 0
		finished.emit(IDLE)

func enter(_previous_state_path: String, _data := {}) -> void:
	entity.velocity = Vector2.ZERO
	entity.idle()
	#entity.taunt() change later

func exit() -> void:
	pass
