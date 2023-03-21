# graph.gd
class_name DelaunayGraph extends RefCounted

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
	return roundi(point.distance_to(other_point) / 10.0)
