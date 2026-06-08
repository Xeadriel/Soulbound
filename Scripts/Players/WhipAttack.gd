class_name WhipAttack extends Area2D


var start : Vector2
var goal : Vector2
var timePassed : float= 0
# time it should take to reach the goal in seconds
var attackDelay : float = 1.0

var player : Player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready() -> void:
	start = global_position

func _physics_process(delta: float) -> void:
	timePassed += delta
	var progress = clampf(timePassed / attackDelay, 0, 1.0)
	global_position = lerp(start, goal, progress)
	if progress >= 1.0:
		queue_free()

func hitSomething(body: Node2D) -> void:
	if body is Enemy:
		body.hitByWhip()
		queue_free()
	else:
		queue_free()

func getPlayerNumber():
	return 0 if player is Player1 else 1
