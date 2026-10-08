class_name StateMachine extends Node
## Runs one State at a time. States switch by emitting `finished`; code outside the
## state machine forces a switch with interrupt().

## The active state. The value set in the scene is the initial state.
@export var currentState : State = null

func _ready() -> void:
	for state_node: State in find_children("*", "State"):
		state_node.finished.connect(_transition_to_next_state)
	await owner.ready
	var character := owner as Character
	if character != null:
		character.animatedSprite.animation_finished.connect(_onAnimationFinished)
	currentState.enter("StateIdle")

func _process(delta: float) -> void:
	currentState.process(delta)

func _physics_process(delta: float) -> void:
	currentState.physicsProcess(delta)

## Forces a switch to another state from outside the state machine, e.g. when an
## enemy gets stunned or taunted. States switch themselves by emitting `finished`.
func interrupt(targetStatePath: String, data: Dictionary = {}) -> void:
	_transition_to_next_state(targetStatePath, data)

func _onAnimationFinished() -> void:
	currentState.onAnimationFinished(String((owner as Character).animatedSprite.animation))

func _transition_to_next_state(targetStatePath: String, data: Dictionary = {}) -> void:
	if not has_node(targetStatePath):
		printerr(owner.name + ": Trying to transition to state " + targetStatePath + " but it does not exist.")
		return

	var previousStatePath := currentState.name
	currentState.exit()
	currentState = get_node(targetStatePath)
	currentState.enter(previousStatePath, data)
