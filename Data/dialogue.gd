class_name Dialogue extends Node

const DISTANCE_DELIMITER: String = "^"


enum Character {PIRATE, PARROT}

static var LINES = {
	Character.PIRATE: {
		GROAN = "*groans* Where be that blasted treasure?!",
		GROAN_AUDIO = preload("uid://dj8qfccj3c3oa"),

		CHEER1 = "Yar-har! I founds it!",
		CHEER1_AUDIO = preload("uid://klesfhk6bwyn"),

		CHEER2 = "The chest! Me curse be lifted!",
		CHEER2_AUDIO = preload("uid://db6dyll11oggs"),

		THREAT1 = "Shut up, Polly! Yer lucky I don't boil ye in a stew!",
		THREAT1_AUDIO = preload("uid://dn7xso54cmyg6"),

		THREAT2 = "I'm gonna pluck all yer feathers if ye say that again!",
		THREAT2_AUDIO = preload("uid://lt0hxksmwc6v"),

		EXASPERATION = "Stupid bird...",
		EXASPERATION_AUDIO = preload("uid://ba1113uqms3af"),

		EXPOSITION = "I needs to find that chest, or I'll stay cursed forever!",
		EXPOSITION_AUDIO = preload("uid://ctvb7qicapnwk")
	},
	Character.PARROT: {
		SQUAWK = "*squawks loudly*",
		SQUAWK0_AUDIO = preload("uid://di41qyopd57jl"),
		SQUAWK1_AUDIO = preload("uid://c5tedx52oalnt"),
		SQUAWK2_AUDIO = preload("uid://710xc7k2sovk"),

		INSULT1 = "*squak* You really are the worst pirate!",
		INSULT1_AUDIO = preload("uid://cug1gqy1cbucp"),
		INSULT2 = "*squak* Give me a cracker! It's all you're good for.",
		INSULT2_AUDIO = preload("uid://clgr5qwdvv2v6"),
		INSULT3 = "*swquak* You'll still be just as ugly after you lift the curse!",
		INSULT3_AUDIO = preload("uid://c3043cbmmjbpy"),

		# NOTE No sound for this one here
		#LOCATION_REPLY_0 = "You'll have to do better than that, its still %s paces away!" %[DISTANCE_DELIMITER],
		LOCATION_REPLY_1 = "*squawk* Wrong spot, dummy! %s paces away!" %[DISTANCE_DELIMITER],
		LOCATION_REPLY_1_AUDIO = preload("uid://cw5qphvx2j7h6"),

		#TIMES_UP = "HAA!  Knew you'd never find it!  Now you're cursed for all time!",
		#TIMES_UP_AUDIO = preload("")
	}
}


static func select_dialogue_audio(type: Globals.DialogueType) -> Array[AudioStreamOggVorbis]:
	var sequence: Array[AudioStreamOggVorbis] = []

	match type:
		Globals.DialogueType.SQUABBLE:
			var insults: Array = []
			var retorts: Array = []
			for key in LINES[Character.PARROT].keys():
				if not key.contains("AUDIO"):
					continue
				if key.contains("INSULT"):
					insults.append(LINES[Character.PARROT][key])
			for key in LINES[Character.PIRATE].keys():
				if key.contains("AUDIO"):
					continue
				if key.contains("THREAT") or key.contains("EXASPERATION"):
					retorts.append(LINES[Character.PIRATE][key])
			sequence.append(insults.pick_random())
			sequence.append(retorts.pick_random())

		Globals.DialogueType.FAILURE:
			var updates: Array = []
			for key in LINES[Character.PARROT].keys():
				if not key.contains("AUDIO"):
					continue
				if key.contains("LOCATION"):
					updates.append(LINES[Character.PARROT][key])
			sequence.append(updates.pick_random())

		Globals.DialogueType.SUCCESS:
			var cheers: Array = []
			for key in LINES[Character.PIRATE].keys():
				if not key.contains("AUDIO"):
					continue
				if key.contains("CHEER"):
					cheers.append(LINES[Character.PIRATE][key])
			sequence.append(cheers.pick_random())

		Globals.DialogueType.SPONTANEOUS:
			var pirate_lines: Array = []
			var parrot_lines: Array = []
			for key in LINES[Character.PIRATE].keys():
				if not key.contains("AUDIO"):
					continue
				if key.contains("GROAN") or key.contains("EXPOSITION"):
					pirate_lines.append(LINES[Character.PIRATE][key])
			for key in LINES[Character.PARROT].keys():
				if not key.contains("AUDIO"):
					continue
				if key.contains("SQUAWK"):
					parrot_lines.append(LINES[Character.PARROT][key])
			sequence.append(pirate_lines.pick_random())
			sequence.append(parrot_lines.pick_random())

		Globals.DialogueType.START:
			sequence.append(LINES[Character.PIRATE]["EXPOSITION_AUDIO"])

	return sequence


static func select_dialogue(type: Globals.DialogueType, distance: String = "-1") -> Array[Dictionary]:
	var sequence: Array[Dictionary] = []

	match type:
		Globals.DialogueType.SQUABBLE:
			var insults: Array = []
			var retorts: Array = []
			for key in LINES[Character.PARROT].keys():
				if key.contains("AUDIO"):
					continue
				if key.contains("INSULT"):
					insults.append(LINES[Character.PARROT][key])
			for key in LINES[Character.PIRATE].keys():
				if key.contains("AUDIO"):
					continue
				if key.contains("THREAT") or key.contains("EXASPERATION"):
					retorts.append(LINES[Character.PIRATE][key])
			sequence.append({GameStage.Actor.PARROT: insults.pick_random()})
			sequence.append({GameStage.Actor.PIRATE: retorts.pick_random()})

		Globals.DialogueType.FAILURE:
			var updates: Array = []
			for key in LINES[Character.PARROT].keys():
				if key.contains("AUDIO"):
					continue
				if key.contains("LOCATION"):
					updates.append(LINES[Character.PARROT][key])
			var update: String = updates.pick_random()
			var beginning_slice: String = update.get_slice(Dialogue.DISTANCE_DELIMITER, 0)
			var ending_slice: String = update.get_slice(Dialogue.DISTANCE_DELIMITER, 1)
			var line_string: String = beginning_slice + distance + ending_slice
			sequence.append({GameStage.Actor.PARROT: line_string})

		Globals.DialogueType.SUCCESS:
			var cheers: Array = []
			for key in LINES[Character.PIRATE].keys():
				if key.contains("AUDIO"):
					continue
				if key.contains("CHEER"):
					cheers.append(LINES[Character.PIRATE][key])
			sequence.append({GameStage.Actor.PIRATE: cheers.pick_random()})

		Globals.DialogueType.SPONTANEOUS:
			var lines: Array = []
			for key in LINES[Character.PIRATE].keys():
				if key.contains("AUDIO"):
					continue
				if key.contains("GROAN") or key.contains("EXPOSITION"):
					lines.append(LINES[Character.PIRATE][key])

			lines.append(LINES[Character.PARROT]["SQUAWK"])
			sequence.append({GameStage.Actor.PIRATE: lines.pick_random()})

		Globals.DialogueType.START:
			sequence.append({GameStage.Actor.PIRATE: LINES[Character.PIRATE]["EXPOSITION"]})

	return sequence
