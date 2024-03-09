extends Area2D


func _ready():
	if !global.run.employee_of_the_day.is_empty():
		$Sprite/Back/Employee.texture = load("res://assets/characters/" + global.run.employee_of_the_day + ".png")


func interact():
	if $Dialogue.visible:
		$Dialogue.cont()
	else:
		$Dialogue.say(['"Employee of the Day:"', global.run.employee_of_the_day + "!"])
