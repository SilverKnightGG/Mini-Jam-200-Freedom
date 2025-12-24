extends Node

const STAGE_SCENE: PackedScene = preload("uid://bpmy675hvaha5")


#region game state

enum Game {SPLASH, MAIN_MENU, PAUSE_MENU, PLAYING, GAME_OVER, SUCCESS, CREDITS}
var game_state: Game = Game.SPLASH
var paused_state: Game = Game.PLAYING

var can_continue_to_credits: bool = false

#enter

func _enter_splash():
	%MusicPlayer.play()
	%Splash.show()
	can_continue_to_credits = false
	game_state = Game.SPLASH


func _enter_main_menu():
	%Menu.show()
	game_state = Game.MAIN_MENU



func _enter_pause_menu():
	paused_state = Game.PAUSE_MENU
	get_tree().paused = true
	Globals.time_state = Globals.TimeState.PAUSED


func _enter_playing():
	if not game_state == Game.PLAYING:
		game_state = Game.PLAYING

	var new_stage: Node = STAGE_SCENE.instantiate()
	add_child(new_stage)

	if not %MusicPlayer.playing:
		%MusicPlayer.play()
	paused_state = Game.PLAYING
	Globals.time_state = Globals.TimeState.TICKING


func _enter_game_over():
	game_state = Game.GAME_OVER
	%MusicPlayer.stop()
	await Globals.pirate.finished_kneeling
	can_continue_to_credits = true
	# TODO show the game_over scene and free the game_stage


func _enter_success():
	game_state = Game.SUCCESS
	await Globals.pirate.finished_cheering
	can_continue_to_credits = true
	# TODO show the success scene and free the game_stage


func _enter_credits():
	%MusicPlayer.play()
	game_state = Game.CREDITS

#exit

func _exit_splash():
	%Splash.hide()


func _exit_main_menu():
	%Menu.hide()


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
			pass # We let a brief animation play before automatically showing a scene
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
