class_name MiniBossDeathHighPriest extends Enemy
# TODO dagger circling when getting interrupted from damage needs to be fixed
@onready var shieldSprite = $ShieldSprite
@onready var colDetector: CollisionShape2D = $CollisionShape2D
@onready var telColDetector: Area2D = $TeleportCollissionDetection

@export var daggerCircleScene: PackedScene
@export var daggerConeScene: PackedScene
@export var bossArea: Area2D
@export var teleportRange := 300
@export var currentShield: float:
	set(newShield):
		currentShield = newShield
		# the setter also runs while the scene loads, before shieldSprite is set
		if is_node_ready():
			shieldSprite.visible = currentShield > 0

@export var SPEED := 100

var projectileNode: Node
## Daggers spawned by the circling telegraph that have not been launched yet.
var daggerList : Array[DaggerCircling] = []
## The minion that dies when the ability being telegraphed goes off, or null.
var markedSacrifice : Enemy = null

func _ready():
	super._ready()
	shieldSprite.play()
	projectileNode = Projectile.spawnParent(get_tree())

func takeDamage(dmg: int, _source: Node2D = null) -> void:
	var shieldDmg = min(currentShield, dmg)
	currentShield -= shieldDmg
	if currentShield <= 0:
		currentShield = 0
		shieldSprite.visible = false

	dmg -= shieldDmg
	if dmg > 0:
		hp -= dmg
		if hp % 3 == 0:
			stateMachine.interrupt(StateEnemy.TELEPORT)
	

# the whip is found after this boss, so it cannot affect it
func onItemHit(_item: GlobalConstants.ItemIndices, _playerIndex: int) -> void:
	pass

# --- animations and attacks ---

# --- sacrifices ---
# Abilities that cost a minion mark one when their telegraph starts and kill it
# when the ability goes off (see StateTelegraphSacrifice).

## Whether the room has a minion that could be sacrificed.
func canSacrifice() -> bool:
	return not _sacrificeCandidates().is_empty()

## Marks a random minion in the room as the next sacrifice. Returns false if there is none.
func markSacrifice() -> bool:
	clearSacrifice()
	var candidates := _sacrificeCandidates()
	if candidates.is_empty():
		return false
	markedSacrifice = candidates.pick_random()
	markedSacrifice.setMarkedForSacrifice(true)
	return true

## Whether the marked minion is still alive.
func isSacrificeAlive() -> bool:
	return is_instance_valid(markedSacrifice) and not markedSacrifice.is_queued_for_deletion()

## Kills the marked minion and returns where it stood.
func performSacrifice() -> Vector2:
	var pos := markedSacrifice.global_position
	markedSacrifice.takeDamage(9999)
	markedSacrifice = null
	return pos

## Unmarks the marked minion, if any, without killing it.
func clearSacrifice() -> void:
	if isSacrificeAlive():
		markedSacrifice.setMarkedForSacrifice(false)
	markedSacrifice = null

func _sacrificeCandidates() -> Array[Enemy]:
	var room := Room.containing(self)
	if room == null:
		return []
	return room.minionEnemies()

# --- attacks ---

## Spawns one dagger orbiting the target, starting at [param angle] (radians).
## It orbits until daggerCirclingAtk() launches it.
func spawnCirclingDagger(angle: float, angularSpeed: float) -> DaggerCircling:
	var dagger : DaggerCircling = daggerCircleScene.instantiate()
	dagger.center = target
	dagger.angle = angle
	dagger.angularSpeed = angularSpeed
	projectileNode.add_child(dagger)
	daggerList.append(dagger)
	return dagger

## Launches every orbiting dagger at the target.
func daggerCirclingAtk() -> void:
	for dagger in daggerList:
		# daggers can be freed already, e.g. after hitting something
		if is_instance_valid(dagger):
			dagger.stopOrbiting()
	daggerList.clear()

## Removes the daggers that are still orbiting, e.g. when the telegraph is cancelled.
func clearCirclingDaggers() -> void:
	for dagger in daggerList:
		if is_instance_valid(dagger):
			dagger.queue_free()
	daggerList.clear()

func _exit_tree() -> void:
	# don't leave daggers orbiting or a minion marked when the boss dies mid-telegraph
	clearCirclingDaggers()
	clearSacrifice()

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

func daggerExplosionAtk(goblinPos: Vector2) -> void:
	var daggerCount := 12
	for i in daggerCount:
		var angle = i * TAU / daggerCount
		var dagger = daggerConeScene.instantiate()
		projectileNode.add_child(dagger)
		dagger.rotation = angle
		dagger.global_position = goblinPos
		dagger.launch(Vector2.RIGHT.rotated(angle))

func swipeAtk() -> void:
	meleeHitboxes.enable(facing)

func isValidTeleportPos(pos: Vector2) -> bool:
	var bodyFree = checkBodyCollision(pos)
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
		if colission.collider == bossArea:
			return true
	return false

func checkBodyCollision(pos: Vector2) -> bool:
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

func castShield() -> void:
	currentShield = 3
	shieldSprite.visible = true

func hasShield() -> bool:
	return currentShield > 0
