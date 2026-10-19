extends StateTelegraphSacrifice
## The daggers explode from where the sacrificed minion stood.

func _init() -> void:
	animation = "telegraphDaggerExplosion"
	faceTarget = true
	nextState = DAGGER_EXPLOSION
