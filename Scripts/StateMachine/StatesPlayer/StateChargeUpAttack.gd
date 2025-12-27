class_name StateChargeUpAttack extends StatePlayer

@export var ATTACK_DELAY : float = 0.3
@export var MAX_CHARGE : int = 3
@export var ATTACK_RELEASE_DELAY : float = 0.5

var currentCharge : int = 1
var attackTimer : float = 0
var startedRelease : bool = false

func handleInput() -> void:
	pass

func process(delta: float) -> void:
	attackTimer += delta
	player.velocity = Vector2.ZERO
	
	# allow alternating directions during charge and release
	var dir :=  Vector2(Input.get_axis(LEFT, RIGHT), Input.get_axis(UP, DOWN))
	if dir:
		player.setPlayerDirection(dir)
		player.setAttackRotationFromDirection(dir)
	
	if not startedRelease and not EventHandler.isPlayerInputPressed(HEAVY_HIT):
		startedRelease = true
		attackTimer = 0
		player.releaseAttackHeavy()

	if attackTimer >= ATTACK_DELAY:
		if not startedRelease and currentCharge < MAX_CHARGE:
			currentCharge += 1
			attackTimer = 0
			player.chargeAttackHeavy(currentCharge)
		elif not startedRelease and attackTimer >= ATTACK_RELEASE_DELAY:
			startedRelease = true
			attackTimer = 0
			player.releaseAttackHeavy()
		elif startedRelease and attackTimer >= ATTACK_RELEASE_DELAY:
			finished.emit("StateIdle")




func physicsProcess(_delta: float) -> void:
	pass

func enter(_previous_state_path: String, _data := {}) -> void:
	attackTimer = 0
	currentCharge = 0
	startedRelease = false

func exit() -> void:
	attackTimer = 0
	currentCharge = 0
	startedRelease = false
	player.stopAttackHeavy()
