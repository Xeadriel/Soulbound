class_name StateAttack extends StatePlayer

@export var ATTACK_DELAY : float
@export var MAX_COMBO : int = 2

var attackAgain : bool = false
var currentCombo : int = 0
var attackTimer : float = 0

func handleInput() -> void:
	pass

func process(delta: float) -> void:
	attackTimer += delta
	player.velocity = Vector2.ZERO
	
	if attackTimer >= ATTACK_DELAY:
		attackTimer = 0
		if attackAgain and currentCombo < MAX_COMBO:
			attackAgain = false
			currentCombo += 1
			player.attack(currentCombo)
			print("played attack" + str(currentCombo))
		else:
			print("back to idle")
			finished.emit("StateIdle")
	# do stuff on timer then go to idle
	if EventHandler.isPlayerInputJustPressed(HIT):
		attackAgain = true
		print("registered attempt to combo extension")
		

func physicsProcess(_delta: float) -> void:
	pass

func enter(_previous_state_path: String, _data := {}) -> void:
	attackTimer = 0
	currentCombo = 0
	attackAgain = false
	player.attack(currentCombo)

func exit() -> void:
	attackTimer = 0
	currentCombo = 0
	attackAgain = false
	player.stopAttack()
