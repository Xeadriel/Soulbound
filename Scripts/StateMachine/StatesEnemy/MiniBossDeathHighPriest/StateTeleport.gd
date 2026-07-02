extends StateEnemy

func _ready() -> void:
	super()
	entity.animationFinishedSignal.connect(animationFinished)

## Called by the state machine on the engine's main loop tick.
func process(_delta: float) -> void:
	pass

## Called by the state machine on the engine's physics update tick.
func physicsProcess(_delta: float) -> void:
	pass

## Called by the state machine upon changing the active state. The `data` parameter
## is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_previous_state_path: String, _data := {}) -> void:
	print("teleporting")
	#because the animations are set to 5 Frame scale can be used to decide the duration of the animation
	entity.animatedSprite.speed_scale = entity.telegraphTime # needs to be reset to 1 in exit
	entity.velocity = Vector2.ZERO
	entity.teleportAnimation()

## Called by the state machine before changing the active state. Use this function
## to clean up the state.
func exit() -> void:
	entity.animatedSprite.speed_scale = 1
	
func animationFinished():
	if "teleport" not in entity.animatedSprite.animation:
		return
	entity.teleport()
	finished.emit(THINKING)
