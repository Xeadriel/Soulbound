class_name Goblin extends Enemy

@export var SPEED := 100

func attack() -> void:
	var hitbox : Area2D = {
		Facing.Direction.UP: attackUp,
		Facing.Direction.DOWN: attackDown,
		Facing.Direction.LEFT: attackLeft,
		Facing.Direction.RIGHT: attackRight,
	}[facing]
	hitbox.process_mode = PROCESS_MODE_INHERIT
	hitbox.visible = true
	playDirectional("attack")

func stopAttack() -> void:
	for hitbox : Area2D in [attackUp, attackDown, attackLeft, attackRight]:
		hitbox.visible = false
		hitbox.process_mode = PROCESS_MODE_DISABLED
