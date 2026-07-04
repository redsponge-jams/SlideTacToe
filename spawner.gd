extends Node

var obstacle_scene: PackedScene = preload("res://obstacle.tscn")
@export var obstacle_holder: Node
@export var game_manager: GameManager
@export var player: Player

func _ready() -> void:
	spawn_tutorial_obstacle()
	$SpawnTimer.stop()

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_left"):
		slide_leftmost_obstacle()
	
	if len(obstacle_holder.get_children()) == 0:
		spawn_obstacle()
		$SpawnTimer.start(0)
	
func spawn_tutorial_obstacle():
	var obstacle: Obstacle = obstacle_scene.instantiate()
	obstacle.is_tutorial = true
	obstacle.expected_row = player.row
	obstacle.position.x = 320 - 20 - (28 / 2)
	obstacle.check_me.connect(game_manager._on_obstacle_check_me)
	player.row_changed.connect(obstacle.set_tutorial_row)
	obstacle_holder.add_child(obstacle)

func spawn_obstacle():
	var obstacle: Obstacle = obstacle_scene.instantiate()
	obstacle.expected_row = randi_range(0, 4)
	while obstacle.expected_row == player.row:
		obstacle.expected_row = randi_range(0, 4)
	obstacle.position.x = 320 + (28 * 2)
	obstacle.speed += game_manager.score * 2
	obstacle.check_me.connect(game_manager._on_obstacle_check_me)
	obstacle_holder.add_child(obstacle)

func slide_leftmost_obstacle():
	var leftmost = null
	for child in obstacle_holder.get_children():
		if leftmost == null:
			leftmost = child
		elif child.position.x < leftmost.position.x:
			leftmost = child
	if leftmost != null:
		leftmost.slide_to_left()


func _on_spawn_timer_timeout() -> void:
	pass
	# spawn_obstacle()


func _on_game_manager_game_start() -> void:
	spawn_obstacle()
	$SpawnTimer.start(0)


func _on_game_manager_game_over() -> void:
	$SpawnTimer.stop()
	for child in obstacle_holder.get_children():
		child.queue_free()
	spawn_tutorial_obstacle()
