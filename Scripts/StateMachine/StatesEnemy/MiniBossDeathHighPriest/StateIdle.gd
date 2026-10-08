extends StateEnemy

var idleDuration: float = 2.0

func process(_delta: float) -> void:
	idleDuration -= _delta
	if(idleDuration <= 0):
		transition(THINKING)

func enter(_previous_state_path: String, _data := {}) -> void:
	entity.idle()
