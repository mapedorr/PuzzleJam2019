extends TextureProgress

# Declare member variables here. Examples:
export(int, 1, 12) var limit = 1
var v_border_width = 9
var division_size = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	# Place the HSeparator that shows the limit of the tube
	var content_size = self.get_size().x
	division_size = content_size / 12
	$HSeparator.set_position(Vector2(division_size * limit, 0))

func fill(amount):
	var current_value = get_small_value()
	if current_value == limit:
		return amount
	var new_value = min(current_value + amount, limit)
	var diff = amount - (limit - current_value)
	self.tween_value(new_value * 10)
	return diff if diff > 0 else 0

func empty(amount):
	if amount < self.value:
		self.tween_value(amount * 10)
	
func tween_value(new_value):
	$Tween.interpolate_property(
		self,
		"value",
		self.value,
		new_value,
		0.5,
		Tween.TRANS_LINEAR,
		Tween.EASE_OUT
	)
	$Tween.start()

func get_small_value():
	return int(self.get_value() / 10)