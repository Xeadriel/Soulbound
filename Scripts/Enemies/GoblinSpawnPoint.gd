extends Node2D

@export var enemyScenes := {
	"goblin": preload("res://Scenes/Enemies/Goblin.tscn"),
	"goblinWizard": preload("res://Scenes/Enemies/Wizard.tscn")
}

func summonGobWizard() -> void:
	var enemy = enemyScenes["goblinWizard"].instantiate()
	enemy.global_position = global_position
	get_parent().add_child(enemy) # set it to be child of the current room
	
func summonGob() -> void:
	var enemy = enemyScenes["goblin"].instantiate()
	enemy.global_position = global_position
	get_parent().add_child(enemy)
	
func summonRandom() -> void: 
	var k = enemyScenes.keys().pick_random()
	var enemy = enemyScenes[k].instantiate()
	get_parent().add_child(enemy)
