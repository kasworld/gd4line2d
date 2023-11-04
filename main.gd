extends Node2D

var line_scene = preload("res://move_line2d/move_line_2d.tscn")

const mv_ln_count = 1
var mv_ln_list :Array
func _ready() -> void:
	var draw_area = get_viewport_rect().size
	for i in mv_ln_count:
		make_mv_ln(draw_area)

func make_mv_ln(draw_area :Vector2):
	var mvln = line_scene.instantiate()
	mvln.init(600,2,draw_area)
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
