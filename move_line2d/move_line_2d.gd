extends Node2D

var velocity_list :PackedVector2Array
var line_list :Array
var line_cursor :int
var line_count :int
var draw_area :Vector2
var point_count :int
var gradiant :Gradient
const line_width = 1.5

func init(ln_count :int, pt_count :int, area_size :Vector2 ):
	line_count = ln_count
	point_count = pt_count
	draw_area = area_size

func _ready() -> void:
	velocity_list = make_vel_list(point_count, draw_area)
	gradiant = new_gradiant()
	var pos_list = make_pos_list(point_count, draw_area)
	for i in line_count:
		var ln = new_line(pos_list)
		add_child(ln)
		line_list.append(ln)

func new_line(pos_list :PackedVector2Array)->Line2D:
	var ln = Line2D.new()
	ln.points = pos_list
	ln.gradient = gradiant
	ln.width = line_width
	return ln

func new_gradiant()->Gradient:
	var co_list = make_co_list(point_count)
	var gr = Gradient.new()
	gr.colors = co_list
	return gr

func move(delta :float)->void:
	var old_line = line_list[line_cursor%line_count]
	line_cursor +=1
	line_list[line_cursor%line_count].points = old_line.points.duplicate()
	move_line(delta, line_list[line_cursor%line_count])

func move_line(delta: float, ln :Line2D) -> void:
	var bounced = false
	for i in velocity_list.size():
		ln.points[i] += velocity_list[i] *delta
		var bn = bounce(ln.points[i],velocity_list[i],draw_area,ln.width/2)
		ln.points[i] = bn.pos
		velocity_list[i] = bn.vel

		# change vel on bounce
		if bn.xbounce != 0 :
			velocity_list[i].x = -random_positive(draw_area.x/2)*bn.xbounce
			bounced = true
		if bn.ybounce != 0 :
			velocity_list[i].y = -random_positive(draw_area.y/2)*bn.ybounce
			bounced = true
	if bounced :
		gradiant = new_gradiant()
	ln.gradient = gradiant

# util functions

func bounce(pos :Vector2,vel :Vector2, bound :Vector2, radius :float)->Dictionary:
	var xbounce = 0
	var ybounce = 0
	if pos.x < radius :
		pos.x = radius
		vel.x = abs(vel.x)
		xbounce = -1
	elif pos.x > bound.x - radius:
		pos.x = bound.x - radius
		vel.x = -abs(vel.x)
		xbounce = 1
	if pos.y < radius :
		pos.y = radius
		vel.y = abs(vel.y)
		ybounce = -1
	elif pos.y > bound.y - radius:
		pos.y = bound.y - radius
		vel.y = -abs(vel.y)
		ybounce = 1
	return {
		pos = pos,
		vel = vel,
		xbounce = xbounce,
		ybounce = ybounce,
	}

func make_pos_list(count :int, vt :Vector2)->PackedVector2Array:
	var rtn = []
	for j in count:
		rtn.append(random_pos_vector2d(vt))
	return rtn

func random_pos_vector2d(vt :Vector2)->Vector2:
	return Vector2( randf_range(0,vt.x), randf_range(0,vt.y) )

func make_vel_list(count :int, vt :Vector2)->PackedVector2Array:
	var rtn = []
	for i in  count:
		rtn.append(random_vel_vector2d(vt))
	return rtn

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

func make_co_list(count :int)->PackedColorArray:
	var rtn = []
	for j in count:
		rtn.append(random_color())
	return rtn

func random_color()->Color:
	return Color(randf(),randf(),randf())
