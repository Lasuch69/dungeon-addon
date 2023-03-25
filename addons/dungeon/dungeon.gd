# dungeon.gd
extends Node2D

var _layout: RoomLayout = RoomLayout.new()

var _rooms: Array
var _points: Array
var _graph: Array

func _ready() -> void:
	add_child(_layout)
	_layout.generate(16, 0)
	_layout.generation_finished.connect(_on_layout_generation_finished)


func _draw() -> void:
	if _graph.is_empty():
		return
	
	var edges = _graph[0]
	
	for edge in edges:
		var point: Vector2 = _points[edge[0]]
		var other_point: Vector2 = _points[edge[1]]
		
		draw_line(point, other_point, Color.GHOST_WHITE)
	
	for room in _rooms:
		var rect: Rect2 = room.get_rect()
		
		rect.position -= rect.size / 2
		
		draw_rect(rect, Color.GHOST_WHITE)


func _on_layout_generation_finished(graph, rooms):
	_points = rooms.map(func(room): return room.position)
	_graph = graph
	_rooms = rooms
	
	queue_redraw()
