extends StateEnemy

func _ready() -> void:
	super()
	entity.animationFinishedSignal.connect(animationFinished)
	
func process(_delta: float) -> void:
	pass
	
func physicsProcess(_delta: float) -> void:
	pass

func enter(_previous_state_path: String, _data := {}) -> void:
	entity.animatedSprite.speed_scale = 0.1  #needs to be reset to 1 in exit
	entity.target = entity.getClosestPlayer()
	entity.velocity = Vector2.ZERO
	entity.swipeAtk()
	

func exit() -> void:
	entity.stopAttack()
	entity.animatedSprite.speed_scale = 1.0

func animationFinished(animationName: String) -> void:
	if animationName in ["swipeFront", "swipeBack", "swipeLeft", "swipeRight"]:
		finished.emit(THINKING)
