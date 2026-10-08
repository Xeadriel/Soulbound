class_name DirectionalHitboxes extends Node
## One melee hitbox per facing direction. Only the hitbox for the direction the
## attack faces is switched on. Used by enemies with melee attacks.

@export var up : Area2D
@export var down : Area2D
@export var left : Area2D
@export var right : Area2D

func enable(facing : Facing.Direction) -> void:
	var hitbox := _forFacing(facing)
	hitbox.process_mode = PROCESS_MODE_INHERIT
	hitbox.visible = true

func disableAll() -> void:
	for hitbox : Area2D in [up, down, left, right]:
		hitbox.visible = false
		hitbox.process_mode = PROCESS_MODE_DISABLED

func _forFacing(facing : Facing.Direction) -> Area2D:
	match facing:
		Facing.Direction.UP:
			return up
		Facing.Direction.DOWN:
			return down
		Facing.Direction.LEFT:
			return left
		_:
			return right
