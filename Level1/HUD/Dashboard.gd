extends Control

onready var main = get_tree().current_scene

func _on_ButtonContinue_pressed():
	main.playContinue()


func _on_ButtonReplay_pressed():
	main.mainLagi() # Replace with function body.
