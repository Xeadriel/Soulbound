extends Node

# Global script for in game states. should ideally contain everything that is needed 
# to create a save file like game progress etc. which should persist between sessions

var inventory: Dictionary[GlobalConstants.ItemIndices, int]
var seenRooms: Dictionary[String, int]
var lastRoomVisited: int
var currentDungeon: String
var projectileNode: Node

func _ready() -> void:
	for item in GlobalConstants.ItemIndices:
		inventory[GlobalConstants.ItemIndices[item]] = 0
