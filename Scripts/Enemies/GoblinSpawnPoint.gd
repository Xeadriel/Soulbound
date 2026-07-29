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

@export var spawnInterval := 2.0

@onready var timer :Timer = $Timer

var active := false

func _ready() -> void:
	timer.wait_time = spawnInterval
	timer.timeout.connect(_on_timer_timeout)
	
func activate() -> void:
	if active:
		return
	active = true
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
	active = false
	timer.stop()
	
func spawnEnemy(scene: PackedScene):
	var enemy = scene.instantiate()
	enemy.global_position = global_position
	get_parent().add_child(enemy)
