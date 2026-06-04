extends Node

var currentScene = null

func _ready():
	var currentScene = get_tree().get_current_scene()
