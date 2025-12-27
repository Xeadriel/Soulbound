extends StateEnemy


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	entity.animationFinishedSignal.connect(animationFinished)


func process(_delta: float) -> void:
	pass

func enter(_previous_state_path: String, _data := {}) -> void:
	#because the animations are set to 5 FPS speed scale can be used to decide the duration of the animation
	entity.animatedSprite.speed_scale = entity.telegraphTime # needs to be reset to 1 in exit
	
	entity.target = getClosestPlayer()
	entity.direction = entity.getDirectionToPlayer()
	entity.velocity = Vector2.ZERO
	entity.telegraphAttack()

func exit() -> void:
	entity.animatedSprite.speed_scale = 1

# if telegraph is done, switch to attack
func animationFinished(animatedSprite: AnimatedSprite2D):
	if "telegraph" not in animatedSprite.animation:
		return
	finished.emit(ATK)
