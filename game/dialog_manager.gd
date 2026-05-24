extends Node2D

@onready var choice_timer = $ChoiceTimer
@onready var timer_bar = %TimerBar

func _ready():
	# Hide the bar when the game starts
	timer_bar.hide() 
	
	Dialogic.signal_event.connect(_on_dialogic_signal)
	choice_timer.timeout.connect(_on_timer_timeout)
	Dialogic.start("the_jump")

# This function runs every single frame
func _process(delta):
	# If the timer is actively running, update the bar's visual progress
	if not choice_timer.is_stopped():
		timer_bar.value = choice_timer.time_left

func _on_dialogic_signal(argument: String):
	if argument == "start_fire_timer":
		choice_timer.wait_time = 5.0
		
		# Configure and show the visual bar
		timer_bar.max_value = 5.0
		timer_bar.value = 5.0
		timer_bar.show() 
		
		choice_timer.start()
		print("Timer started! Player has 5 seconds.")
	
	elif argument == "stop_timer":
		choice_timer.stop()
		# Hide the bar because the player made a choice
		timer_bar.hide() 
		print("Timer stopped! Player made a choice.")

func _on_timer_timeout():
	print("Time expired! Forcing the panic state.")
	
	# Hide the visual bar since time is up
	timer_bar.hide()
	
	# 1. Hides the choice buttons
	Dialogic.Choices.hide_all_choices()
	
	# 2. Tells the current timeline to jump to the label
	Dialogic.Jump.jump_to_label("panic_paralysis")
	
	# 3. Forces the Dialogic engine to continue playing
	Dialogic.handle_next_event()
