class_name Projectile extends Area2D
## Base for everything that flies in a straight line, damages what it hits and
## disappears. Subclasses decide what they can damage.

@export var speed : float = 500.0
@export var damage : int = 1

var direction : Vector2

## Node that projectiles are added to, so they don't move with whoever fired them.
static func spawnParent(tree: SceneTree) -> Node:
	return tree.get_first_node_in_group(&"ProjectileNode")

func launch(dir: Vector2) -> void:
	direction = dir.normalized()

func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta

## Whether hitting this body deals damage. Override in subclasses.
func _isValidTarget(_body: Node2D) -> bool:
	return false

## Whether touching this node should be ignored instead of destroying the
## projectile (e.g. the player who fired it).
func _ignores(_node: Node) -> bool:
	return false

func _on_area_entered(area: Area2D) -> void:
	if not _ignores(area.owner):
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if _isValidTarget(body):
		body.takeDamage(damage, self)
	if not _ignores(body):
		queue_free()
