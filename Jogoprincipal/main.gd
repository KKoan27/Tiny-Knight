extends Node

@export var game_ui: CanvasLayer
@export var gameOverTemplate: PackedScene


func _ready():
	GameManager.GameOver.connect(Tgameover)
func Tgameover():
	#Deletar o game UI
	if game_ui:
		game_ui.queue_free()
		game_ui= null

	#Criar GameOverUi
	var gameOverUi= gameOverTemplate.instantiate()
	add_child(gameOverUi)
	 
	
