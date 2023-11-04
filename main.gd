extends Node2D

var line_scene = preload("res://move_line2d/move_line_2d.tscn")

const mv_ln_count = 4
var mv_ln_list :Array
func _ready() -> void:
	var draw_area = get_viewport_rect().size
	for i in mv_ln_count:
		make_mv_ln(600,2,draw_area/2)
	mv_ln_list[1].position.x = draw_area.x/2
	mv_ln_list[2].position.y = draw_area.y/2
	mv_ln_list[3].position.x = draw_area.x/2
	mv_ln_list[3].position.y = draw_area.y/2


func make_mv_ln(line_count :int, point_count:int, draw_area :Vector2):
	var mvln = line_scene.instantiate()
	mvln.init(line_count,point_count,draw_area)
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
