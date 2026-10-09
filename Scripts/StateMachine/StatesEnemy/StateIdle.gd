extends StateEnemy

@export var slowDownSpeed := 200.0

func process(_delta: float) -> void:
	var distance := targetClosestPlayer()
	if distance < entity.aggroRange:
		transition(RUN)
	entity.velocity = entity.velocity.move_toward(Vector2.ZERO, slowDownSpeed)

func enter(_previous_state_path: String, _data := {}) -> void:
	entity.idle()
