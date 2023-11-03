extends Node2D

var line_scene = preload("res://move_line2d/move_line_2d.tscn")

const mv_ln_count = 1
var mv_ln_list :Array
func _ready() -> void:
	for i in mv_ln_count:
		make_mv_ln()

func make_mv_ln():
	var mvln = line_scene.instantiate()
	mvln.init(200,2)
	add_child(mvln)
	mv_ln_list.append(mvln)

func _process(_delta: float) -> void:
	for o in mv_ln_list:
		o.move(1.0/60.0)

# esc to exit
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			get_tree().quit()
