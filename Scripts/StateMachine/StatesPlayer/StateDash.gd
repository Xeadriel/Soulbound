class_name StateBlock extends StatePlayer

@export var DASH_DELAY : float = 0.2
@export var DASH_SPEED : float = 800
@export var DASH_COOLDOWN : float = 600
var dashTimer : float = 0
var lastDashTimeStamp : float = 0

func process(delta: float) -> void:
	# do stuff on timer then go to idle
	dashTimer += delta
	if dashTimer >= DASH_DELAY:
		dashTimer = 0
		finished.emit("StateIdle")

func physicsProcess(_delta: float) -> void:
	pass

func enter(_previous_state_path: String, _data := {}) -> void:
	dashTimer = 0
	
	if Time.get_ticks_msec() - lastDashTimeStamp >= DASH_COOLDOWN:
		var direction =  Vector2.from_angle(player.attackPivotPoint.rotation)
		player.velocity = direction.normalized() * DASH_SPEED
		lastDashTimeStamp = Time.get_ticks_msec()
		player.dash()
	else:
		finished.emit("StateIdle")

func exit() -> void:
	dashTimer = 0
	player.stopDash()
