extends StateEnemy

var canAtk: bool = true
var elapsedTime: float

enum Direction {
	UP,
	DOWN,
	LEFT,
	RIGHT
}

func _ready() -> void:
	super()
	entity.animationFinishedSignal.connect(animationFinished)
	
func process(_delta: float) -> void:
	pass
	
func physicsProcess(_delta: float) -> void:
	pass

func enter(_pssssssrevious_state_path: String, _data := {}) -> void:
	print("daggerCone")
	entity.target = entity.getClosestPlayer()
	entity.velocity = Vector2.ZERO
	entity.daggerConeAnimation()
	entity.daggerConeAtk()

func exit() -> void:
	pass

func animationFinished(animatedSprite: AnimatedSprite2D) -> void:
	if animatedSprite.animation not in [
	"daggerConeFront", 
	"daggerConeBack", 
	"daggerConeRight", 
	"daggerConeLeft"
	]:
		return
	
	finished.emit(THINKING)
