extends Node2D

enum enemyTypes {
	RANDOM,
	GOBLIN,
	GOBLIN_WIZARD,
}

@export var enemies := {
	enemyTypes.GOBLIN: "res://Scenes/Enemies/Goblin.tscn",
	enemyTypes.GOBLIN_WIZARD: "res://Scenes/Enemies/Wizard.tscn"
}

var enemyToSpawn : enemyTypes = enemyTypes.RANDOM

@export var spawnInterval := 5.0

@onready var timer :Timer = $Timer

func _ready() -> void:
	timer.wait_time = spawnInterval
	timer.timeout.connect(_on_timer_timeout)
	activate()
	
func activate() -> void:
	timer.start()
	
func _on_timer_timeout() -> void:
	var path: String
	if enemyToSpawn == enemyTypes.RANDOM:
		path = enemies.values().pick_random()
	else:
		path = enemies[enemyToSpawn]
	var scene = load(path)
	spawnEnemy(scene)
	 
func deactivate() -> void:
	timer.stop()
	
func spawnEnemy(scene: PackedScene):
	var enemy = scene.instantiate()
	get_parent().add_child(enemy)
	enemy.global_position = global_position
