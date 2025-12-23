class_name Dialogue extends Node

const DISTANCE_DELIMITER: String = "^"


enum Character {PIRATE, PARROT}

static var LINES = {
	Character.PIRATE: {
		GROAN = "*groans* Where be that blasted treasure?!",
		CHEER1 = "Yar-har! I founds it!",
		CHEER2 = "The chest! Me curse be lifted!",
		THREAT1 = "Shut up, Polly! Yer lucky I don't boil ye in a stew!",
		THREAT2 = "I'm gonna pluck all yer feathers if ye say that again!",
		EXASPERATION = "Stupid bird...",
		EXPOSITION = "I needs to find that chest, or I'll stay cursed forever!",
		TIMES_UP = "Oh... Oh no... I be cursed forever-more!  NOOO!"
	},
	Character.PARROT: {
		SQUAWK = "*squawks loudly",
		INSULT1 = "*squak* You really are the worst pirate!",
		INSULT2 = "*squak* Give me a cracker! It's all you're good for.",
		INSULT3 = "*swquak* You'll still be just as ugly after you lift the curse!",
		LOCATION_REPLY_0 = "You'll have to do better than that, its still %s paces away!" %[DISTANCE_DELIMITER],
		LOCATION_REPLY_1 = "*squawk* Wrong spot, dummy! %s paces away!" %[DISTANCE_DELIMITER]
	}
}


static func select_dialogue(type: Globals.DialogueType, distance: int = -1) -> Array[Dictionary]:
	var sequence: Array[Dictionary] = []

	match type:
		Globals.DialogueType.SQUABBLE:
			var insults: Array = []
			var retorts: Array = []
			for key in LINES[Character.PARROT].keys():
				if key.contains("INSULT"):
					insults.append(LINES[Character.PARROT][key])
			for key in LINES[Character.PIRATE].keys():
				if key.contains("THREAT") or key.contains("EXASPERATION"):
					retorts.append(LINES[Character.PIRATE][key])
			sequence.append({GameStage.Actor.PARROT: insults.pick_random()})
			sequence.append({GameStage.Actor.PIRATE: retorts.pick_random()})

		Globals.DialogueType.FAILURE:
			var updates: Array = []
			for key in LINES[Character.PARROT].keys():
				if key.contains("LOCATION"):
					updates.append(LINES[Character.PARROT][key])
			var update: String = updates.pick_random()
			var beginning_slice: String = update.get_slice(Dialogue.DISTANCE_DELIMITER, 0)
			var ending_slice: String = update.get_slice(Dialogue.DISTANCE_DELIMITER, 1)
			var line_string: String = beginning_slice + str(distance) + ending_slice
			sequence.append({GameStage.Actor.PARROT: line_string})

		Globals.DialogueType.SUCCESS:
			var cheers: Array = []
			for key in LINES[Character.PIRATE].keys():
				if key.contains("CHEER"):
					cheers.append(LINES[Character.PIRATE][key])
			sequence.append({GameStage.Actor.PIRATE: cheers.pick_random()})

		Globals.DialogueType.SPONTANEOUS:
			var lines: Array = []
			for key in LINES[Character.PIRATE].keys():
				if key.contains("GROAN") or key.contains("EXPOSITION"):
					lines.append(LINES[Character.PIRATE][key])
			lines.append(LINES[Character.PARROT]["SQUAWK"])
			sequence.append({GameStage.Actor.PIRATE: lines.pick_random()})

		Globals.DialogueType.GAME_OVER:
			sequence.append({GameStage.Actor.PIRATE: LINES[Character.PIRATE]["TIMES_UP"]})

		Globals.DialogueType.START:
			sequence.append({GameStage.Actor.PIRATE: LINES[Character.PIRATE]["EXPOSITION"]})

	return sequence
