extends CharacterBody3D

@onready var pf = $Pathfinding
const SPEED = 1
const CELL_SIZE = 1
var path = []
var next_target: Vector3

signal unitSelected

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	position = Vector3(0, 0, 0)

func _physics_process(delta):
	if pf.target_position:
		next_target = pf.get_next_path_position()
	if not is_on_floor():
		velocity.y = 0 - position.y
	move_and_slide()

func stop():
	velocity = Vector3.ZERO

func move():
	print('move')
	if path.size() > 0:
		pf.target_position = path[0]
		path.remove_at(0)
		move_to_point()
	else:
		stop()
	
func move_to_point():
	var direction = global_position.direction_to(pf.target_position)
	look_at(Vector3(direction.x, global_position.y, direction.z), Vector3.UP, true)
	velocity = direction * SPEED

func _on_pathfinding_link_reached(details):
	print("link")

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		emit_signal("unitSelected", self)

func _on_pathfinding_navigation_finished():
	print("navigation")


func _on_pathfinding_path_changed():
	print("path changed to ", path.size())


func _on_pathfinding_target_reached():
	print("target reached")
	move()

func _on_pathfinding_waypoint_reached(details):
	print("waypoint reached")
