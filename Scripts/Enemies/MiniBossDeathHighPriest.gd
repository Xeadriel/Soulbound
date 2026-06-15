class_name MiniBossDeathHighPriest extends Enemy

@onready var shieldSprite = $ShieldSprite

@export var currentShield: float:
	set(newShield):
		currentShield = newShield
		if currentShield <= 0:
			shieldSprite.visible = false
		else:
			shieldSprite.visible = true
			
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

func telegraphAttack() -> void:
	match direction:
		Direction.UP:
			animatedSprite.play("telegraphBack")
		Direction.DOWN:
			animatedSprite.play("telegraphFront")	
		Direction.LEFT:
			animatedSprite.play("telegraphLeft")
		Direction.RIGHT:
			animatedSprite.play("telegraphRight")

func attack() -> void:
	match direction:
		Direction.UP:
			animatedSprite.play("attackBack")
		Direction.DOWN:
			animatedSprite.play("attackFront")
		Direction.LEFT:
			animatedSprite.play("attackLeft")
		Direction.RIGHT:
			animatedSprite.play("attackRight")

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
