extends StateEnemy

@export var stunDurationSecs = 1.0
var timePassed = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()

func process(delta: float) -> void:
	timePassed += delta
	entity.velocity = Vector2.ZERO
	if timePassed >= stunDurationSecs:
		finished.emit(IDLE)

func enter(_previous_state_path: String, data := {}) -> void:
	timePassed = 0
	stunDurationSecs = 1.0
	if data.has("duration"):
		stunDurationSecs = data["duration"]
	
	entity.velocity = Vector2.ZERO
	entity.idle() # change later
	entity.stunned()

func exit() -> void:
	timePassed = 0
