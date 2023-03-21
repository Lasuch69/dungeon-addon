class_name Room extends RigidBody2D

func _init(collider: CollisionShape2D = null) -> void:
	if collider:
		self.add_child(collider, true)
	pass
