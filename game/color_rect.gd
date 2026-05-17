extends ColorRect

func _process(_delta: float) -> void:
	if Dialogic.has_subsystem("VAR"):
		var current_cold_meter = Dialogic.VAR.get("cold_meter")
		if current_cold_meter != null:
			material.set_shader_parameter("cold_meter", current_cold_meter)
