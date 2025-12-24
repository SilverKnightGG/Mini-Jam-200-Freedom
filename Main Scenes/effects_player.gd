extends AudioStreamPlayer

const DIG_AUDIO: AudioStreamOggVorbis = preload("uid://btxutuh1fso0m")
const PARROT_FLAP: AudioStreamOggVorbis = preload("uid://8hf6prh4somn")
const RUNNING_LOOP: AudioStreamOggVorbis = preload("uid://bumkemxlomja")
const TREASURE_SHOVEL_HIT: AudioStreamOggVorbis = preload("uid://dwsolynwrmu5p")
const CHEST_OPENING: AudioStreamOggVorbis = preload("uid://cuxwm0fqmq8a1")
const WIN_STINGER: AudioStreamOggVorbis = preload("uid://d32jd7ucc54ru")
const FAIL_STINGER: AudioStreamOggVorbis = preload("uid://dyjyx5asmbatr")



func _on_play_dig():
	set_stream(DIG_AUDIO)
	play()


func _on_play_fail():
	set_stream(FAIL_STINGER)
	play()


func _on_play_walk(is_walking: bool):
	if is_walking:
		set_stream(RUNNING_LOOP)
		play()
	else:
		if stream == RUNNING_LOOP:
			stop()


func _on_play_flap():
	set_stream(PARROT_FLAP)
	play()


func _on_play_shovel_hit():
	var sequence: Array[AudioStreamOggVorbis] = [TREASURE_SHOVEL_HIT, CHEST_OPENING, WIN_STINGER]

	var play_next := func():
		if sequence.size() == 0:
			return
		set_stream(sequence.pop_back())
		play()

	finished.connect(play_next.call())
	play_next.call()


func _ready():
	pass # TODO add connecting Globals signals for the play functions
	if not Globals.dig_sound.is_connected(_on_play_dig):
		Globals.dig_sound.connect(_on_play_dig)
	if not Globals.found_treasure.is_connected(_on_play_shovel_hit):
		Globals.found_treasure.connect(_on_play_shovel_hit)
	if not Globals.walk_sound.is_connected(_on_play_walk):
		Globals.walk_sound.connect(_on_play_walk)
