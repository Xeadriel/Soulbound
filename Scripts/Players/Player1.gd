class_name Player1 extends Player
## Sword fighter: melee light and heavy combos using hitbox areas.

@export var LIGHT_DAMAGE = 1
@export var HEAVY_DAMAGE = 2

@onready var lightAttacks : Array = $AttackPivotPoint/LightAttacks.get_children()
@onready var heavyAttacks : Array = $AttackPivotPoint/HeavyAttacks.get_children()

# attacks in facing direction
# takes integer combo as parameter to specify which
# animation in a potential attack combo to play
func attack(combo : int) -> void:
	super.attack(combo)
	# combo 0 wraps around to the last hitbox, which is fine because it is disabled anyway
	setHitboxActive(lightAttacks[combo - 1], false)
	setHitboxActive(lightAttacks[combo], true)

func stopAttack() -> void:
	for atk in lightAttacks:
		setHitboxActive(atk, false)

# takes integer combo as parameter to specify which
# animation in a potential attack combo to play
func attackHeavyWindup(combo : int) -> void:
	animatedSprite.stop()
	playDirectional("attackHeavy", "" if combo == 0 else str(combo))

# attacks in facing direction, combo decides which hitbox is used
func attackHeavy(combo : int) -> void:
	setHitboxActive(heavyAttacks[combo - 1], false)
	setHitboxActive(heavyAttacks[combo], true)

func stopAttackHeavy() -> void:
	for atk in heavyAttacks:
		setHitboxActive(atk, false)

func setHitboxActive(hitbox: Area2D, active: bool) -> void:
	hitbox.visible = active
	hitbox.process_mode = PROCESS_MODE_INHERIT if active else PROCESS_MODE_DISABLED

# signal when one of the light attacks area2D collides with something
func lightAttackHitSomething(body: Node2D) -> void:
	if body is Enemy:
		var enemy : Enemy = body
		enemy.takeDamage(LIGHT_DAMAGE, self)

# signal when one of the heavy attacks area2D collides with something
func heavyAttackHitSomething(body: Node2D) -> void:
	if body is Enemy:
		var enemy : Enemy = body
		enemy.takeDamage(HEAVY_DAMAGE, self)
