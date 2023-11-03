extends Node2D

var line_scene = preload("res://move_line2d/move_line_2d.tscn")

var vp_size :Vector2
var line_list :Array
var line_cursor :int
const line_count = 100
func _ready() -> void:
	vp_size = get_viewport_rect().size

	var pos_list = make_pos_list()
	var co_list = make_co_list()
	var vel_list = make_vel_list()
	for i in line_count:
		var ln = line_scene.instantiate()
		ln.init(pos_list,vel_list, co_list)
		add_child(ln)
		line_list.append(ln)

func _process(delta: float) -> void:
	var old_line = line_list[line_cursor%line_count]
	line_cursor +=1
	line_list[line_cursor%line_count].set_pos_vel(old_line.get_points(), old_line.get_velocity_list())
	line_list[line_cursor%line_count].move(delta)

const point_count = 2
func make_pos_list()->PackedVector2Array:
	var pos_list =[]
	for j in point_count:
		pos_list.append(random_pos_vector2d(vp_size))
	return pos_list

func random_pos_vector2d(vt :Vector2)->Vector2:
	return Vector2( randf_range(0,vt.x), randf_range(0,vt.y) )

func make_vel_list()->PackedVector2Array:
	var velocity_list = []
	for i in  point_count:
		velocity_list.append(random_vel_vector2d(vp_size))
	return velocity_list

func random_vel_vector2d(vt :Vector2)->Vector2:
	return Vector2(random_no_zero(vt.x),random_no_zero(vt.y))

func random_no_zero(w :float)->float:
	var v = random_positive(w/2)
	match randi_range(1,2):
		1:
			pass
		2:
			v = -v
	return v

func random_positive(w :float)->float:
	return randf_range(w/10,w)

func make_co_list()->PackedColorArray:
	var co_list =[]
	for j in point_count:
		co_list.append(random_color())
	return co_list

func random_color()->Color:
	return Color(randf(),randf(),randf())
