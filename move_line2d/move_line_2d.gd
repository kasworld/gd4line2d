extends Node2D

var velocity_list :PackedVector2Array

func init(pos_list :PackedVector2Array, vt_list :PackedVector2Array, co_list :PackedColorArray):
	velocity_list = vt_list
	var gr = Gradient.new()
	gr.colors = co_list
	var offset = PackedFloat32Array()
	$Line2D.points = pos_list
	$Line2D.gradient = gr
	$Line2D.width = 5

func get_points()->PackedVector2Array:
	return $Line2D.points.duplicate()

func get_velocity_list()->PackedVector2Array:
	return velocity_list.duplicate()

var vp_size :Vector2
func _ready() -> void:
	vp_size = get_viewport_rect().size

func set_pos_vel(pos_list :PackedVector2Array, vt_list :PackedVector2Array)->void:
	$Line2D.points = pos_list
	velocity_list = vt_list

func move(delta: float) -> void:
	for i in velocity_list.size():
		$Line2D.points[i] += velocity_list[i] *delta
		var bn = bounce($Line2D.points[i],velocity_list[i],vp_size,$Line2D.width/2)
		$Line2D.points[i] = bn.pos
		velocity_list[i] = bn.vel

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
