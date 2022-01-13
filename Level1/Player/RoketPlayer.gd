extends KinematicBody

var destroyedEffect = load("res://Explosion/ExplosionEnemy.tscn")
onready var main = get_tree().current_scene


var velocity = Vector3()

func _physics_process(delta):
	
	move_and_slide(velocity)
	
	if transform.origin.z > main.playerRocketDismissZ :
		queue_free()


func _on_Area_body_entered(body):
	if body.is_in_group(main.playerEnemiesGroup[0]) or \
		body.is_in_group(main.playerEnemiesGroup[1]) or \
		body.is_in_group(main.playerEnemiesGroup[2]):

			var audioExploded = main.get_node(main.AUDIO_SMALL_EXPLOSION)
			if audioExploded :
				audioExploded.play()

			var particles = destroyedEffect.instance()
			main.add_child(particles)

			particles.exploded = true
			particles.scale = Vector3(3,3,3)
			particles.transform.origin = transform.origin
							
			if body.is_in_group(main.playerEnemiesGroup[0]) :
				main.totalEnemyShipDestroyed += 1
				main.totalScores += main.playerShootShipPoint
				
			elif body.is_in_group(main.playerEnemiesGroup[1]) :
				main.totalHeliDestroyed += 1
				main.totalScores += main.playerShootHeliPoint
				
			elif body.is_in_group(main.playerEnemiesGroup[2]) :
				main.totalScores += main.playerShootQDonBallPoint
				
			else :
				pass

			body.queue_free()
			queue_free()

