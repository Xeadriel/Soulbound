extends Node
"""
gobbo dungeon
	"altar"
	"altarhallway"
	foodhallway
	foodroom
"""

@export var fogDict: Dictionary

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for key in fogDict.keys():
		fogDict[key] = get_node(fogDict[key])


func onAreaEntered(body: Node2D, areaName: String) -> void:
	if body is not Player:
		return
	
	var fog = fogDict.get(areaName)
	if fog == null:
		printerr(areaName + " does not exist")
		return
	
	var tween = get_tree().create_tween()
	tween.tween_property(fog, "material:shader_parameter/color", Color(0, 0, 0, 0), 1)


func onAreaExited(body: Node2D, areaName: String) -> void:
	if body is not Player:
		return
	
	var fog = fogDict.get(areaName)
	if fog == null:
		printerr(areaName + " does not exist")
		return
	
	var tween = get_tree().create_tween()
	tween.tween_property(fog, "material:shader_parameter/color", Color(0, 0, 0, 1), 1)
