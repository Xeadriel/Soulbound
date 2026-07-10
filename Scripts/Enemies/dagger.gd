class_name Dagger extends Area2D

@export var radius = 100
@export var angularSpeed = 2
@export var dmgValue = 2

var center: Node2D
var angle := 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func deleteDagger():
	queue_free()

func _physics_process(delta: float) -> void:
	if center == null:
		return
	angle += angularSpeed * delta
	global_position = center.global_position + Vector2.RIGHT.rotated(angle) * radius
	rotation = angle

func _on_area_entered(area: Area2D) -> void:
	deleteDagger()

func _on_body_entered(body: Node2D) -> void:
	if(body is Player):
		body.takeDamage(dmgValue)
	deleteDagger()
