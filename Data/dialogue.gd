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
