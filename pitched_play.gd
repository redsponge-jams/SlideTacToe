extends AudioStreamPlayer2D

#var sounds = [
	#preload("res://sketch-move.ogg"),
#]

func do_play():
	self.pitch_scale = randf_range(0.8, 1.2)
	self.play(0)


func _on_player_row_changed(new_row: int) -> void:
	self.do_play()
