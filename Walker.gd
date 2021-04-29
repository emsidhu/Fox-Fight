extends Node
class_name Walker

var Directions = [Vector2.RIGHT, Vector2.UP, Vector2.DOWN, Vector2.LEFT]

var should_place_room = true
var position = Vector2.ZERO
var direction = Vector2.DOWN
var borders = Rect2()
var step_history = []
var steps_since_turn = 0
var can_go_left = false
var rooms = []

func _init(starting_position, new_borders):
	assert(new_borders.has_point(starting_position))
	position = starting_position
	step_history.append(position)
	borders = new_borders
	place_room()

func walk(steps):
	for step in steps:
		if randf() <= 0.5 or steps_since_turn >= 6:
			change_direction()
		
		if step():
			step_history.append(position)
		else:
			change_direction()
	return step_history

func step():
	var target_position = position + direction
	if borders.has_point(target_position):
		steps_since_turn += 1
		position = target_position
		return true
	else:
		return false

func change_direction():

	steps_since_turn = 0
	var directions = Directions.duplicate()


#	if position.x + direction.x > 35 and can_go_left == false:
#		directions.append(Vector2.LEFT)
#		Directions.append(Vector2.LEFT)
#		can_go_left = true
#		should_place_room = false
	directions.erase(direction)
	directions.shuffle()
	direction = directions.pop_front()
	
	while not borders.has_point(position + direction):
		Directions.append(direction * -1)
		direction = directions.pop_front()
	
func create_room(position, size):
	return {position = position, size = size}
		
func place_room():
	var size = Vector2(randi() % 3 + 3,randi() % 4 + 2)
	var top_left_corner = (position - size/2).ceil()
	rooms.append(create_room(position, size))
	for y in size.y:
		for x in size.x:
			var new_step = top_left_corner + Vector2(x, y)
			if borders.has_point(new_step):
				step_history.append(new_step)
				
func get_end():
	var end = step_history.pop_front()
	var starting_position = step_history.front()
	for step in step_history:
		if starting_position.distance_to(step) > starting_position.distance_to(end):
			end = step
	return end
#	var end_room = rooms.pop_front()
#	var starting_position = step_history.front()
#	for room in rooms:
#		if starting_position.distance_to(room.position) > starting_position.distance_to(end_room.position):
#			end_room = room
#	return end_room
	

