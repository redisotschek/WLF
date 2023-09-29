extends Node3D

@export_range(0,100,1) var camera_move_speed:float = 20.0

# flags
var camera_can_process:bool = true
var camera_can_move_base:bool = true


# nodes
@onready var camera_socket:Node3D = $camera_socket
@onready var camera:Camera3D = $camera_socket/Camera3D

func _ready():
	pass 

func _process(delta:float) -> void:
	if !camera_can_process:return
	camera_base_move(delta)

func _unhandled_input(event:InputEvent) -> void:
	pass

func camera_base_move(delta:float) -> void:
	if !camera_can_move_base:return
	var velocity_direction:Vector3 = Vector3.ZERO
	
	if Input.is_action_pressed("camera_forward"): 	   velocity_direction -= transform.basis.z
	if Input.is_action_pressed("camera_backward"): 	   velocity_direction += transform.basis.z
	if Input.is_action_pressed("camera_right"): 	   velocity_direction += transform.basis.x
	if Input.is_action_pressed("camera_left"): 	       velocity_direction -= transform.basis.x
	
	position += velocity_direction.normalized() * delta * camera_move_speed
	
