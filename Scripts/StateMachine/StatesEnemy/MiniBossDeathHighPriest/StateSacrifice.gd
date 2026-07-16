extends StateEnemy

var chosenSacrifice: Enemy
var channelTime: float = 3.0
var nextState: String

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
	var candidates = []
	nextState = _data.get("nextState")
	print("sacrificing -> ", nextState)
	for child in entity.get_parent().get_children():
		if(child is Wizard || child is Goblin):
			candidates.append(child)
	if(candidates.is_empty()):
		finished.emit(THINKING)
		return
	chosenSacrifice = candidates.pick_random()
	entity.animatedSprite.speed_scale = 1 / entity.telegraphTime
	entity.velocity = Vector2.ZERO
	entity.sacrificeAnimation()

## Called by the state machine before changing the active state. Use this function
## to clean up the state.
func exit() -> void:
	entity.animatedSprite.speed_scale = 1

func animationFinished(animatedSprite: AnimatedSprite2D):
	if "sacrifice" not in animatedSprite.animation:
		return
	chosenSacrifice.takeDamage(9999)
	print("poof ", chosenSacrifice, " is Sacrificed!")
	await get_tree().create_timer(2.0).timeout
	finished.emit(nextState)
