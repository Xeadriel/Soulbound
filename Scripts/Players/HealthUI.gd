extends Control

@export var player: Player = null
## Lay the hearts out from right to left (for the HUD on the right side of the screen).
@export var mirrored : bool = false
@onready var leftHeart = $HalfHeartLeft
@onready var rightHeart = $HalfHeartRight

@onready var leftHeartPlayer2 = $HalfHeartLeftPlayer2
@onready var rightHeartPlayer2 = $HalfHeartRightPlayer2

var hearts

var hp = 6

const IDLE = "idle"
const TAKEDAMAGE = "takeDamage"
const HEAL = "heal"

## Horizontal distance between two hearts of the same half.
const HEART_SPACING := 64 + 12

func _ready() -> void:
	if player == null:
		queue_free()

	player.damaged.connect(playerTookDamage)
	hp = player.hp

	hearts = []

	# hearts are made of alternating left and right halves; mirrored HUDs grow to the left
	var direction := -1 if mirrored else 1
	var halves : Array = [rightHeart, leftHeart] if mirrored else [leftHeart, rightHeart]
	var halfCounts := [0, 0]
	for i in range(player.maxHp):
		var half := i % 2
		var newHeart : AnimatedSprite2D = halves[half].duplicate()
		newHeart.position.x += halfCounts[half] * HEART_SPACING * direction
		hearts.append(newHeart)
		add_child(newHeart)
		newHeart.visible = true
		halfCounts[half] += 1

func playerTookDamage(dmgValue: int) -> void:
	for i in range(dmgValue):
		if hp == 0: return
		hp = clamp(hp - 1, 0, player.maxHp)
		hearts[hp].play(TAKEDAMAGE)
