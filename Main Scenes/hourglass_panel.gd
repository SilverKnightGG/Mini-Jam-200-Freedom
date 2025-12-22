extends PanelContainer

const FILL_SAND_TIME_OUT_LEVEL: float = 36.0
const FILL_SAND_TIME_START_LEVEL: float = 87.0

const TOP_SAND_TIME_START_LEVEL: float = -8.0
const TOP_SAND_TIME_OUT_LEVEL: float = 33.0

const TIME_DELIMITER: String = ":"


enum DrainingState {DRAINING, PAUSED, READY, FINISHED}


func _on_drain_sand(time: float):
	%TopEffectSand.position.y = lerpf(TOP_SAND_TIME_START_LEVEL, TOP_SAND_TIME_OUT_LEVEL, time / Globals.STAGE_TIME)
	%FillEffectSand.position.y = lerpf(FILL_SAND_TIME_START_LEVEL, FILL_SAND_TIME_OUT_LEVEL, time / Globals.STAGE_TIME)
	if not %SandFalling.visible == true:
		%SandFalling.show()

	var seconds: String = str(floori(Globals.time))
	var hundredths: String = str(Globals.time).get_slice(".", 1).left(2)
	%StageTimeLabel.text = seconds + TIME_DELIMITER + hundredths


func _on_stop_draining_sand():
	%SandFalling.hide()


func _ready():
	if not Globals.timeout.is_connected(_on_drain_sand):
		Globals.timeout.connect(_on_drain_sand)
	if not Globals.paused.is_connected(_on_stop_draining_sand):
		Globals.paused.connect(_on_stop_draining_sand)
