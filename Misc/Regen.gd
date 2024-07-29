extends Node2D

@export var Regenlife: int = 20


func _ready():
	
	var colision = $Area2D.body_entered.connect(onbodyenter)

func onbodyenter(body: Node2D) -> void:
	if body.is_in_group("Player"):
		var player: Player = body
		player.heal(Regenlife)
		player.meat_collected.emit(Regenlife)
		queue_free()
	print(body)
	pass
