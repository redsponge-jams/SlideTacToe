extends Node2D

class_name Player

@export var mark: Enums.Mark = Enums.Mark.X
@export var row: int = 0

func other(mark: Enums.Mark) -> Enums.Mark:
	if mark == Enums.Mark.X:
		return Enums.Mark.O
	else:
		return Enums.Mark.X

func _ready() -> void:
	change_row(row)

func _process(delta: float) -> void:
	var moved: bool = false
	if Input.is_action_just_pressed("ui_up"):
		change_row(row - 1)
		moved = true
	elif Input.is_action_just_pressed("ui_down"):
		change_row(row + 1)
		moved = true
		

func change_row(row: int):
	row = clampi(row, 0, 4)
	if row == self.row:
		return
	
	self.row = row
	
	self.mark = determine_mark_from_row(row)
	make_texture_reflect_mark(mark)
	move_to_row(row)
	row_changed.emit(row)

func determine_mark_from_row(row: int) -> Enums.Mark:
	if row % 2 == 0: return Enums.Mark.X
	else: return Enums.Mark.O

func make_texture_reflect_mark(mark: Enums.Mark):
	var anim = "o_to_x" if mark == Enums.Mark.X else "x_to_o"
	$Animation.play(anim)
	

func move_to_row(row: int):
	var padding = 20;
	var row_height = 28;
	var tween = get_tree().create_tween()
	var new_y = padding + (row_height * (row + 1)) - (row_height / 2)
	tween.set_trans(Tween.TRANS_CIRC)
	tween.tween_property(self, "position", Vector2(position.x, new_y), 0.2)

signal row_changed(new_row: int)
