extends Node

var sounds_path = "res://sounds/"
var sounds = {
	"Gate": load(sounds_path + "zap.ogg"),
	"Laser": load(sounds_path + "zap1.ogg"),
	"Laser2": load(sounds_path + "zap2.ogg"),
	"Jump": load(sounds_path + "joop.ogg"),
	"Hit": load(sounds_path + "hit.ogg"),
	"Hit2": load(sounds_path + "hit2.ogg"),
	"Hit3": load(sounds_path + "hit3.ogg"),
	"EnemyHit": load(sounds_path + "Hit_Hurt.ogg"),
	"EnemyDie": load(sounds_path + "Explosion2.ogg"),
	"Walk": load(sounds_path + "clickclick.ogg"),
	"Buzz": load(sounds_path + "buzz.ogg"),
	"Riser": load(sounds_path + "riser.ogg"),
	"Powerup": load(sounds_path + "powerup2.ogg"),
	"Powerup2": load(sounds_path + "powerup2.ogg"),
	"GlitchEnd": load(sounds_path + "endglitch.ogg"),
}
onready var SoundPlayers = get_children()

func play(sound_string, pitch_scale = 1, volume_db = -10):
	for p in SoundPlayers:
		if not p.playing:
			p.stream = sounds[sound_string]
			p.stream.set_loop(false)
			p.volume_db = volume_db
			p.pitch_scale = pitch_scale
			p.play()
			return
	print('SOUND OVERFLOW')

func playLaserSound():
	var lasers = ["Laser", "Laser2"]
	lasers.shuffle()
	play(lasers[0], rand_range(.8, 1.2), -8)
