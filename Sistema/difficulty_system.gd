extends Node

@export var SpawnratePM: float = 30.0
@export var mobSpawner: MobSpawner
@export var wave_duration: float = 20.0
@export var initialSpawnRate: float = 60.0
@export var breakintensity: float = 0.5



var time: float = 0.0

func _process(delta):
	#Ignorar Gameover
	if GameManager.isGameOver: return 
	time += delta
	
	#Sistema Linear
	var spawn_rate = initialSpawnRate + SpawnratePM * (time/ 60.0)

	#Sistemas de ondas
	var Sinwave= sin((time*TAU) / wave_duration)
	var waveFactor = remap(Sinwave, -1.0, 1.0, breakintensity, 1)

	spawn_rate *= waveFactor
	mobSpawner.MPM = spawn_rate
