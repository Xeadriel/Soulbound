class_name StateAttack extends StatePlayer

@export var ATTACK_DELAY : float
@export var MAX_COMBO : int = 3

var attackAgain : bool = false
var currentCombo : int = 0
var attackTimer : float = 0

func handleInput() -> void:
	pass

func process(delta: float) -> void:
	# do stuff on timer then go to idle
	player.velocity = Vector2.ZERO
	attackTimer += delta
	
	if Input.is_action_just_pressed(HIT):
		attackAgain = true
		print("registered attempt to combo extension")
		
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

func physicsProcess(_delta: float) -> void:
	pass

func enter(_previous_state_path: String, _data := {}) -> void:
	attackTimer = 0
	currentCombo = 0
	print("attack " + str(currentCombo))
	player.attack(currentCombo)

func exit() -> void:
	attackTimer = 0
	currentCombo = 0
	player.stopAttack()
