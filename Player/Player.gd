class_name Player
extends CharacterBody2D

@export_category("Movement")
@export var Speed: float 

@export_category("Fight")
@export var Sword_damage: int =2
@export var health: float =100
@export var deathPF: PackedScene

@export_category("Ritual")
@export var SkillDamage: int = 1
@export var Skill_interval: float = 30
@export var Skill_scene: PackedScene

#ONREADY'S
@onready var animation_player: AnimationPlayer= $AnimationPlayer
@onready var Sprite: Sprite2D = $Sprite2D;
@onready var sword_area: Area2D= $AreaEspada
@onready var hitbox_area: Area2D= $HitboxArea
@onready var healthbar: ProgressBar = $Life
#variaveis normais
var is_attacking:bool= false
var attack_cd:float= 0
var inputvector:Vector2 = Vector2(0,0)
var is_running: bool = false;
var hitbox_cooldown: float =0.0
var max_health: int = 50
var SkillCD: float = 2

signal  meat_collected(value:int)



func _ready():
	GameManager.player = self 
	meat_collected.connect(func(value:int): GameManager.meat_counter+= 1)
# MAIN DO NEGOCIO INTEIRO:
func _process(delta):
	
	GameManager.Player_Pos = position
	#ler input
	read_input()

	
	if not is_attacking:
		rotateSprite()
	#atualizar temporizador do ata

	if attack_cd > 0: 
		attack_cd -= delta
		if attack_cd <= 0.0:
			is_attacking = false
			is_running = false
			animation_player.play("Idle")
	update_hitbox_detection(delta)
	
	update_ritual(delta)
	
	#Atualizar barra de vida
	healthbar.max_value = max_health
	healthbar.value= health
	
	var running= is_running
	is_running= not inputvector.is_zero_approx()
	
	if not is_attacking:
		if running!= is_running:
			if is_running:
				animation_player.play("Run")
			else:
				animation_player.play("Idle")


func _physics_process(delta):
	#Modificiar a velocidade
	if Input.is_action_just_pressed("attack"):
		attack()
	var target_velocity = inputvector * Speed * 50
	if is_attacking:
		target_velocity *= 0.5
		
	velocity = lerp (velocity, target_velocity, 1)
	move_and_slide()


# MOVIMENTAÇÃO E ROTAÇÃO DE PLAYER:
func read_input():
	inputvector= Input.get_vector("Move_left", "Move_right", "Move_up", "Move_down")
	
	

func rotateSprite()->  void:
		#girar o sprite
	if inputvector.x > 0:
		Sprite.flip_h = false
	elif inputvector.x <0:
		Sprite.flip_h = true	
	


#----------------------------------------------------------
# 		LUTA: CÓDIGO DE ATACAR E RECEBER ATAQUE 
#----------------------------------------------------------
func attack() -> void:
	if is_attacking:
		return
	
	# Tocar animação x e y
	
	if inputvector.y ==  1:
		animation_player.play("AttackD1")
	elif inputvector.y== -1:
		animation_player.play("AttackU1")
	else:
		animation_player.play("AttackSide")
	
	# Configurar temporizador
	attack_cd = 0.6
	
	# Marcar ataque
	is_attacking = true

func update_ritual(delta: float) -> void:
	# Atualizar temporizador
	SkillCD -= delta
	if SkillCD > 0: return
	SkillCD = Skill_interval
	
	# Criar ritual
	
	var Skill = Skill_scene.instantiate()
	Skill.damage_amount = SkillDamage
	add_child(Skill)

	
func deal_damage()-> void:
	#Aplicar dano nos inimigos	
	var Bode= sword_area.get_overlapping_bodies()
	for body in Bode:
		if body.is_in_group("Inimigos"):
			var enemy: Enemy = body
			var directionEnemy=(enemy.position - position).normalized() 
			var attackDirection: Vector2 
			if Sprite.flip_h:
				attackDirection= Vector2.LEFT
			else:
				attackDirection= Vector2.RIGHT
			var dot_product= directionEnemy.dot(attackDirection)
			if dot_product >= 0.4:
				enemy.DamageE(Sword_damage)

				

			pass
	
	#Acessar todos os inimigos. Chamar a função "damage" com o sword_damage como primeiro parâmetro
	
func Damage(amount: int) -> void:
	if health <= 0: return
	health -= amount

	
	#piscar inimigo (node)
	modulate= Color.RED
	var Tiween= create_tween()
	Tiween.set_ease(Tween.EASE_IN)
	Tiween.set_trans(Tween.TRANS_QUINT)
	Tiween.tween_property(self, "modulate", Color.WHITE, 0.2)
	#Processar morte
	if health <= 0:
		die()
	
func update_hitbox_detection(delta: float)-> void:
	#Temporizador
	hitbox_cooldown -= delta
	if hitbox_cooldown > 0 : return
	#Frequencia (1xpor segundo
	hitbox_cooldown=0.5
	#HitboxArea
	var bodies=hitbox_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("Inimigos"):
			var enemy:Enemy=body
			var damage_amount=1
			Damage(damage_amount)
			
	pass
	
func die()-> void:
	GameManager.end_game()
	if deathPF: 
		var death_object=deathPF.instantiate()
		death_object.position = position
		get_parent().add_child(death_object)
		print(" O player morreu")
	queue_free()
	

#------------------------#
# 	Função de curar		 #
#------------------------#
func heal (amount: int) ->int :
	health+= amount
	if health > max_health:
		health= max_health
	return health


