class_name StateUseBottle extends StatePlayer
## Uses the bottle from a quick slot. What happens depends on what the players' bottles
## hold (see GameSession.bottles): a potion is drunk and heals fully. The player stands
## still while drinking and can still be hit.

## How long drinking takes, in seconds.
@export var DRINK_TIME : float = 0.8
## Tint pulsing on the player while drinking, until there is a drinking animation.
@export var DRINK_TINT := Color(0.6, 1.0, 0.6)

var drinkTimer : float = 0

func enter(_previous_state_path: String, _data := {}) -> void:
	drinkTimer = 0
	var session := GlobalStates.session
	if session.bottlesWith(GlobalConstants.BottleContent.POTION) > 0:
		# nothing to heal: keep the potion
		if player.hp >= player.maxHp:
			transition(STATEIDLE)
			return
		# the bottle is emptied right away, so with one potion left only the
		# player who started drinking first gets it
		session.takeFromBottle(GlobalConstants.BottleContent.POTION)
		player.velocity = Vector2.ZERO
		player.idleAnimation()
	else:
		# all bottles empty
		transition(STATEIDLE)

func process(delta: float) -> void:
	drinkTimer += delta
	player.velocity = Vector2.ZERO
	# pulses twice while drinking
	var pulse := (1.0 - cos(drinkTimer / DRINK_TIME * TAU * 2.0)) / 2.0
	player.animatedSprite.modulate = Color.WHITE.lerp(DRINK_TINT, pulse)

	if drinkTimer >= DRINK_TIME:
		player.heal(player.maxHp)
		transition(STATEIDLE)

func exit() -> void:
	drinkTimer = 0
	player.animatedSprite.modulate = Color.WHITE
