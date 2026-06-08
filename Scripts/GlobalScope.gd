extends Node

# Global script for states and information that need to persist between scenes
# for example settings, save game slot etc.

var currentScene = null

func _ready():
	GlobalStates.projectileNode = get_tree().current_scene.get_node("2DObjects/Projectiles")
	var currentScene = get_tree().get_current_scene()
