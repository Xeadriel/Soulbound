class_name StateChargeUpAttack extends StatePlayer

@export var ATTACK_DELAY : float = 0.3
@export var MAX_CHARGE : int = 3
@export var ATTACK_RELEASE_DELAY : float = 0.5

var currentCharge : int = 1
var attackTimer : float = 0
var startedRelease : bool = false

func process(delta: float) -> void:
	attackTimer += delta
	player.velocity = Vector2.ZERO
	
	# allow alternating directions during charge and release
	aimFromInput()
	
	if not startedRelease and not InputBuffer.isHeld(input.heavyHit):
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
			finished.emit(STATEIDLE)

func enter(_previous_state_path: String, _data := {}) -> void:
	attackTimer = 0
	currentCharge = 0
	startedRelease = false

func exit() -> void:
	attackTimer = 0
	currentCharge = 0
	startedRelease = false
	player.stopAttackHeavy()
