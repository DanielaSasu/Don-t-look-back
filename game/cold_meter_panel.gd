extends PanelContainer

var cold_color = Color("#00bbff") 
var hot_color = Color("#ff007f") 

var is_expanded: bool = true
var current_value: int = 0
var previous_value: int = 0

var fill_style: StyleBoxFlat

@onready var collapsed_level = %CollapsedLevel
@onready var toggle_button = %ToggleButton
@onready var expanded_content = %ExpandedContent
@onready var expanded_level = %ExpandedLevel
@onready var change_label = %ChangeLabel
@onready var meter_bar = %MeterBar
@onready var message_label = %MessageLabel

var messages = {
	0: "I feel nothing. I think I prefer it this way. That's the problem.",
	5: "I've stopped crying. I don't think that means I'm better.",
	10: "I'm very good at being alone. Maybe too good.",
	15: "I keep cancelling plans. It's easier than explaining myself.",
	20: "I'm not sad. I'm just not anything. Is that worse?",
	25: "I'm going numb. I should probably feel something about that.",
	30: "I'm shutting down again. I recognise this. It's not safe either.",
	35: "I'm cold. I'm clear. But I'm also disappearing.",
	40: "I'm here. Just here. That's enough for now.",
	45: "I'm not okay but I'm not lost either. I'm somewhere in between.",
	50: "I feel everything today. I'm letting myself.",
	55: "This is uncomfortable. I think that means it's working.",
	60: "I'm getting too comfortable here. Something will push me soon.",
	65: "I'm getting too attached again.",
	70: "I know this feeling. I know exactly where it leads.",
	75: "I'm not choosing him. I'm just not choosing myself.",
	80: "I told myself never again. I'm watching myself do it anyway.",
	85: "I looked back. I knew I wasn't supposed to. I did it anyway.",
	90: "I'm following him into the dark and calling it love.",
	95: "I have been here before. It didn't end well. I'm here again.",
	100: "I am not in love. I am on fire. There is a difference. I keep forgetting."
}

func _ready() -> void:
	fill_style = StyleBoxFlat.new()
	fill_style.corner_radius_top_left = 4
	fill_style.corner_radius_top_right = 4
	fill_style.corner_radius_bottom_left = 4
	fill_style.corner_radius_bottom_right = 4
	meter_bar.add_theme_stylebox_override("fill", fill_style)
	
	toggle_button.pressed.connect(_on_toggle_button_pressed)
	
	_update_ui_state()

func _process(_delta: float) -> void:
	
	if Dialogic.has_subsystem("VAR"):
		var dialogic_value = Dialogic.VAR.get("cold_meter")
		
		if dialogic_value != null:
			var new_val = int(dialogic_value)
			
			if new_val != current_value:
				previous_value = current_value
				current_value = clamp(new_val, 0, 100)
				_update_values()

func _update_values() -> void:
	var level_text = "Level: %d°" % current_value
	collapsed_level.text = level_text
	expanded_level.text = level_text
	
	var diff = current_value - previous_value
	if diff > 0:
		change_label.text = "+%d°" % diff
		change_label.add_theme_color_override("font_color", hot_color)
	elif diff < 0:
		change_label.text = "%d°" % diff
		change_label.add_theme_color_override("font_color", cold_color)
	else:
		change_label.text = ""
	
	meter_bar.value = current_value
	var t = float(current_value) / 100.0
	fill_style.bg_color = cold_color.lerp(hot_color, t)
	
	var snapped_value = int(floor(current_value / 5.0) * 5)
	if messages.has(snapped_value):
		message_label.text = messages[snapped_value]

func _on_toggle_button_pressed() -> void:
	is_expanded = !is_expanded
	_update_ui_state()

func _update_ui_state() -> void:
	if is_expanded:
		expanded_content.show()
		collapsed_level.hide()
		toggle_button.icon = load("res://Assets/arrow_up.png")
	else:
		expanded_content.hide()
		collapsed_level.show()
		toggle_button.icon = load("res://Assets/arrow_down.png")
		self.size.y = 0
