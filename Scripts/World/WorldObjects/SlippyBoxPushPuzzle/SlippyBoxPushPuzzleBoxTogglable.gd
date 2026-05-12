class_name SlippyBoxPushPuzzleBoxTogglable extends AnimatedSprite2D



func toggle():
	if process_mode == Node.PROCESS_MODE_DISABLED:
		process_mode = Node.PROCESS_MODE_INHERIT
		self_modulate = Color(1.0, 1.0, 1.0)
	else:
		process_mode = Node.PROCESS_MODE_DISABLED
		self_modulate = Color(0.439, 0.439, 0.439)
