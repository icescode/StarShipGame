extends Spatial

#DASHBOARD
var totalEnemyShipDestroyed : int = 0
var totalEnemyShipPassed : int = 0
var totalHeliDestroyed : int = 0
var totalHeliPassed : int = 0
var totalCollide : int = 0
var totalScores : int = 0
var health : int = 100
var timeGenerator : Timer
var clock : int = 0


#LEVEL
const TICK_CLOCK : float = 1.0
const LEVEL1_STAGE1_SPEED : int =  30
const LEVEL2_STAGE1_SPEED : int =  50
const LEVEL3_STAGE1_SPEED : int =  5
const DIE_SPEED : int = 2
const CLOCK1_INTERVAL : int = 30
const CLOCK2_INTERVAL : int = 60
const CLOCK3_INTERVAL : int = 90
var levelCompleted : bool = false

#PLAYER
var playerMaxSpeed : int = 20
var playerAcceleration : float = 1.0
var playerRocketInterval : float = 0.1
var playerXClamp : Array = [-14,14]
var playerYClamp : Array = [1.0, 10]
var playerDecreasePointWhenCollide : int = 10
var playerMinimalGroundHitElevation : float = 0.3
var playerShootShipPoint : int = 50
var playerShootHeliPoint : int = 20
var playerShootQDonBallPoint  : int = 500
var playerEnemiesGroup : Array = ["GroupEnemies","GroupHelis","GroupQDonBall"]
const PLAYER_NAME : String = "Player"
#ROCKET
var playerRocketSpeed : int = 600
var playerRocketDismissZ : int = 40
const rocketGroup : String = "GroupRocket"

#STEALTH SHIP
var stealthShipDismissZ : int = -15
var stealthSpeed : int = 0
const SS_SPEED = {
	SLOW_SPEED = -10,
	MEDIUM_SPEED = -20,
	HIGH_SPEED = -30
}
const MIN_SHIP_ELEVATION : float = 1.0
const MAX_SHIP_ELEVATION : float = 4.0


#HELI
var heliDissmissZ : int = -15
var heliSpeed : int = -2
const MIN_HELI_ELEVATION : float = 2.0
const MAX_HELI_ELEVATION : float = 4.0

#GENERAL
const MIN_ENEMY_HORIZON : float = -2.0
const MAX_ENEMY_HORIZON : float = 2.0
const MAX_ENEMY_TARGET_POS : float = -20.0
const MIN_SPAWNER_POS : float = 60.0
const MAX_SPAWNER_POS : float = 100.0
#QDON
var maxQdon: int = 0
var qdon = load("res://Level1/Enemy/QDon.tscn")
const QDON_ELEVATION : float = 8.0
const QDON_TARGET_POS : float = 20.0
const QDON_NAME : String = "QDonEnemy"
#ENEMY
var timerEnemySpawner:Timer 
var enemyStealhShip = load("res://Level1/Enemy/EnemyShip.tscn")
var enemyHeli = load("res://Level1/Enemy/Heli.tscn")

#AUDIO
const AUDIO_SMALL_EXPLOSION : String = "AudioEnemiesExploded"
const AUDIO_FINISH_LEVEL : String = "AudioFinishLevel"
func _ready():
		
	timeGenerator = Timer.new()
	var err = timeGenerator.connect("timeout",self,"_on_timer_timeout")
	if err == OK :
		timeGenerator.set_wait_time(TICK_CLOCK)
		add_child(timeGenerator) #to process	
		timeGenerator.start()
	
		timerEnemySpawner = Timer.new()
		var err_tke = timerEnemySpawner.connect("timeout",self,"_tick_enemy_spawner")
		if err_tke == 0 :
			timerEnemySpawner.set_wait_time(3)	
			add_child(timerEnemySpawner)
			timerEnemySpawner.start()
	
	
				
func _process(delta):

	debugStage()
	
	if health <= 0 :
		completeDie()
		
	else :

		$Dashboard/LabelHealth.text = str(health) + " %"
		$Dashboard/LabelScores.text = str(totalScores)
		
		if Input.is_action_just_pressed("ui_page_up") and $Camera.transform.origin.z > -30:
			$Camera.transform.origin.z -= 1
			
		if Input.is_action_just_pressed("ui_page_down") and $Camera.transform.origin.z < 3 :
			$Camera.transform.origin.z += 1
		else :
			pass
		
		
func _on_timer_timeout():
	clock += 1
	
func _tick_enemy_spawner() :
	if !levelCompleted :
		
		if clock > 0 and clock < CLOCK1_INTERVAL :			
			$TrackGranit/AnimationPlayer.playback_speed = LEVEL1_STAGE1_SPEED
			generateRandowStealthShip(1)
			generateRandomHeli(1)
			stealthSpeed = SS_SPEED.SLOW_SPEED
			
		elif clock > CLOCK1_INTERVAL and clock < CLOCK2_INTERVAL :
			
			$TrackGranit/AnimationPlayer.playback_speed = LEVEL2_STAGE1_SPEED
			generateRandowStealthShip(2)
			generateRandomHeli(1)
			stealthSpeed = SS_SPEED.MEDIUM_SPEED
			
		elif clock > CLOCK2_INTERVAL and clock < CLOCK3_INTERVAL :
			$TrackGranit/AnimationPlayer.playback_speed = DIE_SPEED
			enteringLevelThree()		
			generateRandowStealthShip(3)
			generateRandomHeli(1)
			stealthSpeed = SS_SPEED.HIGH_SPEED
		else :
			generateRandowStealthShip(1)
			generateRandomHeli(1)
			
func enteringLevelThree() :	
	if maxQdon == 0 :
		var qdonEnemy = qdon.instance()		
		qdonEnemy.name = QDON_NAME
		qdonEnemy.serial = 10
		add_child(qdonEnemy)
		qdonEnemy.transform.origin = Vector3(0,QDON_ELEVATION,QDON_TARGET_POS)
		maxQdon +=1
			
func completeDie() :
	var player = get_node(PLAYER_NAME)	
	if player :
		
		player.playerDestroyed()
		health = 0
		timeGenerator.stop()
		timerEnemySpawner.stop()
		
		$Dashboard/LabelHealth.text = "0"
		$TrackGranit/AnimationPlayer.playback_speed = DIE_SPEED
		$Dashboard/ButtonContinue.visible = true		

func playContinue() :
	health = 100
			
	if clock <= CLOCK1_INTERVAL :
		$TrackGranit/AnimationPlayer.playback_speed = LEVEL1_STAGE1_SPEED
	elif clock > CLOCK1_INTERVAL and clock <= CLOCK2_INTERVAL :
		$TrackGranit/AnimationPlayer.playback_speed = LEVEL2_STAGE1_SPEED
	else :
		$TrackGranit/AnimationPlayer.playback_speed = LEVEL3_STAGE1_SPEED
		
	var player = get_node(PLAYER_NAME)
	
	if player :
		player.playerContinue()
		timeGenerator.start()
		timerEnemySpawner.start()
		player.transform.origin = Vector3(0,0,0)
				
	$Dashboard/ButtonContinue.visible = false		
	
func reportEvents(sender) :
	
	if sender.name == QDON_NAME and sender.serial == 10:		
				
		$TrackGranit/AnimationPlayer.playback_speed = DIE_SPEED
		$Dashboard/CaptionComplete.visible = true
		$Dashboard/ButtonReplay.visible = true
		
		if !timeGenerator.is_stopped() :
			timeGenerator.stop()

		if !timerEnemySpawner.is_stopped() :
			timerEnemySpawner.stop()
		
		var player = get_node(PLAYER_NAME)		
		if player :
			player.timerRocket.stop()	

		levelCompleted = true
		$TrackGranit.enableCollision = false
		
func generateRandowStealthShip(seeder : int) :
	
	if seeder > 0 :
		for i in range(seeder) :			
			
			#pos where enemies start
			var s_ship = enemyStealhShip.instance()
			var random_y : float = rand_range(MIN_SHIP_ELEVATION,MAX_SHIP_ELEVATION)
			var random_z : float = rand_range(MIN_SPAWNER_POS,MAX_SPAWNER_POS)
			var random_x : float = rand_range(MIN_ENEMY_HORIZON,MAX_ENEMY_HORIZON)
			
			s_ship.transform.origin = Vector3(ceil(random_x),ceil(random_y),ceil(random_z))
			s_ship.AnimStarter = i
			
			add_child(s_ship)

func generateRandomHeli(seeder : int) :
	if seeder > 0 :
		for i in range(seeder) :
			var heli = enemyHeli.instance()
			var random_y : float = rand_range(MIN_HELI_ELEVATION,MAX_HELI_ELEVATION)
			var random_z : float = rand_range(MIN_SPAWNER_POS,MAX_SPAWNER_POS)
			var random_x : float = rand_range(MIN_ENEMY_HORIZON,MAX_ENEMY_HORIZON)
			heli.transform.origin = Vector3(ceil(random_x),ceil(random_y),ceil(random_z))
			add_child(heli)

func mainLagi() :
	var err = get_tree().reload_current_scene()
	if !err == OK :
		print('Reload Game Failed') 
						
func debugStage() :
	var statObjects : String = "Objects [" + str(get_child_count()) +"] "
	var statEnemy : String = "Ship destroyed:passed [" + str(totalEnemyShipDestroyed) + ": " + str(totalEnemyShipPassed)+"]"
	var statHeli : String = "Heli destroyed:passed [" + str(totalHeliDestroyed) + ":" + str(totalHeliPassed)+"]"
	var statCollide : String = "Collide " + str(totalCollide)
	
	$Dashboard/LabelDebug.text = statObjects + " " +statEnemy + " " +statHeli + " "+ statCollide
