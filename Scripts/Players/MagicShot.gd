class_name MagicShot extends Area2D

@export var SPEED = 500
@export var dmgValue = 1

var player = null

var direction : Vector2

func _ready() -> void:
	rotation = direction.angle()

func _physics_process(delta: float) -> void:
	global_position += SPEED * direction * delta

func _on_area_entered(area: Area2D) -> void:
	if area.owner != player:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if(body is Enemy):
		body.takeDamage(dmgValue)
	if body != player:
		queue_free()
