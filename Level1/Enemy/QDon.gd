extends KinematicBody

var qdonBall : int
var destroyEffect = load("res://Explosion/ExplosionEnemy.tscn")
var serial = 0
const QDON_ANIM_SHOW : String = "ShowUp"
const QDON_ANIM_ROLL : String = "Roll"

onready var main = get_tree().current_scene

func _ready(): 
		
	$AnimationPlayer.playback_speed = 6
	$AnimationPlayer.play(QDON_ANIM_SHOW)
	
func _process(delta): 
	
	qdonBall = $Qudon.get_child_count()
	
	if qdonBall == 0 :
		qdonHancur()

	if qdonBall > 0 :				
		var qdonSpeed : float = 6.0/qdonBall
		$AnimationPlayer.playback_speed = qdonSpeed

	
func qdonHancur() :
	
	main.reportEvents(self)
#
	var playExplosion = main.get_node(main.AUDIO_FINISH_LEVEL)
	if playExplosion :
		playExplosion.play()
	
	var particles = destroyEffect.instance()
	main.add_child(particles)
	particles.scale = Vector3(5,5,5)
	particles.exploded = true
	particles.transform.origin = transform.origin
	$AnimationPlayer.stop()	
	queue_free()
	
	
func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == QDON_ANIM_SHOW:
		$AnimationPlayer.play(QDON_ANIM_ROLL)
		
		
	
	
