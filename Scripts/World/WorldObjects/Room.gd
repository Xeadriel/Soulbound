class_name Room extends Node2D

func updateRoomStatus():
	GlobalStates.lastRoomVisited = self.get_index()
	GlobalStates.seenRooms[self.name] = self.get_index()
