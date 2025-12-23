extends PanelContainer

const FILL_SAND_TIME_OUT_LEVEL: float = 36.0
const FILL_SAND_TIME_START_LEVEL: float = 87.0

const TOP_SAND_TIME_START_LEVEL: float = -8.0
const TOP_SAND_TIME_OUT_LEVEL: float = 33.0

const TIME_DELIMITER: String = ":"


enum DrainingState {DRAINING, PAUSED, READY, FINISHED}
var draining_state: DrainingState = DrainingState.READY


func _process(_delta):
	if not draining_state == DrainingState.DRAINING:
		return

	prints("draining sand", str(Globals.time / Globals.STAGE_TIME))

	%TopEffectSand.position.y = lerpf(TOP_SAND_TIME_START_LEVEL, TOP_SAND_TIME_OUT_LEVEL,  1.0 - Globals.time / Globals.STAGE_TIME)
	%FillEffectSand.position.y = lerpf(FILL_SAND_TIME_START_LEVEL, FILL_SAND_TIME_OUT_LEVEL, 1.0 - Globals.time / Globals.STAGE_TIME)

	var seconds: String = str(floori(Globals.time))
	var hundredths: String = str(Globals.time).get_slice(".", 1).left(2)
	%StageTimeLabel.text = seconds + TIME_DELIMITER + hundredths


func _on_drain_sand():
	print("told it to drain")
	if not %SandFalling.visible == true:
		%SandFalling.show()
	if not draining_state == DrainingState.DRAINING:
		draining_state = DrainingState.DRAINING


func _on_stop_draining_sand():
	if draining_state == DrainingState.FINISHED:
		return

	%SandFalling.hide()

	if Globals.time_state == Globals.TimeState.FINISHED:
		draining_state = DrainingState.FINISHED
		return

	if not draining_state == DrainingState.PAUSED:
		draining_state = DrainingState.PAUSED


func _ready():
	if not Globals.timeout.is_connected(_on_drain_sand):
		Globals.timeout.connect(_on_drain_sand)# hmmm....  not right
	if not Globals.paused.is_connected(_on_stop_draining_sand):
		Globals.paused.connect(_on_stop_draining_sand)
