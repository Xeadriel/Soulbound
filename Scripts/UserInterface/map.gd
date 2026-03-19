extends Control

func getPosFrom(id: int):
	print(self.get_child(id).global_position)
