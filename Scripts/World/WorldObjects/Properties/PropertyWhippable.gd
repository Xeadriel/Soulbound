class_name PropertyWhippable extends Area2D

signal gotWhipped

func onAreaEntered(area: Area2D) -> void:
	if area is WhipAttack:
		area.queue_free()
		gotWhipped.emit()
