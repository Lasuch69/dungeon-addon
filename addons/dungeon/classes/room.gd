# room.gd
class_name Room extends RigidBody2D

var collision_shape: CollisionShape2D
var size: Vector2

var collision_margin: Vector2 = Vector2(1, 1):
	set(value):
		collision_margin = value
		collision_shape.shape.size = size + collision_margin

func get_rect() -> Rect2:
	return Rect2(self.global_position, self.size)


func _init(size: Vector2, margin: Vector2 = collision_margin) -> void:
	self.size = size
	
	var shape = RectangleShape2D.new()
	shape.size = size + margin
	
	var collision = CollisionShape2D.new()
	collision.shape = shape
	
	self.collision_shape = collision
	self.add_child(collision, true)
