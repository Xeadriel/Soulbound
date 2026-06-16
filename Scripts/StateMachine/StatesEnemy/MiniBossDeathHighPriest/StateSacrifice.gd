extends StateEnemy

var candidates = []
var chosenSacrifice: Enemy
var channelTime: float = 3.0

## Called by the state machine on the engine's main loop tick.
func process(_delta: float) -> void:
	channelTime -= _delta
	if(channelTime <= 0):
		entity.castSacrificeGoblin()
		chosenSacrifice.takeDamage(9999)
		print("poof ", chosenSacrifice, " is Sacrificed!")
		finished.emit(THINKING)

## Called by the state machine on the engine's physics update tick.
func physicsProcess(_delta: float) -> void:
	pass

## Called by the state machine upon changing the active state. The `data` parameter
## is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_previous_state_path: String, _data := {}) -> void:
	entity.channelSacrificeGoblin()
	for child in get_parent().get_children():
		if(child is Wizard || child is Goblin):
			candidates.append(child)
	chosenSacrifice = candidates.pick_random()
	

## Called by the state machine before changing the active state. Use this function
## to clean up the state.
func exit() -> void:
	pass
