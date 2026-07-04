extends Node2D

class_name Obstacle

@export var expected_row: int = 4
@export var speed: float = 50.0
@export var is_tutorial: bool = false;

var THRESHOLD = 20 + (28 * 2) + (28 / 2)
var HINTS = [
	[[1, 0], [2, 0], [0, 1, 2, 3, 4], [1, 0, 0]], # row
	
	[[0, 1], [0, 2], [0, 1, 2], [0, 1, PI/2]], # col1
	[[0, -1], [0, -2], [2, 3, 4], [0, -1, PI/2]], # col2
	
	[[1, 1], [2, 2], [0, 1, 2], [1, 1, PI / 4]], # diag1 \
	[[-1, -1], [-2, -2], [2, 3, 4], [-1, -1, PI / 4]], # diag2 \
	
	[[-1, 1], [-2, 2], [0, 1, 2], [-1, 1, -PI / 4]], # diag1 /
	[[1, -1], [2, -2], [2, 3, 4], [1, -1, -PI / 4]], # diag2 /
	
	[[0, -1], [0, 1], [1, 2, 3], [0, 0, PI / 2]], # hole
	
	[[-1, -1], [1, 1], [1, 2, 3], [0, 0, PI / 4]], # diag hole 1 /
	[[-1, 1], [1, -1], [1, 2, 3], [0, 0, -PI / 4]], # diag hole 2 \
]

var TUTORIAL_HINTS = [
	[[0, 1], [0, 2], [], [0, 1, PI/2]],
	[[0, -1], [0, 1], [], [0, 0, PI / 2]],
	[[0, -1], [0, 1], [], [0, 0, PI / 2]],
	[[0, -1], [0, 1], [], [0, 0, PI / 2]],
	[[0, -1], [0, -2], [], [0, -1, PI/2]],
]

var current_hint = 0

func construct_hint(hint):
	var offset = 28
	$Hint1.position = (offset * Vector2(hint[0][0], hint[0][1]))
	$Hint2.position = (offset * Vector2(hint[1][0], hint[1][1]))
	
	var anim = "x" if expected_mark() == Enums.Mark.X else "o"
	$Hint1/Tex.play(anim)
	$Hint2/Tex.play(anim)
	
	if len(hint) > 3:
		$Line.position = Vector2(hint[3][0] * offset, hint[3][1] * offset)
		$Line.rotation = hint[3][2]
	

func expected_mark() -> Enums.Mark:
	if expected_row % 2 == 0: return Enums.Mark.X
	return Enums.Mark.O

func _ready() -> void:
	if is_tutorial:
		speed = 0
	pick_hint()
	move_to_row(expected_row)

func pick_hint():
	if is_tutorial:
		construct_hint(TUTORIAL_HINTS[expected_row])
	else:
		var hint_idx: int = -1  # current_hint
		while hint_idx < 0 or expected_row not in HINTS[hint_idx][2]:
			hint_idx = randi() % len(HINTS)
		construct_hint(HINTS[hint_idx])

func _physics_process(delta: float) -> void:
	position.x -= speed * delta
	
	position.x = max(position.x, THRESHOLD)
	if position.x <= THRESHOLD and speed > 0:
		emit_signal("check_me", self, expected_mark(), expected_row)
		speed = 0
		#queue_free()

func slide_to_left():
	speed = 1200

func fade_out_good():
	$CompletionSound.do_play()
	$Line/AnimatedSprite2D.visible = true
	$Line/AnimatedSprite2D.play()
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(0, 0, 0, 0), 0.2)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_callback(self.queue_free)

func fade_out_bad():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(0, 0, 0, 0), 0.2)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_callback(self.queue_free)

func set_tutorial_row(row: int):
	expected_row = row
	pick_hint()
	move_to_row(row)

func move_to_row(row: int):
	var padding = 20;
	var row_height = 28;
	position.y = padding + (row_height * (row + 1)) - (row_height / 2)

signal check_me(mark: Enums.Mark, row: int)
