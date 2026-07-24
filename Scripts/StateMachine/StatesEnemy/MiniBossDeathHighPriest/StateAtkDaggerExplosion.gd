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

func enter(_previous_state_path: String, _data := {}) -> void:
	print("dagger explosion")
	entity.target = entity.getClosestPlayer()
	entity.velocity = Vector2.ZERO
	entity.daggerExplosion()
	entity.daggerExplosionAtk(_data["sacrificePos"])

func exit() -> void:
	pass

func animationFinished(animatedSprite: AnimatedSprite2D) -> void:
	if animatedSprite.animation not in [
		"daggerExplosionFront", 
		"daggerExplosionBack", 
		"daggerExplosionLeft", 
		"daggerExplosionRight"
	]:
		return
	
	finished.emit(THINKING)
