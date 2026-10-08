class_name MiniBossDeathHighPriest extends Enemy

@onready var shieldSprite = $ShieldSprite
@onready var colDetector: CollisionShape2D = $CollisionShape2D
@onready var telColDetector: Area2D = $TeleportCollissionDetection

@export var daggerCircleScene: PackedScene
@export var daggerConeScene: PackedScene
@export var bosArea: Area2D
@export var teleportRange := 300
@export var currentShield: float:
	set(newShield):
		currentShield = newShield
		shieldSprite.visible = currentShield > 0

@export var SPEED := 100

var projectileNode: Node
var daggerList := []

func _ready():
	super._ready()
	shieldSprite.play()
	projectileNode = get_tree().get_first_node_in_group("ProjectileNode")

func takeDamage(dmg: int) -> void:
	var shieldDmg = min(currentShield, dmg)
	currentShield -= shieldDmg
	if currentShield <= 0:
		currentShield = 0
		shieldSprite.visible = false

	dmg -= shieldDmg
	if dmg > 0:
		hp -= dmg

# --- animations and attacks ---

func sacrificeAnimation() -> void:
	playDirectional("sacrifice")

func telegraphDaggerCircling() -> void:
	playDirectional("telegraphDaggerCircling")

func spawnDaggerCircle() -> void:
	var daggerCount := 5
	var previous :DaggerCircling = null
	var spacing := TAU / daggerCount
	for i in daggerCount:
		if previous != null:
			var targetAngle = previous.angle + spacing
			while previous.angle < targetAngle:
				await get_tree().physics_frame
		var dagger = daggerCircleScene.instantiate()
		dagger.angularSpeed = 1 / telegraphTime * 10
		dagger.center = target
		projectileNode.add_child(dagger)
		daggerList.append(dagger)
		previous = dagger

func daggerCirclingAnimation() -> void:
	playDirectional("daggerCircling")

func daggerCirclingAtk() -> void:
	for d in daggerList:
		if d != null:
			d.stopOrbiting()
	daggerList = []

func telegraphDaggerCone() -> void:
	playDirectional("telegraphDaggerCone")

func daggerConeAnimation() -> void:
	playDirectional("daggerCone")

func spawnDaggerCone(angle: float) -> void:
	var dagger = daggerConeScene.instantiate()
	projectileNode.add_child(dagger)
	dagger.global_position = global_position
	dagger.rotation = angle
	dagger.launch(Vector2.RIGHT.rotated(angle))

func daggerConeAtk() -> void:
	var daggerCount := 20
	var coneAngle := 90.0
	var playerAngle = (target.global_position - global_position).angle()
	var startAngle = playerAngle - deg_to_rad(coneAngle / 2.0)
	var endAngle = playerAngle + deg_to_rad(coneAngle / 2.0)
	for i in daggerCount:
		var t := 0.0
		if daggerCount > 1:
			t =  float(i) / float(daggerCount - 1)
		var angle = lerp(startAngle, endAngle, t)
		spawnDaggerCone(angle)
		await get_tree().create_timer(0.1).timeout

func telegraphDaggerExplosion() -> void:
	playDirectional("telegraphDaggerExplosion")

func daggerExplosion() -> void:
	playDirectional("daggerExplosion")

func daggerExplosionAtk(goblinPos: Vector2) -> void:
	var daggerCount := 12
	for i in daggerCount:
		var angle = i * TAU / daggerCount
		var dagger = daggerConeScene.instantiate()
		projectileNode.add_child(dagger)
		dagger.rotation = angle
		dagger.global_position = goblinPos
		dagger.launch(Vector2.RIGHT.rotated(angle))

func telegraphSwipe() -> void:
	playDirectional("telegraphSwipe")

func swipeAtk() -> void:
	var hitbox : Area2D = {
		Facing.Direction.UP: attackUp,
		Facing.Direction.DOWN: attackDown,
		Facing.Direction.LEFT: attackLeft,
		Facing.Direction.RIGHT: attackRight,
	}[facing]
	hitbox.process_mode = PROCESS_MODE_INHERIT
	hitbox.visible = true
	playDirectional("swipe")

func stopAttack() -> void:
	for hitbox : Area2D in [attackUp, attackDown, attackLeft, attackRight]:
		hitbox.visible = false
		hitbox.process_mode = PROCESS_MODE_DISABLED

func teleportAnimation() -> void:
	playDirectional("teleport")

func isValidTeleportPos(pos: Vector2) -> bool:
	var bodyFree = checkBodyColission(pos)
	var isInsideRoom = checkInsideRoom(pos)
	return bodyFree && isInsideRoom

func checkInsideRoom(pos: Vector2) -> bool:
	var params  = PhysicsShapeQueryParameters2D.new()
	params.shape = colDetector.shape
	params.transform = Transform2D(0.0, pos)
	params.collide_with_areas = true
	params.collide_with_bodies = false
	params.exclude = [self.get_rid()]
	var result = get_world_2d().direct_space_state.intersect_shape(params)
	for colission in result:
		if colission.collider == bosArea:
			return true
	return false

func checkBodyColission(pos: Vector2) -> bool:
	var params  = PhysicsShapeQueryParameters2D.new()
	params.shape = colDetector.shape
	params.transform = Transform2D(0.0, pos)
	params.collide_with_areas = false
	params.collide_with_bodies = true
	params.exclude = [self.get_rid()]
	var result = get_world_2d().direct_space_state.intersect_shape(params)
	return result.is_empty()

func teleport() -> void:
	var colliding = true
	var targetPos = Vector2.ZERO
	while(colliding):
		var angle := randf() * TAU
		var radius := randf() * 100 + teleportRange
		targetPos = global_position + Vector2.RIGHT.rotated(angle) * radius
		if isValidTeleportPos(targetPos):
			colliding = false
	global_position = targetPos

func castShieldAnimation() -> void:
	playDirectional("castShield")

func castShield() -> void:
	currentShield = 5
	shieldSprite.visible = true
