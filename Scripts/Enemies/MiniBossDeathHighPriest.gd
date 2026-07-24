class_name MiniBossDeathHighPriest extends Enemy

@onready var shieldSprite = $ShieldSprite
@onready var colDetector: CollisionShape2D = $CollisionShape2D
@onready var telColDetector: Area2D = $TeleportCollissionDetection

@export var daggerCircleScene: PackedScene
@export var daggerConeScene: PackedScene
@export var teleportRange := 500
@export var currentShield: float:
	set(newShield):
		currentShield = newShield
		if currentShield :
			shieldSprite.visible = currentShield > 0

@export var SPEED := 100

var projectileNode: Node
var daggerList := []

func _ready():
	super._ready()
	shieldSprite.play()
	projectileNode = get_tree().get_first_node_in_group("ProjectileNode")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _physics_process(_delta: float) -> void:
	move_and_slide()

func takeDamage(dmg: int) -> void:
	var shieldDmg = min(currentShield, dmg)
	currentShield -= shieldDmg
	dmg -= shieldDmg
	if dmg > 0:
		currentHp -= dmg
	
"""
Animations
"""

func animationFinished():
	animationFinishedSignal.emit(animatedSprite)
	
func sacrificeAnimation():
	match direction: 
		Direction.UP:
			animatedSprite.play("sacrificeBack")
		Direction.DOWN:
			animatedSprite.play("sacrificeFront")	
		Direction.LEFT:
			animatedSprite.play("sacrificeLeft")
		Direction.RIGHT:
			animatedSprite.play("sacrificeRight")

func idle():
	match direction:
			Direction.UP:
				animatedSprite.play("idleBack")
			Direction.DOWN:
				animatedSprite.play("idleFront")	
			Direction.LEFT:
				animatedSprite.play("idleLeft")
			Direction.RIGHT:
				animatedSprite.play("idleRight")

func run():
	match direction:
			Direction.UP:
				animatedSprite.play("runBack")
			Direction.DOWN:
				animatedSprite.play("runFront")	
			Direction.LEFT:
				animatedSprite.play("runLeft")
			Direction.RIGHT:
				animatedSprite.play("runRight")

func telegraphDaggerCircling() -> void:
	match direction:
		Direction.UP:
			animatedSprite.play("telegraphDaggerCirclingBack")
		Direction.DOWN:
			animatedSprite.play("telegraphDaggerCirclingFront")
		Direction.LEFT:
			animatedSprite.play("telegraphDaggerCirclingLeft")
		Direction.RIGHT:
			animatedSprite.play("telegraphDaggerCirclingRight")
			
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
	match direction:
		Direction.UP:
			animatedSprite.play("daggerCirclingBack")
		Direction.DOWN:
			animatedSprite.play("daggerCirclingFront")
		Direction.LEFT:
			animatedSprite.play("daggerCirclingLeft")
		Direction.RIGHT:
			animatedSprite.play("daggerCirclingRight")
			
func daggerCirclingAtk() -> void:
	for d in daggerList:
		d.stopOrbiting()

func telegraphDaggerCone() -> void:
	match direction:
		Direction.UP:
			animatedSprite.play("telegraphDaggerConeBack")
		Direction.DOWN:
			animatedSprite.play("telegraphDaggerConeFront")
		Direction.LEFT:
			animatedSprite.play("telegraphDaggerConeLeft")
		Direction.RIGHT:
			animatedSprite.play("telegraphDaggerConeRight")

func daggerConeAnimation() -> void:
	match direction:
		Direction.UP:
			animatedSprite.play("daggerConeBack")
		Direction.DOWN:
			animatedSprite.play("daggerConeFront")
		Direction.LEFT:
			animatedSprite.play("daggerConeLeft")
		Direction.RIGHT:
			animatedSprite.play("daggerConeRight")
			
func spawnDaggerCone(angle: float) -> void:
	var dagger = daggerConeScene.instantiate()
	projectileNode.add_child(dagger)
	dagger.global_position = global_position
	dagger.rotation = angle
	var direction = Vector2.RIGHT.rotated(angle)
	dagger.launch(direction)
	
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
	match direction:
		Direction.UP:
			animatedSprite.play("telegraphDaggerExplosionBack")
		Direction.DOWN:
			animatedSprite.play("telegraphDaggerExplosionFront")
		Direction.LEFT:
			animatedSprite.play("telegraphDaggerExplosionLeft")
		Direction.RIGHT:
			animatedSprite.play("telegraphDaggerExplosionRight")

func daggerExplosion() -> void:
	match direction:
		Direction.UP:
			animatedSprite.play("daggerExplosionBack")
		Direction.DOWN:
			animatedSprite.play("daggerExplosionFront")
		Direction.LEFT:
			animatedSprite.play("daggerExplosionLeft")
		Direction.RIGHT:
			animatedSprite.play("daggerExplosionRight")
			
func daggerExplosionAtk(goblinPos: Vector2) -> void:
	var daggerCount := 12
	for i in daggerCount:
		var angle = i * TAU / daggerCount
		var direction = Vector2.RIGHT.rotated(angle)
		var dagger = daggerConeScene.instantiate()
		projectileNode.add_child(dagger)
		dagger.rotation = angle
		dagger.global_position = goblinPos
		dagger.launch(direction)

func telegraphSwipe() -> void:
	match direction:
		Direction.UP:
			animatedSprite.play("telegraphSwipeBack")
		Direction.DOWN:
			animatedSprite.play("telegraphSwipeFront")
		Direction.LEFT:
			animatedSprite.play("telegraphSwipeLeft")
		Direction.RIGHT:
			animatedSprite.play("telegraphSwipeRight")

func swipe() -> void:
	match direction:
		Direction.UP:
			attackUp.process_mode = PROCESS_MODE_INHERIT
			attackUp.visible = true
			animatedSprite.play("swipeBack")
		Direction.DOWN:
			attackUp.process_mode = PROCESS_MODE_INHERIT
			attackUp.visible = true
			animatedSprite.play("swipeFront")
		Direction.LEFT:
			attackUp.process_mode = PROCESS_MODE_INHERIT
			attackUp.visible = true
			animatedSprite.play("swipeLeft")
		Direction.RIGHT:
			attackUp.process_mode = PROCESS_MODE_INHERIT
			attackUp.visible = true
			animatedSprite.play("swipeRight")

# signal when area2D collides with something
func hitSomething(body: Node2D) -> void:
	if body is Player:
		var player : Player = body
		player.takeDamage(DAMAGE)

func swipeHit(body: Node2D) -> void:
	if(body is Player):
		var player: Player = body
		player.takeDamage(DAMAGE)


func stopAttack() -> void:
	attackUp.visible = false
	attackDown.visible = false
	attackLeft.visible = false
	attackRight.visible = false
	attackUp.process_mode = PROCESS_MODE_DISABLED
	attackDown.process_mode = PROCESS_MODE_DISABLED
	attackLeft.process_mode = PROCESS_MODE_DISABLED
	attackRight.process_mode = PROCESS_MODE_DISABLED
	
func teleportAnimation() -> void:
	match direction:
		Direction.UP:
			animatedSprite.play("teleportBack")
		Direction.DOWN:
			animatedSprite.play("teleportFront")
		Direction.LEFT:
			animatedSprite.play("teleportLeft")
		Direction.RIGHT:
			animatedSprite.play("teleportRight")
			
func isValidTeleportPos(pos: Vector2) -> bool:
	var spaceState = get_world_2d().direct_space_state
	var params  = PhysicsShapeQueryParameters2D.new()
	params.shape = colDetector.shape
	var transform = colDetector.global_transform 
	transform.origin = pos 
	params.transform = transform
	params.collide_with_areas = false
	params.collide_with_bodies = true
	params.exclude = [self.get_rid()]
	var result = spaceState.intersect_shape(params)
	return result.is_empty()
	
func teleport() -> void:
	var colliding = true
	var targetPos = Vector2.ZERO
	while(colliding):
		var angle := randf() * TAU
		var radius := randf() * teleportRange
		targetPos = global_position + Vector2(cos(angle), sin(angle)) * radius
		colDetector.global_position = targetPos
		if isValidTeleportPos(targetPos):
			colliding = false
	global_position = targetPos
	
func castShieldAnimation() -> void:
	match direction:
		Direction.UP:
			animatedSprite.play("castShieldBack")
		Direction.DOWN:
			animatedSprite.play("castShieldFront")
		Direction.LEFT:
			animatedSprite.play("castShieldLeft")
		Direction.RIGHT:
			animatedSprite.play("castShieldRight")

func castShield() -> void:
	currentShield = 100
	shieldSprite.visible = true
