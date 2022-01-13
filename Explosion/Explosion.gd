extends Spatial

func _physics_process(delta):

	if !$Ledakan.emitting :
		queue_free()

