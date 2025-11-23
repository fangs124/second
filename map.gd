extends Node2D

const N = 1
const E = 2
const S = 4
const W = 8

var cell_walls = {Vector2i(1, 0): E, Vector2i(-1, 0): W,
				  Vector2i(0, 1): S, Vector2i(0, -1): N}

var tile_size = 64 # tile size (in pixels)
var width = 25 # width of map (in tiles)
var height = 15 # height of map (in tiles)

# get a reference to the map for convenience
@onready var Map = $TileMapLayer

func _ready():
	randomize()
	#tile_size = Map.cell_size
	make_maze()

func check_neighbors(cell, unvisited):
	# returns an array of cell's unvisited neighbors
	var list = []
	for n in cell_walls.keys():
		if cell + n in unvisited:
			list.append(cell + n)
	return list

func map(mask):
	match mask:
		0:
			return Vector2i(5, 2)
		1:
			return Vector2i(1, 0)
		2:
			return Vector2i(4, 2)
		3:
			return Vector2i(2, 2)
		4:
			return Vector2i(7, 1)
		5:
			return Vector2i(4, 3)
		6:
			return Vector2i(7, 0)
		7:
			return Vector2i(4, 1)
		8:
			return Vector2i(5, 1)
		9:
			return Vector2i(0, 0)
		10:
			return Vector2i(6, 0)
		11:
			return Vector2i(1, 2)
		12:
			return Vector2i(6, 1)
		13:
			return Vector2i(5, 0)
		14:
			return Vector2i(0, 3)
		15:
			return Vector2i(6, 3)
		_:
			return Vector2i(6, 3)

func pam(coord):
	match coord:
		Vector2i(5, 2):
			return 0
		Vector2i(1, 0):
			return 1
		Vector2i(4, 2):
			return 2
		Vector2i(2, 2):
			return 3
		Vector2i(7, 1):
			return 4
		Vector2i(4, 3):
			return 5
		Vector2i(7, 0):
			return 6
		Vector2i(4, 1):
			return 7
		Vector2i(5, 1):
			return 8
		Vector2i(0, 0):
			return 9
		Vector2i(6, 0):
			return 10
		Vector2i(1, 2):
			return 11
		Vector2i(4, 1):
			return 12
		Vector2i(5, 0):
			return 13
		Vector2i(0, 3):
			return 14
		Vector2i(6, 3):
			return 15
		_:
			return 15
			
		
func make_maze():
	var unvisited = [] # array of unvisited tiles
	var stack = []
	# fill the map with solid tiles
	Map.clear()
	for x in range(width):
		for y in range(height):
			unvisited.append(Vector2i(x, y))
			Map.set_cell(Vector2i(x, y), 0, map(15))
	var current = Vector2i(0, 0)
	unvisited.erase(current)
	
	while unvisited:
		var neighbors = check_neighbors(current, unvisited)
		if neighbors.size() > 0:
			var next = neighbors[randi() % neighbors.size()]
			stack.append(current)
			# remove walls from *both* cells
			var dir = next - current
			var current_walls = Map.get_cell_source_id(current) - cell_walls[dir]
			var next_walls = Map.get_cell_source_id(next) - cell_walls[-dir]
			Map.set_cell(current, 0, map(current_walls))
			Map.set_cell(next, 0, map(next_walls))
			current = next
			unvisited.erase(current)
		elif stack:
			current = stack.pop_back()


func _make_maze():
	var unvisited = [] # array of unvisited tiles
	var stack = []
	# fill the map with solid tiles
	Map.clear()
	for x in range(width):
		for y in range(height):
			unvisited.append(Vector2i(x, y))
			Map.set_cell(Vector2i(x, y), 0, map(15))
	var current = Vector2i(0, 0)
	unvisited.erase(current)
	
	while unvisited:
		var neighbors = check_neighbors(current, unvisited)
		if neighbors.size() > 0:
			var next = neighbors[randi() % neighbors.size()]
			stack.append(current)
			# remove walls from *both* cells
			var dir = next - current
			var current_walls = pam(Map.get_cell_atlas_coords(current)) - cell_walls[dir]
			var next_walls = pam(Map.get_cell_atlas_coords(next)) - cell_walls[-dir]
			Map.set_cell(current, 0, map(current_walls))
			Map.set_cell(next, 0, map(next_walls))
			current = next
			unvisited.erase(current)
		elif stack:
			current = stack.pop_back()
