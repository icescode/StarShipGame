extends Area

onready var main = get_tree().current_scene

const NODE_PLAYER_EFFECT : String = "Player/Explosion/Ledakan"
const NODE_PLAYER_NAME : String = "Player"
const AUDIO_COLLIDE : String = "SuaraGesekan"

var enableCollision : bool = true

func _on_TrackGranit_body_entered(body):
	
	if enableCollision :
		
		if body.name == NODE_PLAYER_NAME :
			var audioCollide = main.get_node(AUDIO_COLLIDE)
			if audioCollide :
				audioCollide.play()

			var theExplosion = main.get_node(NODE_PLAYER_EFFECT)
			
			if theExplosion :
				theExplosion.set_emitting(true)

			#main.totalCollide += 1
			main.health -= 10
