# room_layout.gd
class_name RoomLayout extends Node2D

## Dungeon generation class focused on distributing rooms.

signal all_rooms_sleeping
signal generation_finished(graph: Array, rooms: Array)

var _mst: MinimumSpanningTree = MinimumSpanningTree.new()
var _graph: DelaunayGraph = DelaunayGraph.new()

var _count: int

## Is true when function [method generate] was called but not finished yet.
var generating: bool

## Uses physics simulation to determine dungeon layout. Can't be run simultaneously, you need to wait for [signal generation_finished] first.
func generate(room_amount: int, seed: int = 0) -> void:
	if generating:
		return
	
	generating = true
	var rooms: Array = _distribute_rooms(room_amount, seed)
	_count = room_amount
	
	await all_rooms_sleeping
	
	var points = rooms.map(func(room): return room.position)
	
	var graph: Array = _graph.create(points)
	var mst: Array = _mst.solve(graph)
	
	var dungeon_graph = _create_loops(mst, graph, seed)
	
	generation_finished.emit(dungeon_graph, rooms)
	
	generating = false


func _distribute_rooms(amount: int, seed: int = 0) -> Array:
	seed(seed)
	
	var rooms: Array
	
	for i in amount:
		var room_size = Vector2(randi_range(3, 8), randi_range(3, 8))
		var room_position = Vector2(randi_range(-8, 8), randi_range(-8, 8))
		
		var room = _create_room(room_size, room_position)
		
		room.sleeping_state_changed.connect(_on_room_sleeping_state_changed.bind(room))
		
		add_child(room)
		rooms.append(room)
	
	return rooms


func _create_room(size: Vector2, position: Vector2) -> Room:
	var room = Room.new(size, Vector2(1, 1) * 2)
	room.position = position
	room.lock_rotation = true
	
	return room


func _on_room_sleeping_state_changed(room: Room) -> void:
	_count -= 1
	
	room.position = room.position.round()
	
	if _count == 0:
		all_rooms_sleeping.emit()


func _create_loops(mst: Array, graph: Array, seed: int = 0) -> Array:
	seed(seed)
	
	var tree: Array = mst[0].duplicate()
	var total_weight: int = mst[1]
	
	var extra_edges: int = randi_range(int(tree.size() * 0.2), int(tree.size() * 0.4))
	var added: int = 0
	
	while added < extra_edges:
		var node = randi_range(0, graph.size() - 1)
		var connection = graph[node].pick_random()
		
		var other_node = connection[0]
		var weight = connection[1]
		
		var edge = [node, other_node, weight]
		
		if !mst[0].has(edge):
			added += 1
			tree.append(edge)
			total_weight += weight
	
	return [tree, total_weight]
