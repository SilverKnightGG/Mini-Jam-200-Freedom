extends Node


#region game state

enum Game {SPLASH, MAIN_MENU, PAUSE_MENU, PLAYING, GAME_OVER, SUCCESS, CREDITS}
var game_state: Game = Game.SPLASH
var paused_state: Game = Game.PLAYING

#enter

func _enter_splash():
	game_state = Game.SPLASH


func _enter_main_menu():
	game_state = Game.MAIN_MENU


func _enter_pause_menu():
	paused_state = Game.PAUSE_MENU
	get_tree().paused = true


func _enter_playing():
	if not game_state == Game.PLAYING:
		game_state = Game.PLAYING
	paused_state = Game.PLAYING


func _enter_game_over():
	game_state = Game.GAME_OVER
	await Globals.pirate.finished_kneeling
	# TODO show the game_over scene and free the game_stage


func _enter_success():
	game_state = Game.SUCCESS
	await Globals.pirate.finished_cheering
	# TODO show the success scene and free the game_stage


func _enter_credits():
	game_state = Game.CREDITS

#exit

func _exit_splash():
	pass


func _exit_main_menu():
	pass


func _exit_pause_menu():
	paused_state = Game.PLAYING
	get_tree().paused = false


func _exit_playing():
	pass


func _exit_game_over():
	pass


func _exit_success():
	pass


func _exit_credits():
	pass

#endregion game state


func _input(event: InputEvent) -> void:
	match game_state:
		Game.SPLASH:
			if Input.is_action_just_pressed("CONTINUE"):
				_exit_splash()
				_enter_main_menu()
		Game.MAIN_MENU:
			if Input.is_action_just_pressed("CONTINUE"):
				_exit_main_menu()
				_enter_playing()
		Game.PLAYING:
			if Input.is_action_just_pressed("BACK_PAUSE"):
				if paused_state == Game.PLAYING:
					_enter_pause_menu()
				else:
					_exit_pause_menu()
		Game.GAME_OVER:
			pass
		Game.SUCCESS:
			pass
		Game.CREDITS:
			if Input.is_action_just_pressed("CONTINUE"):
				_exit_credits()
				_enter_splash()


func _on_treasure_found():
	_enter_success()


func _on_game_stage_failure():
	_enter_game_over()
