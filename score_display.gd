extends Label

func _on_game_mgr_score_changed(new_score: int) -> void:
	self.text = " {0}".format([new_score])
