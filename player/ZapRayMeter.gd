extends ColorRect


func _ready():
	Events.connect("zap_ray_cooldown_update", self, "cooldown_update")
	Events.connect("select_weapon", self, "on_select_weapon")
	visible = false


func cooldown_update(percentage, can_fire, is_firing):
	if is_firing:
		visible = true
		$Timer.stop()

	rect_scale = Vector2(1, percentage)

	if can_fire:
		color = Color(1, 1, 1, 1)
	else:
		color = Color(1, 0, 0, 1)

	if $Timer.is_stopped() and percentage >= .99 and not is_firing:
		$Timer.start()

func _on_Timer_timeout():
	visible = false
