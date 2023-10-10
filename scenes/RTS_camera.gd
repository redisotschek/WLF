extends Camera3D

var radius = 10
var position_angle = 0
var position_step = 45
var speed = 2.0
var height = 5
@onready var unit_pos = get_tree().get_first_node_in_group("Units").position
var POSITIONS = [0, 45, 90, 180]
var curr_position_index = 0
var is_moving = false

func _ready():
	get_camera_position(POSITIONS[curr_position_index])
	
func _process(delta):
	look_at(unit_pos)
	
func slide_camera(direction: bool):
	print(direction)
	var new_index
	if direction:
		new_index = curr_position_index + 1
	else: new_index = curr_position_index - 1
	if new_index < 0:
		new_index = POSITIONS.size() - 1
	elif new_index > POSITIONS.size() - 1:
		new_index = 0
	print("new index ", new_index)
	curr_position_index = new_index
#	var angle = Vector3(sin(d * speed) * radius, height, cos(d * speed) * radius)
	get_camera_position(POSITIONS[curr_position_index])

func get_camera_position(angle: int):
	position = get_angle(angle) + Vector3(unit_pos.x, 0, unit_pos.z)
	is_moving = false

func get_angle(angle: int) -> Vector3:
	return Vector3(sin(angle) * radius, height, cos(angle) * radius)

func _input(event):
#	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
#		position -= Vector3(-event.relative.x, 0, -event.relative.y) * dragSensitivity
	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_MIDDLE):
		if is_moving: return
		is_moving = true
		slide_camera(event.relative.x > 0)
#		rotation += Vector3(event.relative.x, event.relative.y, 0) * zoomSpeed
#	if event is InputEventMouseButton:
#		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
#			position.y -= zoomSpeed
#		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
#			position.y += zoomSpeed
