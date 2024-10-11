extends Camera2D

@export var min_zoom = Vector2(0.5, 0.5)  # Минимальное увеличение
@export var max_zoom = Vector2(2, 2)      # Максимальное уменьшение
@export var zoom_speed = 0.1              # Скорость изменения масштаба
@export var target: Node2D  # Ссылка на узел, за которым будет следовать камера

# Функция для обработки ввода
func _input(event):
	# Проверка на нажатие клавиш для зума
	if Input.is_action_pressed("ui_zoom_in"):
		zoom *= 1 - zoom_speed              # Увеличение зума
	elif Input.is_action_pressed("ui_zoom_out"):
		zoom *= 1 + zoom_speed              # Уменьшение зума

	# Ограничение масштаба
	zoom.x = clamp(zoom.x, min_zoom.x, max_zoom.x)
	zoom.y = clamp(zoom.y, min_zoom.y, max_zoom.y)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if target:
		position = target.position  # Устанавливаем позицию камеры на позицию игрока
