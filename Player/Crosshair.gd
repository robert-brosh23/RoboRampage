@tool
extends Control

func _draw() -> void:
	
	draw_line(Vector2(4, 0), Vector2(12, 0), Color.WHITE, 2)
	draw_line(Vector2(-4, 0), Vector2(-12, 0), Color.WHITE, 2)
	draw_line(Vector2(0, 4), Vector2(0, 12), Color.WHITE, 2)
	draw_line(Vector2(0, -4), Vector2(0, -12), Color.WHITE, 2)
