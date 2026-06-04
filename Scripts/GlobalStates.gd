extends Node

var inventory: Dictionary[GlobalConstants.ItemIndices, int]
var seenRooms: Dictionary[String, int]
var lastRoomVisited: int
var currentDungeon: String
