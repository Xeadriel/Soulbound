class_name DaggerCircling extends EnemyProjectile
## Orbits around `center` with collision off until stopOrbiting() launches it
## towards the center.

@export var radius = 300
@export var angularSpeed = 3

@onready var isOrbiting := true
@onready var sprite := $AnimatedSprite2D
@onready var cShape := $CollisionShape2D

var center: Node2D
var angle := 0.0
var isLaunching := false

func _enter_tree() -> void:
	# off before the dagger takes part in physics, so it can't hit anything on spawn
	$CollisionShape2D.disabled = true

func _ready() -> void:
	# start on the orbit right away instead of at the spawn parent's origin
	_updateOrbitPosition()

func _physics_process(delta: float) -> void:
	if isOrbiting:
		angle += angularSpeed * delta
		_updateOrbitPosition()
	elif isLaunching:
		super._physics_process(delta)

func _updateOrbitPosition() -> void:
	global_position = center.global_position + Vector2.RIGHT.rotated(angle) * radius
	rotation = angle

func activateCollision() -> void:
	cShape.set_deferred("disabled", false)

func stopOrbiting() -> void:
	isOrbiting = false
	direction = (center.global_position - global_position).normalized()
	var tw = create_tween()
	tw.tween_property(sprite, "global_position", global_position - direction * 40, 0.2)
	tw.tween_property(sprite, "position", Vector2.ZERO, 0.12)
	await tw.finished
	isLaunching = true
	activateCollision()
