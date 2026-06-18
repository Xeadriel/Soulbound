class_name MiniBossDeathHighPriest extends Enemy

@onready var shieldSprite = $ShieldSprite

@onready var colDetector: CollisionShape2D = $CollisionShape2D

@export var teleportRange := 200
@export var currentShield: float:
	set(newShield):
		currentShield = newShield
		if currentShield <= 0:
			shieldSprite.visible = false
		else:
			shieldSprite.visible = true
			
@export var SPEED := 100

func _onready():
	shieldSprite.play()
	currentShield = 100

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _physics_process(_delta: float) -> void:
	move_and_slide()

func takeDamage(dmg: int) -> void:
	currentHp -= dmg
	
"""
Animations
"""

func animationFinished():
	animationFinishedSignal.emit(animatedSprite)
	
func sacrificeGolin():
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

func daggerCircling() -> void:
	match direction:
		Direction.UP:
			animatedSprite.play("daggerCirclingBack")
		Direction.DOWN:
			animatedSprite.play("daggerCirclingFront")
		Direction.LEFT:
			animatedSprite.play("daggerCirclingLeft")
		Direction.RIGHT:
			animatedSprite.play("daggerCirclingRight")

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

func daggerCone() -> void:
	match direction:
		Direction.UP:
			animatedSprite.play("daggerConeBack")
		Direction.DOWN:
			animatedSprite.play("daggerConeFront")
		Direction.LEFT:
			animatedSprite.play("daggerConeLeft")
		Direction.RIGHT:
			animatedSprite.play("daggerConeRight")

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
		
func channelSacrificeGoblin() -> void:
	match direction:
		Direction.UP:
			animatedSprite.play("channelBack")
		Direction.DOWN:
			animatedSprite.play("channelFront")
		Direction.LEFT:
			animatedSprite.play("channelLeft")
		Direction.RIGHT:
			animatedSprite.play("channelRight")

func CastSacrificeGoblin() -> void:
	match direction:
		Direction.UP:
			animatedSprite.play("castBack")
		Direction.DOWN:
			animatedSprite.play("castFront")
		Direction.LEFT:
			animatedSprite.play("castLeft")
		Direction.RIGHT:
			animatedSprite.play("castRight")
			
func stopAttack() -> void:
	attackUp.visible = false
	attackDown.visible = false
	attackLeft.visible = false
	attackRight.visible = false
	attackUp.process_mode = PROCESS_MODE_DISABLED
	attackDown.process_mode = PROCESS_MODE_DISABLED
	attackLeft.process_mode = PROCESS_MODE_DISABLED
	attackRight.process_mode = PROCESS_MODE_DISABLED
	
func teleport() -> void:
	match direction:
		Direction.UP:
			animatedSprite.play("teleportBack")
		Direction.DOWN:
			animatedSprite.play("teleportFront")
		Direction.LEFT:
			animatedSprite.play("teleportLeft")
		Direction.RIGHT:
			animatedSprite.play("teleportRight")
			
func is_valid_position(pos: Vector2) -> bool:
	var space_state = get_world_2d().direct_space_state
	var shape = colDetector.shape.duplicate()

	var params = PhysicsShapeQueryParameters2D.new()
	params.shape = shape
	params.transform = Transform2D(0, pos)
	params.collide_with_areas = false
	params.collide_with_bodies = true

	var result = space_state.intersect_shape(params)

	return result.is_empty()
	
func getTeleportPos() -> Vector2:
	var colliding = true
	var targetPos = Vector2.ZERO
	while(colliding):
		var angle := randf() * TAU
		var radius := randf() * teleportRange
		targetPos = global_position + Vector2(cos(angle), sin(angle)) * radius
		colDetector.global_position = targetPos
		if is_valid_position(targetPos):
			colliding = false
	return targetPos
