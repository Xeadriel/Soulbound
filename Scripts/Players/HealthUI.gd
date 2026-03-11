extends Control

@export var player: Player = null
@onready var leftHeart = $HalfHeartLeft
@onready var rightHeart = $HalfHeartRight

@onready var leftHeartPlayer2 = $HalfHeartLeftPlayer2
@onready var rightHeartPlayer2 = $HalfHeartRightPlayer2

var hearts

var hp = 6

const IDLE = "idle"
const TAKEDAMAGE = "takeDamage"
const HEAL = "heal"

func _ready() -> void:
	if player == null:
		queue_free()
	
	player.playerTakesDamage.connect(playerTookDamage)
	player.hp = hp
	
	hearts = []
	
	var leftCounter = 0
	var rightCounter = 0
	
	if player.name == "Player":
		var nextIsLeft = true
		for i in range(player.maxHp):
			if nextIsLeft:
				var newLeftHeart = leftHeart.duplicate()
				newLeftHeart.position.x += (leftCounter) * (64 + 12)
				hearts.append(newLeftHeart)
				add_child(newLeftHeart)
				newLeftHeart.visible = true
				leftCounter += 1
			else:
				var newRightHeart = rightHeart.duplicate()
				newRightHeart.position.x += (rightCounter) * (64 + 12)
				hearts.append(newRightHeart)
				add_child(newRightHeart)
				newRightHeart.visible = true
				rightCounter += 1
			
			nextIsLeft = not nextIsLeft
	else:
		var nextIsRight = true
		
		for i in range(player.maxHp):
			if nextIsRight:
				var newRightHeart = rightHeart.duplicate()
				newRightHeart.position.x += rightCounter * -64 + rightCounter * -12
				hearts.append(newRightHeart)
				newRightHeart.visible = true
				rightCounter += 1
				add_child(newRightHeart)
			else:
				var newLeftHeart = leftHeart.duplicate()
				newLeftHeart.position.x += leftCounter * -64 + leftCounter * -12
				hearts.append(newLeftHeart)
				newLeftHeart.visible = true
				leftCounter += 1
				add_child(newLeftHeart)
			
			nextIsRight = not nextIsRight


func playerTookDamage(dmgValue):	
	for i in range(dmgValue):
		if hp == 0: return
		hp = clamp(hp - 1, 0, player.maxHp)
		hearts[hp].play(TAKEDAMAGE)
	
