extends Node2D

var jump_timer: Timer
var current_context: String = ""

func _ready() -> void:
	jump_timer = Timer.new()
	jump_timer.one_shot = true
	jump_timer.timeout.connect(_on_timer_timeout)
	add_child(jump_timer)
	
	Dialogic.signal_event.connect(_on_dialogic_signal)
	
	Dialogic.start("the_jump")

func _on_dialogic_signal(argument: String) -> void:
	
	if argument == "stop_timer":
		jump_timer.stop()
		current_context = ""
		return
		
	if argument.begins_with("start_timer_"):
		current_context = argument.replace("start_timer_", "")
		jump_timer.start(5.0)

func _on_timer_timeout() -> void:
	var random_label: String = ""
	
	match current_context:
		"fire":
			random_label = "timeout_fire" 
		"jacket":
			var variante = ["choice_jacket_on", "choice_jacket_leave"]
			random_label = variante.pick_random()
		"neighbour":
			var variante = ["choice_neighbour_honest", "choice_neighbour_fine", "choice_neighbour_walk"]
			random_label = variante.pick_random()
		"moment":
			var variante = ["choice_moment_feel", "choice_moment_shut"]
			random_label = variante.pick_random()
		"song":
			var variante = ["choice_song_skip", "choice_song_listen"]
			random_label = variante.pick_random()
			
	if random_label != "":
		if Dialogic.has_subsystem("Choices"):
			Dialogic.Choices.hide_all_choices()
		
		Dialogic.Jump.jump_to_label(random_label)
