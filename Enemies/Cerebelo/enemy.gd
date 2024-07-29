class_name Enemy
extends Node2D


@export_category("Vida")
@export var health: int = 9
@export var deathPF: PackedScene
var damagedigitPF: PackedScene
@onready var damage_digit_marker = $DamageDigitMarker

@export_category("Drops")
@export var drop_chance: float = 0.1
@export var drop_items: Array [PackedScene]
@export var DropChanceS: Array [float]

func _ready():
	damagedigitPF= preload("res://Misc/damage_digit.tscn")
func DamageE(amount: int) -> void:
	health -= amount
	print ("inimigo recebeu dano de ", amount, "A vida total é de ", health)
	
	#piscar inimigo (node)
	modulate= Color.RED
	var Tiween= create_tween()
	Tiween.set_ease(Tween.EASE_IN)
	Tiween.set_trans(Tween.TRANS_QUINT)
	Tiween.tween_property(self, "modulate", Color.WHITE, 0.2)
	
	#Criar digitdamage
	var damage_digit= damagedigitPF.instantiate()
	damage_digit.value = amount
	if damage_digit_marker:
		damage_digit.global_position = damage_digit_marker.global_position
	else:
		damage_digit.global_position = global_position
	get_parent().add_child(damage_digit)
	#Processar morte
	if health <= 0:
		die()
		
		

func die()-> void:
	if deathPF: 
		var death_object=deathPF.instantiate()
		death_object.position = position
		get_parent().add_child(death_object)
	
	#DROP
	if randf() <= drop_chance:
		drop_item()
		
	#incrementar
	GameManager.monstersDefeatedCounter +=1
	
	#Deletar node
	queue_free()
	
	
	
func drop_item():
	var drop= GetRNGitem().instantiate()
	drop.position = position
	get_parent().add_child(drop)
	
func GetRNGitem()-> PackedScene:
	# Listas com 1 item
	if drop_items.size() ==1:
		return drop_items[0]
	
	#Calcular chance maxima
	var max_chance: float = 0.0 
	for drop_chance in DropChanceS:
		max_chance += drop_chance
	
	#Jogar dado
	var random_value = randf() * max_chance 
	
	#Girar Roleta
	var needle: float = 0.0
	for i in drop_items.size():
		var drop_item = drop_items[i]
		var drop_chance = DropChanceS[i] if i < DropChanceS.size() else 1
		if random_value <= drop_chance + needle:
			return drop_item
		needle += drop_chance
	return drop_items[0]
	pass
	
	
	
		
		
	
