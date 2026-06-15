extends Node

# Global script for states and information that need to persist between scenes
# for example settings, save game slot etc.

var currentScene = null

func _ready():
	var currentScene = get_tree().get_current_scene()
