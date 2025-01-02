extends Node2D

enum State {
	EMPTY,
	CROSS,
	CIRCLE
}

signal pressed(x, y)

@export var grid_x := 0
@export var grid_y := 0

@export var state := State.EMPTY 

func set_state(state: State):
	self.state = state
	if state == State.EMPTY:
		$Circle.visible = false
		$Cross.visible = false
	if state == State.CROSS:
		$Circle.visible = false
		$Cross.visible = true
	if state == State.CIRCLE:
		$Circle.visible = true
		$Cross.visible = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_state(state)
	pass # Replace with function body.

func set_grid(x, y):
	grid_x = x
	grid_y = y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_texture_button_pressed() -> void:
	pressed.emit(grid_x, grid_y)
