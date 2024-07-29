extends Node

@export var speed: float = 1

var enemy: Enemy
var sprite: AnimatedSprite2D

func _ready():
	enemy= get_parent()
	sprite =  enemy.get_node ("AnimatedSprite2D")
	enemy.health

	

func _physics_process(delta):
	#Ignorar Gameover
	if GameManager.isGameOver: return 
	#calcular direção
	var player_P= GameManager.Player_Pos
	var difference= player_P - enemy.position
	var inputvector= difference.normalized() 
	
	#movimento
	enemy.velocity= inputvector * speed * 60.0
	enemy.move_and_slide()

	#Flip do sprite
	if inputvector.x > 0:
		sprite.flip_h = false
	elif inputvector.x <0:
		sprite.flip_h = true	
