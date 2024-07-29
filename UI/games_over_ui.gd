class_name GameOverClass
extends CanvasLayer


@onready var timeLabel: Label = %TimeLabel
@onready var monsterLabel: Label = %MonsterLabel
@export var restartDelay: float = 5.0
var restartCooldown: float 


func _ready():
	timeLabel.text= GameManager.timeElapString
	monsterLabel.text = str(GameManager.monstersDefeatedCounter) 
	restartCooldown= restartDelay
	pass
	
	
func _process (delta):
	restartCooldown -= delta
	if restartCooldown<= 0.0:
		restart_game()


func restart_game():
	get_tree().reload_current_scene()
	GameManager.reset()

	
