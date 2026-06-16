class_name StateMachine extends Node

@export var currentState : State = null

func _ready() -> void:
	for state_node: State in find_children("*", "State"):
		state_node.finished.connect(_transition_to_next_state)
	await owner.ready
	print(owner)
	currentState.enter("StateIdle")

func _process(delta: float) -> void:
	currentState.process(delta)

func _physics_process(delta: float) -> void:
	currentState.physicsProcess(delta)

func _transition_to_next_state(targetStatePath: String, data: Dictionary = {}) -> void:
	if not has_node(targetStatePath):
		printerr(owner.name + ": Trying to transition to state " + targetStatePath + " but it does not exist.")
		return

	var previousStatePath := currentState.name
	currentState.exit()
	currentState = get_node(targetStatePath)
	currentState.enter(previousStatePath, data)
