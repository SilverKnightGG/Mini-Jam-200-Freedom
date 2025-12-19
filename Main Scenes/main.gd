extends Node


#region game state

enum Game {SPLASH, MAIN_MENU, PAUSE_MENU, PLAYING, GAME_OVER, CREDITS}
var game_stat: Game = Game.SPLASH

#enter

func _enter_splash():
	pass


func _enter_main_menu():
	pass


func _enter_pause_menu():
	pass


func _enter_playing():
	pass


func _enter_game_over():
	pass


func _enter_credits():
	pass

#exit

func _exit_splash():
	pass


func _exit_main_menu():
	pass


func _exit_pause_menu():
	pass


func _exit_playing():
	pass


func _exit_game_over():
	pass


func _exit_credits():
	pass

#endregion game state
