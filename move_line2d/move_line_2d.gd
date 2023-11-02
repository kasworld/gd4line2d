extends Node2D

var velocity_list :PackedVector2Array

func init(pos_list:PackedVector2Array, co_list :PackedColorArray):
	var gr = Gradient.new()
	gr.colors = co_list
	var offset = PackedFloat32Array()
	$Line2D.points = pos_list
	$Line2D.gradient = gr
	$Line2D.width = 5

var vp_size :Vector2
func _ready() -> void:
	vp_size = get_viewport_rect().size
	velocity_list = []
	for i in  $Line2D.points.size():
		velocity_list.append(random_vel_vector2d(vp_size))

func move(delta: float) -> void:
	for i in velocity_list.size():
		$Line2D.points[i] += velocity_list[i] *delta
		var bn = bounce($Line2D.points[i],velocity_list[i],vp_size,$Line2D.width/2)
		$Line2D.points[i] = bn.pos
		velocity_list[i] = bn.vel
#		if bn.xbounce != 0 :
#			velocity_list[i].x = -random_positive(vp_size.x/2)*bn.xbounce
#		if bn.ybounce != 0 :
#			velocity_list[i].y = -random_positive(vp_size.y/2)*bn.ybounce

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
