extends Node2D

var line_scene = preload("res://move_line2d/move_line_2d.tscn")

var mv_ln :Node2D
func _ready() -> void:
	mv_ln = line_scene.instantiate()
	mv_ln.init(200,2)
	add_child(mv_ln)

func _process(delta: float) -> void:
	mv_ln.move(delta)

