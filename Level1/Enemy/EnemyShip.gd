extends KinematicBody
var start_pos_y : float
var start_pos_x : float
var end_pos_z : float

var velocity : Vector3 = Vector3()
export var AnimStarter : int = 0
onready var main = get_tree().current_scene
	
const RIGHT_MANUVER : String = "ManuverKanan"
const LEFT_MANUVER : String = "ManuverKiri"
var speedChangeTimer : Timer
var speedMustChange : bool = false

func _ready():
	start_pos_x = rand_range(main.MIN_ENEMY_HORIZON,main.MAX_ENEMY_HORIZON)
	start_pos_y = rand_range(main.MIN_SHIP_ELEVATION,main.MAX_SHIP_ELEVATION)
	end_pos_z = main.MAX_ENEMY_TARGET_POS
	
	speedChangeTimer = Timer.new()
	var err = speedChangeTimer.connect("timeout",self,"_on_timer_timeout")
	if err == OK :
		speedChangeTimer.set_one_shot(true)
		speedChangeTimer.set_wait_time(1)
		add_child(speedChangeTimer)
		speedChangeTimer.start()
	
func _physics_process(delta):
	
	if AnimStarter == 1 :
		$AnimationPlayer.play(RIGHT_MANUVER)
	elif AnimStarter == 2 :
		$AnimationPlayer.play(LEFT_MANUVER)
	else :
		pass
	
	velocity = Vector3(start_pos_x,ceil(start_pos_y),end_pos_z)	
	
	if speedMustChange :
		#let the enemy speed change according main stage variable
		velocity = transform.basis.z * main.stealthSpeed
		move_and_slide(velocity)
	else :				
		#start the enemies and let them elevating to max Y (start_pos_y)
		#delta speed

		move_and_slide(velocity)
		
	
	if transform.origin.z < main.stealthShipDismissZ :
		main.totalEnemyShipPassed += 1
		queue_free()

func _on_timer_timeout() :
	speedMustChange = true
