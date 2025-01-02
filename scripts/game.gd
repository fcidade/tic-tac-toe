extends Node2D

@export var GridItemScene: PackedScene
const size = 44

enum Player {
	Player1 = 1,
	Player2 = 2
}

enum GameState {
	Playing,
	Won
}

var current_state = GameState.Playing
var score_circle = 0
var score_cross = 0

@export var current_player = Player.Player1

var buttons = []

func reset():
	$WinnerText.text = ''
	current_state = GameState.Playing
	print('resetando')
	buttons = []
	set_current_player(Player.Player1)
	for c in $GridGroup/Grid.get_children():
		c.queue_free()
	for x in 3:
		buttons.append([])
		for y in 3:
			var i = GridItemScene.instantiate()
			i.global_position = Vector2(x * size, y * size)
			i.pressed.connect(pressed)
			i.set_grid(x, y)
			$GridGroup/Grid.add_child(i)
			buttons[x].append(i)

func set_current_player(player: Player):
	self.current_player = player
	if self.current_player == 1:
		$Turn/Circle.visible = true
		$Turn/Cross.visible = false
	if self.current_player == 2:
		$Turn/Circle.visible = false
		$Turn/Cross.visible = true
	#$CurrentPlayer.text = str(player)

func win(player):
	print('venceu ' + str(player))
	current_state = GameState.Won
	var txt = " WON"
	if player == 2:
		txt = 'CIRCLE' + txt
		score_circle += 1
		$Scores/CircleScore.text = '[left]' + str(score_circle) + '[/left]'
	if player == 1:
		txt = 'CROSS' + txt
		score_cross += 1
		$Scores/CrossScore.text = '[right]' + str(score_cross) + '[/right]'
	$WinnerText.text = '[center]' + str(txt) + '[/center]'

func pressed(x, y):
	print('pressed: ', x, ' ', y)
	if current_state != GameState.Playing:
		print('jogo ja acabou, resetando pra jogar denovo!')
		reset()
		return
	if buttons[x][y].state != 0:
		print('ja foi selecionado...')
		return
	buttons[x][y].set_state(1 if current_player != 1 else 2)
	set_current_player(Player.Player1 if current_player != Player.Player1 else Player.Player2)
	if check_player(1):
		win(1)
	if check_player(2):
		win(2)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reset()

func check_player(expected):
	for y in buttons.size():
		if check_horizontal(y, expected):
			return true
	for x in buttons.size():
		if check_vertical(x, expected):
			return true
	if check_diagonal_1(expected):
		return true
	if check_diagonal_2(expected):
		return true
	return false
		

func check_horizontal(y, expect):
	var valid = true
	for x in 3:
		valid = valid && buttons[x][y].state == expect
	return valid
	
func check_vertical(x, expect):
	var valid = true
	for y in 3:
		valid = valid && buttons[x][y].state == expect
	return valid
	
func check_diagonal_1(expect):
	var valid = true
	var side = 1
	for i in 3:
		valid = valid && buttons[i * side][i * side].state == expect
	return valid
	
func check_diagonal_2(expect):
	return (
		buttons[2][0].state == expect
		and buttons[1][1].state == expect
		and buttons[0][2].state == expect
	)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_texture_button_pressed(x, y) -> void:
	print('_on_texture_button_pressed ', x, ' ', y) # Replace with function body.


func _on_button_pressed() -> void:
	reset()
