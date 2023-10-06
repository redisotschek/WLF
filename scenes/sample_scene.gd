extends Node3D

@onready var units = get_tree().get_nodes_in_group("Units")
@onready var gridmap = get_tree().get_nodes_in_group("Gridmap")[0]
var astar = AStar3D.new()
var grid: Dictionary = {}
var cell_size = 1
const DIRECTIONS = [Vector3.UP, Vector3.DOWN, Vector3.LEFT, Vector3.RIGHT, Vector3.FORWARD, Vector3.BACK]
@export var show_debug: bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	var cells = gridmap.get_used_cells()
	print(cell_size)
	for cell in cells:
		cell.x -= cell_size / 2
		cell.z -= cell_size / 2
		grid[v3_to_index(cell)] = cell
	add_points()
	connect_all_points()

func _get_path(_point_a: Vector3, _point_b: Vector3):
	var a_id = get_point_id(_point_a)
	var b_id = get_point_id(_point_b)
	return astar.get_point_path(a_id, b_id)

func add_points():
	var cur = 0
	for point in grid:
		astar.add_point(cur, grid_to_world(grid[point]))
		cur += 1

func connect_all_points():
	for point in grid:
		connect_point(grid[point])

func connect_point(_point: Vector3):
	var _point_id = get_point_id(_point)
	for direction in DIRECTIONS:
		var neighbor = _point + direction
		var neighbor_id = get_point_id(neighbor)
		if grid.has(v3_to_index(neighbor)):
			astar.connect_points(_point_id, neighbor_id)

func disconnect_point(_point: Vector3):
	var _point_id = get_point_id(_point)
	for direction in DIRECTIONS:
		var neighbor = _point + direction
		var neighbor_id = get_point_id(neighbor)
		astar.disconnect_points(_point_id, neighbor_id)

func grid_to_world(_pos: Vector3) -> Vector3:
	return _pos * cell_size
	
func world_to_grid(_pos: Vector3) -> Vector3:
	return floor(_pos / cell_size)

func v3_to_index(v3: Vector3) -> String:
	return str(int(round(v3.x))) + "," + str(int(round(v3.y))) + "," + str(int(round(v3.z)))

func _input(event):
	if Input.is_action_just_pressed("LeftMouse"):
		
		var camera = get_tree().get_nodes_in_group("Camera")[0]
		var mouse_pos = get_viewport().get_mouse_position()
		var rayLength = 100
		var from = camera.project_ray_origin(mouse_pos)
		var to = from + camera.project_ray_normal(mouse_pos) * rayLength
		var space = get_world_3d().direct_space_state
		var map = get_world_3d().navigation_map
		var ray_query = PhysicsRayQueryParameters3D.new()
		ray_query.from = from
		ray_query.to = to
		ray_query.collide_with_areas = true
		var result = space.intersect_ray(ray_query)
		var active_unit = units[0]
		if result:
			var unitpos = astar.get_closest_point(active_unit.position)
			var path = _get_path(active_unit.position, result.position)
			active_unit.path = path

func get_point_id(point: Vector3):
	return astar.get_closest_point(grid_to_world(point))

func get_world_id(point: Vector3):
	return astar.get_closest_point(point)

func get_id_world_pos(_id: int) -> Vector3:
	return astar.get_point_position(_id)

func get_id_grid_pos(_id: int) -> Vector3:
	var world_pos = get_id_world_pos(_id)
	return world_to_grid(world_pos)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
