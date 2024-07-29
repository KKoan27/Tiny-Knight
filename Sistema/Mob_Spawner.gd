class_name MobSpawner
extends Node2D

@export var Bixanos: Array [PackedScene]
var MPM: float = 60.0

@onready var path_follow_2d: PathFollow2D = %PathFollow2D
var CD: float = 0.0

func  _process(delta: float):
	#Ignorar Gameover
	if GameManager.isGameOver: return 
	
	#Temporizador (cooldown)
	CD -= delta
	if CD > 0.0:
		return
		
	#Frequencia : monstros por minuto
	var interval=  60.0/MPM
	CD=interval
	
	
	#Checar se o ponto é valido
	var point = getpos()
	var worldState= get_world_2d().direct_space_state
	var parameters= PhysicsPointQueryParameters2D.new()
	parameters.position = point
	parameters.collision_mask = 0b1000
	var result: Array = worldState.intersect_point(parameters, 1)
	
	if not result.is_empty(): return
	
	
	#Perguntar se o ponto tem colisão
	
	#Instanciar random criatura
	var index= randi_range(0, Bixanos.size()-1)
	var creaturesScene= Bixanos[index]
	var Bixano= creaturesScene.instantiate()
	Bixano.global_position= getpos()
	get_parent().add_child(Bixano)

	

func getpos()-> Vector2:
	path_follow_2d.progress_ratio = randf()
	return path_follow_2d.global_position
	
