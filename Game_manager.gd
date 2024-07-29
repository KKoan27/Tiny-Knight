extends Node


signal GameOver

var player: Player 
var Player_Pos: Vector2
var isGameOver: bool= false

var timeElap: float = 0.0
var timeElapString: String
var meat_counter: int = 0
var monstersDefeatedCounter: int = 0

func end_game():
	if isGameOver: return
	isGameOver = true
	GameOver.emit()
func _process (delta: float):
	timeElap += delta
	var timeElapSeconds: int = floori(timeElap)
	var seconds: int = timeElapSeconds % 60
	var minutes: int = timeElapSeconds / 60
	
	timeElapString = "%02d:%02d" % [minutes, seconds]
	
func reset():
	player = null
	Player_Pos= Vector2.ZERO
	
	isGameOver = false
	timeElap = 0.0
	timeElapString= "00:00"
	meat_counter = 0
	monstersDefeatedCounter = 0
	for connection in GameOver.get_connections():
		GameOver.disconnect(connection.callable)
	

