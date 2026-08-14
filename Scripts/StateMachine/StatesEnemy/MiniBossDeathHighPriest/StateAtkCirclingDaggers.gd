extends StateEnemy

func _ready() -> void:
	super()
	entity.animationFinishedSignal.connect(animationFinished)
	
func process(_delta: float) -> void:
	pass
	
func physicsProcess(_delta: float) -> void:
	pass

func enter(_previous_state_path: String, _data := {}) -> void:
	entity.animatedSprite.speed_scale = 0.1
	entity.target = entity.getClosestPlayer()
	entity.velocity = Vector2.ZERO
	entity.daggerCirclingAnimation()
	entity.daggerCirclingAtk()

func exit() -> void:
	entity.animatedSprite.speed_scale = 1.0

func animationFinished(animationName: String) -> void:
	if animationName not in [
		"daggerCirclingFront", 
		"daggerCirclingBack", 
		"daggerCirclingLeft", 
		"daggerCirclingRight"
	]:
		return
	finished.emit(THINKING)
