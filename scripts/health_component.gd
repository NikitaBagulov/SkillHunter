@tool
extends Node2D

@export var max_health: int = 100
var current_health: int

# Цвета для полоски здоровья
@export var health_color: Color = Color(0, 1, 0)  # Зеленый
@export var health_bg_color: Color = Color(1, 0, 0)  # Красный
@export var bar_width: float = 10.0  # Ширина полоски здоровья
@export var bar_height: float = 2.0  # Высота полоски здоровья
@export var health_bar_offset: Vector2 = Vector2(-30, -20)  # Смещение полоски относительно игрока

# Метод, вызываемый при готовности компонента
func initialize():
	current_health = max_health
	queue_redraw()  # Запрашиваем обновление отрисовки

# Метод для получения урона
func take_damage(damage: int):
	if damage < 0:
		print("Damage cannot be negative!")
		return
	
	current_health = max(current_health - damage, 0)
	print("Current Health after damage: ", current_health)
	if current_health <= 0:
		die()

	queue_redraw()  # Запрашиваем обновление отрисовки

# Метод для лечения
func heal(amount: int):
	if amount < 0:
		print("Heal amount cannot be negative!")
		return
	
	current_health = min(current_health + amount, max_health)

	queue_redraw()  # Запрашиваем обновление отрисовки

# Метод для обработки смерти персонажа
func die():
	get_parent().queue_free()

# Рисуем полоску здоровья
func _draw():
	# Координаты для полоски здоровья
	var bar_position = health_bar_offset
	var health_percentage = float(current_health) / float(max_health)
	# Фон полоски здоровья
	
	draw_rect(Rect2(bar_position, Vector2(bar_width, bar_height)), health_bg_color)
	draw_rect(Rect2(bar_position, Vector2(bar_width * health_percentage, bar_height)), health_color)

# Вызывается, когда сцена отображается
func _enter_tree():
	initialize()
	queue_redraw()  # Запрашиваем обновление отрисовки
