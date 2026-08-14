class_name DaggerCircling extends Area2D

@export var radius = 300
@export var angularSpeed = 3
@export var dmgValue = 2

@onready var isOrbiting := true
@onready var sprite := $AnimatedSprite2D
@onready var cShape := $CollisionShape2D

var center: Node2D
var angle := 0.0
var launchDirection := Vector2.ZERO
var isLaunching := false
var launchSpeed := 500.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	deactivateCollision()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func deleteDagger():
	queue_free()

func _physics_process(delta: float) -> void:
	if isOrbiting:
		angle += angularSpeed * delta
		global_position = center.global_position + Vector2.RIGHT.rotated(angle) * radius
		rotation = angle
	elif isLaunching:
		global_position += launchDirection * launchSpeed * delta

func _on_area_entered(area: Area2D) -> void:
	deleteDagger()

func _on_body_entered(body: Node2D) -> void:
	if(body is Player):
		body.takeDamage(dmgValue)
	deleteDagger()
	
func activateCollision() -> void:
	cShape.set_deferred("disabled", false)
	
func deactivateCollision() -> void:
	cShape.set_deferred("disabled", true)
	
func stopOrbiting() -> void:
	isOrbiting = false
	launchDirection = (center.global_position - global_position).normalized()
	var tw = create_tween()
	tw.tween_property(sprite, "global_position", global_position - launchDirection * 40, 0.2)
	tw.tween_property(sprite, "position", Vector2.ZERO, 0.12)
	await tw.finished
	isLaunching = true
	activateCollision()
