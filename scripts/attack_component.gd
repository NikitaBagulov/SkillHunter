extends Node2D
class_name AttackComponent

@export var attack_power: int = 10  # Сила атаки
@export var attack_range: float = 100.0  # Дальность атаки
@export var attack_cooldown: float = 1.5  # Время восстановления атаки

var can_attack: bool = true
var attack_timer: Timer
var player_velocity: Vector2 = Vector2.ZERO  # Вектор скорости игрока

# Инициализация таймера атаки
func _ready():
	attack_timer = Timer.new()
	add_child(attack_timer)
	attack_timer.wait_time = attack_cooldown
	attack_timer.one_shot = true
	attack_timer.timeout.connect(_on_attack_cooldown)


# Атака цели
func attack(target: Node):
	if not can_attack:
		print("Cannot attack: cooldown active")
		return
	var health_component = target.get_node("HealthComponent")
	if health_component and health_component.has_method("take_damage"):
		print("Attacking target")
		health_component.call("take_damage", attack_power)
		can_attack = false
		attack_timer.start()
	else:
		print("Target does not have a take_damage method")

func find_enemy_in_attack_range():
	var enemies_in_range = []

	# Получаем всех врагов в текущей сцене
	var enemies = get_tree().get_nodes_in_group("enemies")
	print("Enemies in group: ", enemies)
	
	# Проверяем каждого врага
	for enemy in enemies:
		var distance = global_position.distance_to(enemy.global_position)
		print("Player position: ", position)  # Отладка позиции игрока
		print("Enemy position: ", enemy.position)  # Отладка позиции врага
		print("Distance to enemy ", enemy.name, ": ", distance)
		if distance <= attack_range:
			enemies_in_range.append(enemy)
			print("Enemy found in range: ", enemy.name)

	return enemies_in_range


# Обработчик ввода
func _input(event):
	if event.is_action_pressed("attack"):
		print("Attack action pressed")  # Добавьте отладочную информацию
		var enemies = find_enemy_in_attack_range()
		if enemies.size() > 0:
			attack(enemies[0])  # Применяем атаку к первому найденному врагу
		else:
			print("No enemies in range")  # Если врагов нет в пределах досягаемости

# Окончание восстановления атаки
func _on_attack_cooldown():
	can_attack = true

# Тестируем отрисовку области атаки перед игроком
func _draw():
	print("Drawing attack area...")
	if player_velocity != Vector2.ZERO:
		var attack_position = position + player_velocity.normalized() * attack_range
		print("Attack position: ", attack_position)
		draw_circle(attack_position, attack_range, Color(1, 0, 0, 0.5))  # Красный полупрозрачный круг
	else:
		# Рисуем область атаки на месте игрока для отладки
		draw_circle(position, attack_range, Color(0, 1, 0, 0.5))  # Зеленый круг для отладки

# Обновляем вектор скорости игрока
func update_player_velocity(velocity: Vector2):
	player_velocity = velocity
	queue_redraw()  # Перерисовываем область атаки

# Устанавливаем новый радиус атаки
func set_attack_range(new_range: float):
	attack_range = new_range
	queue_redraw()

# Вызывается, когда сцена отображается
func _enter_tree():
	queue_redraw()
