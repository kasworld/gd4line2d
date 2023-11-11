extends Node2D

var line_scene = preload("res://move_line2d/move_line_2d.tscn")

var mv_ln_count :int
var mv_ln_list :Array
var mv_ln_pos_list :Array
var draw_area :Rect2
var half_size :Vector2

func make_4()->void:
	mv_ln_count = 4
	mv_ln_pos_list.append(Vector2(draw_area.position.x+half_size.x*0.5, draw_area.position.y+half_size.y*0.5))
	mv_ln_pos_list.append(Vector2(draw_area.position.x+half_size.x*1.5, draw_area.position.y+half_size.y*0.5))
	mv_ln_pos_list.append(Vector2(draw_area.position.x+half_size.x*1.5, draw_area.position.y+half_size.y*1.5))
	mv_ln_pos_list.append(Vector2(draw_area.position.x+half_size.x*0.5, draw_area.position.y+half_size.y*1.5))
	for i in mv_ln_count:
		make_mv_ln(600,2,Rect2(draw_area.position-half_size/2, half_size))
		mv_ln_list[i].position = mv_ln_pos_list[i]
	$AniMove.start(3)

func make_1()->void:
	mv_ln_count = 1
	make_mv_ln(600,2,Rect2(draw_area.position-half_size, draw_area.size))
	mv_ln_pos_list.append(draw_area.get_center())
	mv_ln_list[0].position = mv_ln_pos_list[0]

func _ready() -> void:
	draw_area = get_viewport_rect()
	half_size = draw_area.get_center()
#	make_1()
	make_4()

	var msgrect = Rect2( draw_area.size.x * 0.2 ,draw_area.size.y * 0.4 , draw_area.size.x * 0.6 , draw_area.size.y * 0.2   )
	$TimedMessage.init(msgrect, tr("gd4line2d 2.0"))
	$TimedMessage.show_message("시작합니다.")


func make_mv_ln(line_count :int, point_count:int, draw_area :Rect2):
	var mvln = line_scene.instantiate()
	mvln.init(line_count,point_count,draw_area)
	add_child(mvln)
	mv_ln_list.append(mvln)

func _process(_delta: float) -> void:
	animove_step()
	for o in mv_ln_list:
		o.move(1.0/60.0)
#		o.position = draw_area.get_center()
#		o.rotation = o.get_line_angle()
#		o.position = -o.get_line_center() + draw_area.get_center()

# esc to exit
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			get_tree().quit()
		elif event.keycode == KEY_SPACE:
			animove_toggle()

func reset_pos()->void:
	for i in mv_ln_count:
		mv_ln_list[i].position = mv_ln_pos_list[i]
	$AniMove.stop()

func animove_toggle()->void:
	$AniMove.toggle()
	if not $AniMove.enabled:
		reset_pos()

func animove_step():
	if not $AniMove.enabled:
		return
	var ms = $AniMove.get_ms()
	for i in mv_ln_count:
		var old = ($AniMove.state + i) % mv_ln_count
		var new = ($AniMove.state + i+1) % mv_ln_count
		$AniMove.move_by_ms(mv_ln_list[i], mv_ln_pos_list[old], mv_ln_pos_list[new], ms)
