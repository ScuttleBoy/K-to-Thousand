extends Node2D

@onready var label: Label = %Label
@onready var line_edit: LineEdit = %LineEdit
@onready var refresh_timer: Timer = $RefreshTimer
@onready var tree: Tree = %Tree

var our_text: String
var multiplier: int = 1
var to_change
var counter: int = 0
var in_loop: String
var changed


func _ready() -> void:
	refresh_timer.timeout.connect(on_refresh_timeout)
	var root = tree.create_item()
	tree.hide_root = true
	tree.set_column_title(0, "History")


func _on_line_edit_text_submitted(new_text: String) -> void:
	if new_text.is_empty():
		return
	
	if new_text.length() > 18:
		label.text = "Too long!"
		reset()
		return
	
	if new_text.to_lower().ends_with("k"):
		for ch in new_text.to_lower():
			if ch == "k":
				multiplier *= 1000
		our_text = new_text.to_lower().replacen("k","")
	else:
		our_text = new_text
	
	if our_text.is_valid_int():
		to_change = our_text.to_int()
		to_change = to_change * multiplier
		
		changed = beautify_number(to_change)
	elif our_text.is_valid_float():
		to_change = our_text.to_float()
		to_change = to_change * multiplier
		
		changed = beautify_number(to_change)
	else:
		label.text = "Huh..? That's not a number!"
		reset()
		return
	
	finish(changed)


func reset():
	our_text = ""
	to_change = 0
	counter = 0
	in_loop = ""
	changed = ""
	multiplier = 1
	line_edit.clear()
	refresh_timer.start()


func finish(final_text: String):
	label.text = "That number is... " + final_text
	
	var child = tree.create_item()
	child.set_text(0, final_text)
	
	reset()


func on_refresh_timeout():
	label.text = "That number is... "


func beautify_number(to_count: float):
	var counted = str(to_count).pad_decimals(0)
	
	for digit in counted.reverse():
		if counter % 3 == 0:
			in_loop += ","
		in_loop += digit
		counter += 1
	
	var post_loop = in_loop.reverse()
	
	if post_loop.ends_with(","):
		post_loop = post_loop.rstrip(",")
	
	return post_loop
