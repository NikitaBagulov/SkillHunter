extends RigidBody2D  # Используем Area2D для взаимодействия с физикой и для простоты

@export var speed: float = 100.0  # Скорость передвижения врага
@export var change_direction_time: float = 2.0  # Время передвижения в одном направлении
var velocity: Vector2  # Вектор движения
var direction_change_timer: Timer  # Таймер для смены направления
var screen_size: Vector2  # Размер экрана

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("enemies")
	screen_size = get_viewport_rect().size
	direction_change_timer = Timer.new()
	add_child(direction_change_timer)
	direction_change_timer.wait_time = change_direction_time
	direction_change_timer.one_shot = false  # Повторный запуск
	direction_change_timer.timeout.connect(_on_direction_change)
	direction_change_timer.start()
	
	# Начальное направление
	_change_direction()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	# Обновляем позицию врага
	position += velocity * delta

	# Проверяем, если враг достиг границ экрана
	if position.x < 0 or position.x > screen_size.x:
		velocity.x *= -1  # Меняем направление по X
	if position.y < 0 or position.y > screen_size.y:
		velocity.y *= -1  # Меняем направление по Y

	# Обновляем анимации
	_update_animation()

# Метод для смены направления
func _on_direction_change():
	_change_direction()

# Метод для установки случайного направления
func _change_direction():
	var random_angle = randf() * 2 * PI  # Генерируем случайный угол
	velocity = Vector2(cos(random_angle), sin(random_angle)).normalized() * speed

# Обновляем анимацию в зависимости от направления движения
func _update_animation():
	if velocity.length() > 0:
		$AnimatedSprite2D.play()

		# Устанавливаем анимацию в зависимости от направления
		$AnimatedSprite2D.animation = "walk"

		# Проверяем, в каком направлении враг двигается, и меняем ориентацию спрайта
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	else:
		$AnimatedSprite2D.animation = "idle"
		$AnimatedSprite2D.stop()
