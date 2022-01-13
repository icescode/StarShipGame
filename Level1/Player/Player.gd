extends KinematicBody

var inputVector = Vector3()
var velo = Vector3()
var playerDie : bool = false
var currentPosisi = Vector3()
var timerRocket:Timer
var PlayerRocket = load("res://Level1/Player/RoketPlayer.tscn")
var destroyedEffect = load("res://Explosion/ExplosionEnemy.tscn")

onready var main = get_tree().current_scene
onready var guns = [$Gun1,$Gun2]


func _ready():
	timerRocket = Timer.new()
	var err  = timerRocket.connect("timeout",self,"_on_timer_timeout")
	if err == OK :
		timerRocket.set_wait_time(main.playerRocketInterval)
		add_child(timerRocket)
		timerRocket.start()
		$EnggineSound.play()

func _physics_process(delta):
	
	if !playerDie :
		inputVector.x = Input.get_action_strength("ui_left") - Input.get_action_strength("ui_right")
		inputVector.y = Input.get_action_strength("ui_up") - Input.get_action_strength("ui_down")
		inputVector = inputVector.normalized()
		velo.x = move_toward(velo.x, inputVector.x * main.playerMaxSpeed, main.playerAcceleration)
		velo.y = move_toward(velo.y, inputVector.y * main.playerMaxSpeed, main.playerAcceleration)
		rotation_degrees.z = velo.x * 2
		rotation_degrees.x = velo.y / 2
		rotation_degrees.y = -velo.x / 2
		currentPosisi = move_and_slide(velo)
		transform.origin.x = clamp(transform.origin.x, main.playerXClamp[0], main.playerXClamp[1])
		transform.origin.y = clamp(transform.origin.y, main.playerYClamp[0], main.playerYClamp[1])
		
		
		testHitGround()
	
func fire() :
	
	for i in guns:
		var rocket = PlayerRocket.instance()
		main.add_child(rocket)
		rocket.transform = i.global_transform
		rocket.velocity = rocket.transform.basis.z * main.playerRocketSpeed

func _on_timer_timeout():
	fire()

func _on_Area_body_entered(body):
	
	if body.is_in_group(main.playerEnemiesGroup[0]) or body.is_in_group(main.playerEnemiesGroup[1]) :
		var particles = destroyedEffect.instance()
		main.add_child(particles)
		
		particles.exploded = true		
		particles.transform.origin = transform.origin
		
		body.queue_free()
		main.totalCollide += 1
		main.health -= main.playerDecreasePointWhenCollide


func testHitGround() :
	if transform.origin.y <= main.playerMinimalGroundHitElevation :
		$Explosion/Ledakan.set_emitting(true)

	
func playerDestroyed() :		
	visible = false
	playerDie = true
	timerRocket.stop()
	
func playerContinue() :
	timerRocket.start()	
	playerDie = false
	visible = true
