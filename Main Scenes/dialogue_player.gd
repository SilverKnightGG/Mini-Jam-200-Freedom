extends AudioStreamPlayer


var dialogue_sequence: Array[AudioStreamOggVorbis] = []


func _on_play_dialogue_audio(streams: Array[AudioStreamOggVorbis]):
	print("playing dialogue audio")
	if not streams == []:
		dialogue_sequence.clear()
		dialogue_sequence.assign(streams)

	if not finished.is_connected(play_stream):
		finished.connect(play_stream)

	play_stream()


func play_stream():
	if dialogue_sequence.size() == 0:
		return
	var new_stream: AudioStreamOggVorbis = dialogue_sequence.pop_back()
	set_stream(new_stream)
	play()


func _ready():
	if not Globals.audio_dialogue_play.is_connected(_on_play_dialogue_audio):
		Globals.audio_dialogue_play.connect(_on_play_dialogue_audio)
