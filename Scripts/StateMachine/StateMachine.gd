class_name StateMachine extends Node
## Runs one State at a time. States switch by emitting `finished`; code outside the
## state machine forces a switch with interrupt().

## The active state. The value set in the scene is the initial state.
@export var currentState : State = null

## Whether the initial state is entered as soon as the owner is ready. Set this to false
## before then (e.g. in the owner's _ready) to hold the state machine back until start().
var startOnReady := true
var _started := false

func _ready() -> void:
	set_process(false)
	set_physics_process(false)
	for state_node: State in find_children("*", "State"):
		state_node.finished.connect(_transition_to_next_state)
	await owner.ready
	var character := owner as Character
	if character != null:
		character.animatedSprite.animation_finished.connect(_onAnimationFinished)
	if startOnReady:
		start()

## Enters the initial state and starts running states. Does nothing if already started.
func start() -> void:
	if _started:
		return
	_started = true
	set_process(true)
	set_physics_process(true)
	currentState.isActive = true
	currentState.enter("StateIdle")

func _process(delta: float) -> void:
	currentState.process(delta)

func _physics_process(delta: float) -> void:
	currentState.physicsProcess(delta)

## Forces a switch to another state from outside the state machine, e.g. when an
## enemy gets stunned or taunted. States switch themselves by emitting `finished`.
## Ignored before start().
func interrupt(targetStatePath: String, data: Dictionary = {}) -> void:
	if _started:
		_transition_to_next_state(targetStatePath, data)

func _onAnimationFinished() -> void:
	if _started:
		currentState.onAnimationFinished(String((owner as Character).animatedSprite.animation))

func _transition_to_next_state(targetStatePath: String, data: Dictionary = {}) -> void:
	if not has_node(targetStatePath):
		printerr(owner.name + ": Trying to transition to state " + targetStatePath + " but it does not exist.")
		return

	var previousStatePath := currentState.name
	currentState.isActive = false
	currentState.exit()
	currentState = get_node(targetStatePath)
	currentState.isActive = true
	currentState.enter(previousStatePath, data)
