extends CanvasLayer
@onready var timerLabel : Label= %TimerL
@onready var meatLabel : Label= %MeatL
 
func _process (delta: float):
	timerLabel.text= GameManager.timeElapString
	meatLabel.text = str(GameManager.meat_counter)

	
