extends StaticBody


var destroyEffect = load("res://Explosion/ExplosionEnemy.tscn")
onready var main = get_tree().current_scene

func _on_Area_body_entered(body):
	if body.is_in_group(main.playerEnemiesGroup[0]) or \
		body.is_in_group(main.playerEnemiesGroup[1]) or \
		body.is_in_group(main.rocketGroup):

		var audioExplosion = main.get_node(main.AUDIO_SMALL_EXPLOSION)
		if audioExplosion :
			audioExplosion.play()


		var particles = destroyEffect.instance()
		add_child(particles)
		
		particles.exploded = true
		particles.scale = Vector3(1,1,1)
		particles.transform.origin = transform.origin
		body.queue_free()

		if body.is_in_group(main.rocketGroup) :
			body.queue_free()
			queue_free()

