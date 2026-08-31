class_name Fireball extends Area2D

@export var SPEED = 200
@export var dmgValue = 2

var direction :Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rotation = direction.angle()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func deleteFireball():
	queue_free()

func _physics_process(delta: float) -> void:
	global_position += SPEED * direction * delta

func _on_area_entered(area: Area2D) -> void:
	deleteFireball()

func _on_body_entered(body: Node2D) -> void:
	if(body is Player):
		var player : Player = body
		player.takeDamage(dmgValue, self)
	deleteFireball()
