class_name Enemy
extends Node2D

@export var health: int = 10
@export var deathPF: PackedScene


func Damage(amount: int) -> void:
	health -= amount
	print ("inimigo recebeu dano de ", amount, "A vida total é de ", health)
	
	#piscar inimigo (node)
	modulate= Color.RED
	var Tiween= create_tween()
	Tiween.set_ease(Tween.EASE_IN)
	Tiween.set_trans(Tween.TRANS_QUINT)
	Tiween.tween_property(self, "modulate", Color.WHITE, 0.2)
	
	
	#Processar morte
	if health <= 0:
		die()
		
		

func die()-> void:
	if deathPF: 
		var death_object=deathPF.instantiate()
		death_object.position = position
		get_parent().add_child(death_object)
	queue_free()
	
		
		
	
