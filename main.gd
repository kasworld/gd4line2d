extends Node2D

var line_scene = preload("res://move_line2d/move_line_2d.tscn")

var vp_size :Vector2
var line_list :Array
func _ready() -> void:
	vp_size = get_viewport_rect().size

	var pos_list = make_pos_list()
	var co_list = make_co_list()
	for i in 100:
		var ln = line_scene.instantiate()
		ln.init(pos_list,co_list)
		add_child(ln)
		line_list.append(ln)
	for ln in line_list:
		ln.velocity_list = line_list[0].velocity_list.duplicate()
	for i in line_list.size():
		for j in i:
			line_list[j].move(1.0/30)

func _process(delta: float) -> void:
	for ln in line_list:
		ln.move(delta)

const point_count = 2
func make_pos_list()->Array:
	var pos_list =[]
	for j in point_count:
		pos_list.append(random_pos_vector2d(vp_size))
	return pos_list

func random_pos_vector2d(vt :Vector2)->Vector2:
	return Vector2( randf_range(0,vt.x), randf_range(0,vt.y) )

func make_co_list()->Array:
	var co_list =[]
	for j in point_count:
		co_list.append(random_color())
	return co_list

func random_color()->Color:
	return Color(randf(),randf(),randf())
