extends Control

export(int, 0, 12) var tube1_value = 0
export(int, 0, 12) var tube2_value = 0
export(int, 0, 12) var tube3_value = 0
export(int, 0, 12) var goal = 1
var in_space_red = null
var in_space_blue = null
var in_space_fill = null
var space_red_pos = Vector2.ONE
var space_blue_pos = Vector2.ONE

# Called when the node enters the scene tree for the first time.
func _ready():
	# Setup initial vars
	in_space_fill = $Tube
	in_space_red = $Tube2
	in_space_blue = $Tube3
	space_red_pos = in_space_red.get_position()
	space_blue_pos = in_space_blue.get_position()
	# Setup listeners
	$Fill.connect("pressed", self, "fill_pressed")
	$ChangeRed.connect("pressed", self, "change_red")
	$ChangeBlue.connect("pressed", self, "change_blue")
	# Fill tubes
	in_space_fill.value = tube1_value * 10
	in_space_red.value = tube2_value * 10
	in_space_blue.value = tube3_value * 10
	# Place the GOAL line
	$WineLine.set_position(Vector2(
		$WineLine.get_position().x,
		$WineLine.get_position().y - (in_space_fill.division_size * goal)
	))

func fill_pressed():
	# Check how much liquid can be put on the tube in the fill space
	if in_space_red.value != 0:
		var amount = in_space_red.value / 10
		# print("Llenar con: %d" % amount)
		var remainder = in_space_fill.fill(amount)
		# print("Sobró: %d" % remainder)
		in_space_red.empty(remainder)
		# Check the win condition
		yield(get_tree().create_timer(0.6), "timeout")
		if in_space_fill.get_small_value() == self.goal:
			$UI/Container.show()
			$UI/UIAnimations.stop()
			$UI/UIAnimations.play("ShowMessage")

func change_red():
	# Move back the tube in space red
	self.send_back(in_space_fill)
	yield(get_tree().create_timer(0.6), "timeout")
	move_child(in_space_fill, 1)
	self.swap(in_space_red, in_space_fill)
	yield(get_tree().create_timer(0.6), "timeout")
	var prev_fill = in_space_fill
	in_space_fill = in_space_red
	in_space_red = prev_fill
	self.send_back(in_space_red, false)

func change_blue():
	# Move back the tube in space red
	self.send_back(in_space_red)
	yield(get_tree().create_timer(0.6), "timeout")
	move_child(in_space_red, 1)
	self.swap(in_space_blue, in_space_red)
	yield(get_tree().create_timer(0.6), "timeout")
	var prev_red = in_space_red
	in_space_red = in_space_blue
	in_space_blue = prev_red
	self.send_back(in_space_blue, false)

func send_back(tube, to_back = true):
	var target_scale = Vector2.ONE if not to_back else Vector2.ONE * 0.9
	var target_color = Color.white if not to_back else Color(1, 1, 1, 0.8)
	$Tween.interpolate_property(
		tube,
		"rect_scale",
		tube.get_scale(),
		target_scale,
		0.5,
		Tween.TRANS_ELASTIC,
		Tween.EASE_OUT
	)
#	$Tween.interpolate_property(
#		tube,
#		"self_modulate",
#		tube.get_self_modulate(),
#		target_color,
#		0.5,
#		Tween.TRANS_ELASTIC,
#		Tween.EASE_OUT
#	)
	$Tween.start()

func swap(right_tube, left_tube):
	$Tween.interpolate_property(
		right_tube,
		"rect_position",
		right_tube.get_position(),
		left_tube.get_position(),
		0.5,
		Tween.TRANS_SINE,
		Tween.EASE_OUT
	)
	$Tween.interpolate_property(
		left_tube,
		"rect_position",
		left_tube.get_position(),
		right_tube.get_position(),
		0.3,
		Tween.TRANS_SINE,
		Tween.EASE_OUT
	)
	$Tween.start()
