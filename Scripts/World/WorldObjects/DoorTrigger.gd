class_name DoorTrigger extends DoorBase
## Door opened and closed by signals (levers, floor buttons, puzzles, cleared rooms).

@export var open = false

func _ready() -> void:
	super._ready()
	# start on the last frame of the animation instead of playing it
	setOpen(open, OPEN + "ed" if open else CLOSE + "d")

func onTriggered(state : bool = true) -> void:
	setOpen(state)
