extends ProgressBar

var cold_color = Color("#0033FF")
var hot_color = Color("#FF007F") 

var fill_style : StyleBoxFlat

func _ready() -> void:
	fill_style = StyleBoxFlat.new()
	fill_style.corner_radius_top_left = 4
	fill_style.corner_radius_top_right = 4
	fill_style.corner_radius_bottom_left = 4
	fill_style.corner_radius_bottom_right = 4
	
	self.add_theme_stylebox_override("fill", fill_style)

func _process(_delta: float) -> void:
	if Dialogic.has_subsystem("VAR"):
		var current_cold_meter = Dialogic.VAR.get("cold_meter")
		
		if current_cold_meter != null:
			self.value = float(current_cold_meter)
			
			var t = self.value / 100.0
			
			fill_style.bg_color = cold_color.lerp(hot_color, t)
