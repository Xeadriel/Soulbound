extends StateEnemy

var chosenSacrifice: Enemy
var channelTime: float = 3.0
var nextState: String
var sacrificePos: Vector2

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
	for child in entity.get_parent().get_children():
		if(child is Wizard || child is Goblin):
			candidates.append(child)
	if(candidates.is_empty()):
		transition(THINKING)
		return
	chosenSacrifice = candidates.pick_random()
	candidates.erase(chosenSacrifice)
	sacrificePos = chosenSacrifice.global_position
	entity.animatedSprite.speed_scale = 1 / entity.telegraphTime
	entity.velocity = Vector2.ZERO
	entity.sacrificeAnimation()

## Called by the state machine before changing the active state. Use this function
## to clean up the state.
func exit() -> void:
	entity.animatedSprite.speed_scale = 1

func onAnimationFinished(animationName: String) -> void:
	if "sacrifice" not in animationName:
		return
	if is_instance_valid(chosenSacrifice):
		chosenSacrifice.takeDamage(9999)
	else:
		transition(THINKING) # if sacrifice was killed before sacrifice cancel spellcast
		return
	await get_tree().create_timer(2.0).timeout
	transition(nextState, {
		"sacrificePos": sacrificePos
	})
