extends Node

class_name GameManager

@export var player: Player

@export var score = 0
var is_game_running = false

func _on_obstacle_check_me(obstacle: Obstacle, mark: Enums.Mark, row: int) -> void:
	print("Checking if player is", mark, "and", row)
	if not is_game_running:
		start_game()
	
	if player.mark == mark and player.row == row:
		set_score(score + 1)
		obstacle.fade_out_good()
		print("YES!")
	else:
		print("NO!")
		obstacle.fade_out_bad()
		end_game()
#
#func _process(delta: float) -> void:
	#if Input.is_action_just_pressed("ui_right"):
		#is_game_running = not is_game_running
		#if is_game_running:
			#start_game()
		#else:
			#end_game()
		#

func set_score(score: int):
	self.score = score
	score_changed.emit(score)

func start_game():
	score = 0
	is_game_running = true
	game_start.emit()

func end_game():
	is_game_running = false
	game_over.emit()

signal game_start
signal game_over
signal score_changed(new_score: int)
