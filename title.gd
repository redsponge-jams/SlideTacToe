extends Node2D

@export var titlePosition: Vector2

func animate_in():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", titlePosition, 0.1)
	tween.set_ease(Tween.EASE_IN_OUT)

func animate_out():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", titlePosition + Vector2.UP * 50, 0.1)
	tween.set_ease(Tween.EASE_IN_OUT)


func _on_game_manager_game_start() -> void:
	animate_out()

func _on_game_manager_game_over() -> void:
	animate_in()
