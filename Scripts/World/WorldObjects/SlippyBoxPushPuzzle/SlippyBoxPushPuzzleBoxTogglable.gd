class_name SlippyBoxPushPuzzleBoxTogglable extends StaticBody2D



func toggle():
	if process_mode == Node.PROCESS_MODE_DISABLED:
		process_mode = Node.PROCESS_MODE_INHERIT
		modulate = Color(1.0, 1.0, 1.0)
	else:
		process_mode = Node.PROCESS_MODE_DISABLED
		modulate = Color(0.439, 0.439, 0.439)
