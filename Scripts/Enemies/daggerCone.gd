extends Area2D

@export var dmgValue := 1.0

var direction: Vector2
var speed := 500.0

func launch(dir: Vector2):
	direction = dir.normalized()

func _physics_process(delta):
	var move = direction * speed * delta
	global_position += move
	
func deleteDagger():
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	deleteDagger()

func _on_body_entered(body: Node2D) -> void:
	if(body is Player):
		body.takeDamage(dmgValue)
	deleteDagger()
