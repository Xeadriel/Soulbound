class_name StateHeavyAttack extends StatePlayer

@export var ATTACK_DELAY : float = 0.6
@export var ATTACK_WINDUP_DELAY : float = 0.3
@export var MAX_COMBO : int = 2 # count like a programmer, if I need to explain KYS

var attackAgain : bool = false
var currentCombo : int = 0
var attackTimer : float = 0

func handleInput() -> void:
	pass

func process(delta: float) -> void:
	attackTimer += delta
	player.velocity = Vector2.ZERO
	
	# replace this later with animation events maybe
	# meaning, make animation separate from hitbox appearing
	# and trigger the hitbox on animation end or smth
	if attackTimer >= ATTACK_WINDUP_DELAY:
		player.attackHeavy(currentCombo)
	
	if attackTimer >= ATTACK_DELAY:
		attackTimer = 0
		
		# allow alternating directions during combo
		var dir :=  Vector2(Input.get_axis(LEFT, RIGHT), Input.get_axis(UP, DOWN))
		if dir:
			player.setPlayerDirection(dir)
			player.setAttackRotationFromDirection(dir)

		if attackAgain and currentCombo < MAX_COMBO:
			attackAgain = false
			currentCombo += 1
			player.stopAttackHeavy()
			player.attackHeavyWindup(currentCombo)
		else:
			finished.emit("StateIdle")
	# do stuff on timer then go to idle
	if EventHandler.isPlayerInputJustPressed(HEAVY_HIT):
		attackAgain = true

func physicsProcess(_delta: float) -> void:
	pass

func enter(_previous_state_path: String, _data := {}) -> void:
	attackTimer = 0
	currentCombo = 0
	attackAgain = false
	player.attackHeavyWindup(currentCombo)

func exit() -> void:
	attackTimer = 0
	currentCombo = 0
	attackAgain = false
	player.stopAttackHeavy()
