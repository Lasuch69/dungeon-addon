# delaunay_graph.gd
class_name DelaunayGraph extends RefCounted

## Class used to generate graph based on delaunay triangulation.
## Usage:
##    [codeblock]
##    var points: PackedVector2Array = [Vector2(100, 0), Vector2(0, 100), Vector2(-100, 0)]
##    var delaunay_graph = DelaunayGraph.new()
##    var graph = delaunay_graph.create(points)
##    print(graph) # prints [[[1, 14], [2, 20]], [[0, 14], [2, 14]], [[1, 14], [0, 20]]]
##    var node: int = 0
##    var node_edges: Array = graph[node]
##    print(node_edges) # prints [[1, 14], [2, 20]]
##    var first_edge: Array = node_edges[0]
##    print(first_edge) # prints [1, 14]
##    var other_node: int = first_edge[0] # 1
##    var weight: int = first_edge[1] # 14
##    [/codeblock]


## Used to calculate weight of an edge, the bigger the number the bigger difference between weights. 
## Useful for making dungeon generation care more about the edge distance. [code]roundi(distance * weight_multiplier)[/code]
var weight_multiplier: float = 0.1

## Create graph based on delaunay triangulation. Returns three-dimensional [Array] of size [code]n[/code], with [code]n[/code] being equivalent of node.
func create(points: PackedVector2Array) -> Array:
	var indices = Geometry2D.triangulate_delaunay(points)
	
	return _create(points, indices)


func _create(points: PackedVector2Array, indices: PackedInt32Array) -> Array:
	var graph: Array = []
	
	graph.resize(points.size())
	
	for index in graph.size():
		graph[index] = []
	
	for i in int(indices.size() / 3.0):
		var triangle = indices.slice(i * 3, i * 3 + 3)
		
		for indice in triangle:
			for other_indice in triangle:
				if indice == other_indice:
					continue
				
				var weight = _get_weight(points[indice], points[other_indice])
				graph[indice].append([other_indice, weight])
	
	return graph


func _get_weight(point: Vector2, other_point: Vector2) -> int:
	return roundi(point.distance_to(other_point) * weight_multiplier)
