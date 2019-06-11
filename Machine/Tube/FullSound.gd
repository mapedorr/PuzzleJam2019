extends AudioStreamPlayer2D

export (Array) var Notes

var value = 0

func update():
	self.stream = Notes[value]

