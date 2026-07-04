extends Node2D

@export var shownPosition: Vector2
@export var hiddenPosition: Vector2
@export var tweenSpeed: float = 0.5

func animate_in():
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_CIRC)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "position", shownPosition, tweenSpeed)

func animate_out():
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_CIRC)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "position", hiddenPosition, tweenSpeed)


func _on_game_manager_game_start() -> void:
	animate_out()

func _on_game_manager_game_over() -> void:
	animate_in()
