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
	entity.daggerExplosion()
	entity.daggerExplosionAtk(_data["sacrificePos"])

func exit() -> void:
	entity.animatedSprite.speed_scale = 1.0

func animationFinished(animationName: String) -> void:
	if animationName not in [
		"daggerExplosionFront", 
		"daggerExplosionBack", 
		"daggerExplosionLeft", 
		"daggerExplosionRight"
	]:
		return
	finished.emit(THINKING)
