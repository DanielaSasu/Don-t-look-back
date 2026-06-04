extends Node2D

var jump_timer: Timer
var current_context: String = ""

@onready var timer_bar = %TimerBar

func _ready() -> void:
	timer_bar.hide()
	
	jump_timer = Timer.new()
	jump_timer.one_shot = true
	jump_timer.timeout.connect(_on_timer_timeout)
	add_child(jump_timer)
	
	Dialogic.signal_event.connect(_on_dialogic_signal)
	
	Dialogic.start("the_jump")

func _process(delta: float) -> void:
	if not jump_timer.is_stopped():
		timer_bar.value = jump_timer.time_left

func _on_dialogic_signal(argument: String) -> void:
	
	if argument == "stop_timer":
		jump_timer.stop()
		current_context = ""
		timer_bar.hide()
		return
		
	if argument.begins_with("start_timer_"):
		current_context = argument.replace("start_timer_", "")
		
		jump_timer.wait_time = 5.0
		jump_timer.start()
		
		timer_bar.max_value = 5.0
		timer_bar.value = 5.0
		timer_bar.show()

func _on_timer_timeout() -> void:
	timer_bar.hide()
	
	var random_label: String = ""
	
	match current_context:
		"fire":
			random_label = "panic_paralysis" 
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
		
		Dialogic.handle_next_event()
