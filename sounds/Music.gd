extends Node

export(Array, AudioStream) var list = []

var list_index = 0 setget set_list_index

onready var player = $AudioStreamPlayer
var stopped = true


func play_intro():
	assert(list.size() > 0)
	stopped = false
	self.set_list_index(0) 
	player.stream = list[list_index]
	player.stream.set_loop(false)
	player.play()
	self.set_list_index(1) 
	if list_index == list.size():
		self.set_list_index(0) 

func play_boss_music():
	var cached_index = list_index
	self.set_list_index(2) 
	play_music()
	self.set_list_index(cached_index) 

func play_music():
	stopped = false
	player.stream = list[list_index]
	player.play()

func _on_AudioStreamPlayer_finished():
	if not stopped:
		play_music()

func stop_music():
	stopped = true
	player.stop()


func set_list_index(li):
	list_index = li
	SaverAndLoader.custom_data.music_list_index = li
	SaverAndLoader.save_custom_data()
