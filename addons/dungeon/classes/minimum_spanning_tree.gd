# minimum_spanning_tree.gd
class_name MinimumSpanningTree extends RefCounted

var _graph: Array
var _priority_queue: Array
var _queue: Array
var _visited: Array

func sort_weight_descending(a, b):
	if a[2] > b[2]:
		return true
	return false


func solve(graph: Array) -> Array:
	_graph = graph.duplicate()
	
	_visited.resize(_graph.size())
	_visited.fill(false)
	
	var mst: Array = lazy_prims()
	
	return mst


func lazy_prims(start_node: int = 0) -> Array:
	var tree_size: int = _graph.size() - 1
	var edge_count: int = 0
	var mst_cost: int = 0
	var mst_edges: Array = []
	
	add_edges(start_node)
	
	while !_queue.is_empty() and edge_count != tree_size:
		var edge = _queue.pop_back()
		
		if !_priority_queue.is_empty():
			edge = _priority_queue.pop_back()
		
		var node_index = edge[1]
		
		if _visited[node_index]:
			continue
		
		edge_count += 1
		mst_edges.append(edge)
		mst_cost += edge[2]
		
		add_edges(node_index)
	
	if edge_count != tree_size:
		return []
	
	return [mst_edges, mst_cost]


func add_edges(node_index: int) -> void:
	_visited[node_index] = true
	
	var connections: Array = _graph[node_index]
	
	var valid_edges: Array = []
	
	# Connection contains other point (index 0) and weight (index 1) in array.
	for connection in connections:
		var edge = connection[0]
		var weight = connection[1]
		
		if _visited[edge]:
			continue
		
		valid_edges.push_back([node_index, edge, weight])
	
	valid_edges.sort_custom(sort_weight_descending)
	
	_priority_queue.clear()
	
	_priority_queue.append_array(valid_edges)
	_queue.append_array(valid_edges)
