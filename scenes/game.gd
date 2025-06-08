extends Node2D

@onready var buttons = $GridContainer.get_children()
@onready var menu = $menu
@onready var label:Label = $menu/resultlabel
@onready var word_label:Label = $menu/resultlabel2
const SIZE = 5

var wordle:String = ""
var index = 0
var latest_row_index = 0
var row_filled = false

# Called when the node enters the scene tree for the first time.
func _ready():
	init_button_styles()
	reset_game()
	
func _input(event):
	
	if menu.visible:
		return
	if event is InputEventKey and event.is_pressed():
		if event.keycode >= KEY_A and event.keycode <= KEY_Z:
			var letter = char(event.keycode)
			print("LETTER: ", letter)
			
			if not row_filled:
				buttons[index].text = letter
				index += 1
				
				if index != 0 and index % 5 == 0:
					row_filled = true
					
	if Input.is_action_pressed("back"):
		if index > 0 and index > latest_row_index:
			index -= 1
			buttons[index].text = ""
			row_filled = false
	if Input.is_action_pressed("enter"):
		if row_filled:
			check_win()
			latest_row_index = index
			row_filled = false



func reset_game():
	index = 0
	row_filled = false
	latest_row_index = 0
	word_label.text = ""
	label.text = ""
	wordle = get_random_wordle()
	print("WORDLE: ",wordle)
	for button in buttons:
		var b = button as Button
		b.text = ""
		
func init_button_styles():
	for button in buttons:
		var b = button as Button
		var style = StyleBoxFlat.new()
		style.bg_color = Color.PALE_VIOLET_RED
		style.border_color = Color.LIGHT_PINK
		style.border_width_bottom = 2
		style.border_width_top = 2
		style.border_width_left = 2
		style.border_width_right = 2
		b.add_theme_stylebox_override("normal", style)
		
func update_button_style(button:Button, bg_color:Color):
	var style = button.get_theme_stylebox("normal")
	style.bg_color = bg_color
	button.add_theme_stylebox_override("normal", style)

func get_random_wordle():
	var file = FileAccess.open("res://wordle-list.txt", FileAccess.READ)
	var content = file.get_as_text(true)
	var lines = content.split("\n")
	randomize()
	var rng = RandomNumberGenerator.new()
	var index = rng.randi_range(0, lines.size()-1)
	return lines[index].to_upper()
	
func check_win():
	var entered_text = ""
	for button in buttons.slice(latest_row_index, latest_row_index+SIZE):
		entered_text += button.text
	print("Entered Text::", entered_text)
	if entered_text == wordle:
		label.text = "YOU WON!"
		word_label.text = "CORRECT WORD: "+ entered_text
		menu.show()
	else:
		var idx = 0
		for button in buttons.slice(latest_row_index, latest_row_index+SIZE):
			if entered_text[idx] == wordle[idx]:
				update_button_style(button, Color.SEA_GREEN)
			elif entered_text[idx] in wordle:
				update_button_style(button, Color.CHOCOLATE)
			elif entered_text[idx] not in wordle:
				update_button_style(button, Color.DARK_RED)
			idx += 1 
	if entered_text == wordle:
		menu.show()
		label.text = "YOU WON!"
		word_label.text = "CORRECT WORD: "+ entered_text
		get_tree().change_scene_to_file("res://scenes/LEVEL2.tscn") 
		
	if index == buttons.size():
		menu.show()
		label.text = "YOU LOST"
		word_label.text = "CORRECT WORD: "+ wordle
		get_tree().change_scene_to_file("res://scenes/game.tscn")
		

func _on_button_pressed():
	menu.hide()
	reset_game()
