class_name StateWhipAttack extends StatePlayer

#time attack takes
@export var ATTACK_DELAY : float = 0.5
# time in msecs that needs to have passed since 
# last attack for a new attack combo to be started
@export var COOLDOWN : int = 200

var attackTimer : float = 0
var lastAttackTimeStamp : int = 0

func process(delta: float) -> void:
	attackTimer += delta
	player.velocity = Vector2.ZERO
	
	if attackTimer >= ATTACK_DELAY:
		transition(STATEIDLE)
		lastAttackTimeStamp = Time.get_ticks_msec()

func enter(_previous_state_path: String, _data := {}) -> void:
	attackTimer = 0
	if Time.get_ticks_msec() - lastAttackTimeStamp < COOLDOWN:
		transition(STATEIDLE)
		return
	
	player.whipAttack(ATTACK_DELAY)
	lastAttackTimeStamp = Time.get_ticks_msec()

func exit() -> void:
	attackTimer = 0
	player.stopWhipAttack()
