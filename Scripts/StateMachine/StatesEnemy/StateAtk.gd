extends StateEnemy

@export var nextState = IDLE

func _ready() -> void:
	super()
	entity.animationFinishedSignal.connect(animationFinished)
	
func process(_delta: float) -> void:
	pass

func physicsProcess(_delta: float) -> void:
	pass

func enter(_previous_state_path: String, _data := {}) -> void:
	entity.target = entity.getClosestPlayer()
	entity.velocity = Vector2.ZERO
	entity.attack()

func exit() -> void:
	entity.stopAttack()

func animationFinished(animationName: String) -> void:
	if animationName not in ["attackFront", "attackBack", "attackLeft", "attackRight"]:
		return
	finished.emit(nextState)
