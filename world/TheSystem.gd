extends Node2D

var messages = []
var messageIndex = 0
var interacting = false

func _process(_delta):
	if Input.is_action_just_pressed("ui_down"):
		SaverAndLoader.custom_data.boss3_defeated = true

	if Input.is_action_just_pressed("ui_accept") and interacting:
		next_message()

func _on_Trigger_body_entered(_body):
	Events.emit_signal('initiate_npc_interaction')
	interacting = true
	get_messages()
	next_message()
	SaverAndLoader.custom_data.met_the_system = true
	SaverAndLoader.save_custom_data()

func next_message():
	if messageIndex == messages.size():
		Events.emit_signal('end_npc_interaction')
		Events.emit_signal('clear_dialog_message')
		messageIndex = 0
		interacting = false
		after_last_message()
		return

	Events.emit_signal('display_dialog_message', messages[messageIndex])
	messageIndex += 1

func get_messages():
	var bosses_defeated = 0
	if SaverAndLoader.custom_data.boss1_defeated:
		bosses_defeated += 1
	if SaverAndLoader.custom_data.boss2_defeated:
		bosses_defeated += 1
	if SaverAndLoader.custom_data.boss3_defeated:
		bosses_defeated += 1

	if SaverAndLoader.all_bosses_defeated():
		if SaverAndLoader.custom_data.met_the_system:
			messages = [
				"Welcome Back!",
				"Aha! You got the token after all! Great!",
				"Access Granted!"
			]
		else:
			messages = [
				"Hello! Welcome to Brain-Access,\nMy name is Chip!",
				"To utilize the brain-access pathway you need the entire authentication token. Do you have it?",
				"Aha! You DO! Access Granted!"
			]
	else:
		if SaverAndLoader.custom_data.met_the_system:
			messages = [
				"Welcome back little one!",
				"I still cannot grant access without the entire authentication token.\nCome back later!",
			]
		else:
			messages = [
				"Hello! Welcome to Brain-Access,\nMy name is Chip!",
				"Oh, I'm sorry little one, but I cannot grant access without the entire authentication token.",
				"It looks like you have {num} of the 3 token fragments.".format({"num": bosses_defeated}),
				"Have a great day!",
			]

func after_last_message():
	if SaverAndLoader.all_bosses_defeated():
		$AnimationPlayer.play('open')
		$AnimationPlayer2.stop()

func access_granted():
		Events.emit_signal('system_access_granted')
