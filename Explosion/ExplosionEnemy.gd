extends Spatial

var exploded : bool
func _ready():
	
	if exploded == true :
		$Ledakan.set_emitting(false)
	else :
		$Ledakan.set_emitting(true)

	
func _physics_process(delta):

	if !$Ledakan.emitting :
		queue_free()
