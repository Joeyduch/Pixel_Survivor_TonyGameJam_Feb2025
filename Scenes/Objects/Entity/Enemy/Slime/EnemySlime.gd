class_name EnemySlime extends Enemy

enum STATUS {IDLE, MOVE}

var current_status:STATUS = STATUS.IDLE

var status_time:Dictionary[STATUS, float] = {
	STATUS.IDLE: 1,
	STATUS.MOVE: 0.25
}

@onready var status_timer:Timer = $StatusTimer



func _ready() -> void:
	super()
	status_timer.connect("timeout", _on_status_timer_timeout)
	toggle_status()



func start_status_timer() -> void:
	status_timer.wait_time = status_time[current_status]
	status_timer.start()


func move() -> void:
	character_controller.is_active = true

func idle() -> void:
	character_controller.is_active = false


func toggle_status() -> void:
	if current_status == STATUS.IDLE:
		current_status = STATUS.MOVE
		move()
	elif current_status == STATUS.MOVE:
		current_status = STATUS.IDLE
		idle()
	start_status_timer()



func _on_status_timer_timeout() -> void:
	toggle_status()
