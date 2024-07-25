extends CharacterBody2D

@export var Speed: float 
@export var Sword_damage: int =2

@onready var animation_player: AnimationPlayer= $AnimationPlayer;
@onready var Sprite: Sprite2D = $Sprite2D;
@onready var sword_area: Area2D= $AreaEspada

var is_attacking:bool= false
var attack_cd:float= 0
var inputvector:Vector2 = Vector2(0,0)
var is_running: bool = false;


func _process(delta):
	
	GameManager.Player_Pos = position
	#ler input
	read_input()
	
	if not is_attacking:
		rotateSprite()
	#atualizar temporizador do ataque
	if attack_cd > 0: 
		attack_cd -= delta
		if attack_cd <= 0.0:
			is_attacking = false
			is_running = false
			animation_player.play("Idle")
	#Tocar animação
	var running= is_running
	is_running= not inputvector.is_zero_approx()
	
	if not is_attacking:
			if is_running:
				animation_player.play("Run")
			else:
				animation_player.play("Idle")
			 



func rotateSprite()->  void:
		#girar o sprite
	if inputvector.x > 0:
		Sprite.flip_h = false
	elif inputvector.x <0:
		Sprite.flip_h = true	
func _physics_process(delta):
	#Modificiar a velocidade
	var target_velocity = inputvector * Speed * 50
	if is_attacking:
		target_velocity *= 0.5
		
	velocity = lerp (velocity, target_velocity, 1)
	move_and_slide()


	if Input.is_action_just_pressed("attack"):
		attack()
	
func read_input():
	inputvector= Input.get_vector("Move_left", "Move_right", "Move_up", "Move_down")
	
func attack():
	if is_attacking:
		return
		
	#tocar animações X e Y 
	if inputvector.y<0:
		animation_player.play("AttackU1")
	elif inputvector.y>0:
		animation_player.play("AttackD1")
	else: 
		animation_player.play("AtackS")
	#cooldown
	attack_cd= 0.6
	#Marcar ataque
	is_attacking= true
	
	
#Aplicar dano nos inimigos	
func deal_damage()-> void:
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
				enemy.Damage(Sword_damage)
			print("Dot :", dot_product) 
				

			pass
	
	#Acessar todos os inimigos. Chamar a função "damage" com o sword_damage como primeiro parâmetro
	
	
	
	
