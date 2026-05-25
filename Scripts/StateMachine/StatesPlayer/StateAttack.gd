class_name StateAttack extends StatePlayer

@export var ATTACK_DELAY : float = 0.3
@export var MAX_COMBO : int = 2 # count like a programmer, if I need to explain KYS
# time in msecs that needs to have passed since 
# last attack for a new attack combo to be started
@export var COOLDOWN : int = 0

var attackAgain : bool = false
var currentCombo : int = 0
var attackTimer : float = 0
var lastAttackTimeStamp : int = 0

func handleInput() -> void:
	pass

func process(delta: float) -> void:
	attackTimer += delta
	player.velocity = Vector2.ZERO
	
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
			player.attack(currentCombo)
			lastAttackTimeStamp = Time.get_ticks_msec()
		else:
			finished.emit(STATEIDLE)
	
	if EventHandler.isPlayerInputJustPressed(HIT):
		attackAgain = true

func physicsProcess(_delta: float) -> void:
	pass

func enter(_previous_state_path: String, _data := {}) -> void:
	attackTimer = 0
	currentCombo = 0
	attackAgain = false
	if Time.get_ticks_msec() - lastAttackTimeStamp < COOLDOWN:
		finished.emit(STATEIDLE)
		return
	
	player.attack(currentCombo)
	lastAttackTimeStamp = Time.get_ticks_msec()

func exit() -> void:
	attackTimer = 0
	currentCombo = 0
	attackAgain = false
	player.stopAttack()
