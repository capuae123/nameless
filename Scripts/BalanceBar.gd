extends Control

# Variables for the balance logic
@export var bar_speed: float = 50.0  # Speed at which the bar naturally drifts
@export var bubble_influence: float = 30.0  # Influence of hot/cold bubbles
@export var max_balance: float = 100.0  # Max value for the bar (extremes)
@export var drift_towards: int = 1  # Direction of drift, 1 for hot, -1 for cold

var balance: float = 0.0  # Current balance (0 is neutral)
var is_paused: bool = false  # To pause bar movement

func _process(delta: float) -> void:
	if is_paused:
		return

	# Natural drift toward extremes
	balance += drift_towards * bar_speed * delta

	# Clamp balance to prevent overflow
	balance = clamp(balance, -max_balance, max_balance)

	# Update the visual representation of the bar
	update_bar()

	# Check win/lose conditions (optional)
	check_game_conditions()

func shoot_bubble(is_hot: bool) -> void:
	# Apply bubble influence based on type
	if is_hot:
		balance += bubble_influence
	else:
		balance -= bubble_influence

	# Clamp balance to stay within bounds
	balance = clamp(balance, -max_balance, max_balance)

	# Update the bar after the bubble is shot
	update_bar()

func update_bar() -> void:
	# Update the bar's UI representation based on `balance`
	var bar_fill = lerp(0.0, 1.0, (balance + max_balance) / (2 * max_balance))
	$ProgressBar.value = bar_fill * 100  # Assuming you are using a ProgressBar node

func check_game_conditions() -> void:
	# Check if the bar is too far to one side
	if balance == max_balance:
		print("Too hot! Game over.")
		is_paused = true
	elif balance == -max_balance:
		print("Too cold! Game over.")
		is_paused = true
	elif abs(balance) < 10.0:
		print("Great! You're close to neutral.")

# Optional: Reset the game
func reset_game() -> void:
	balance = 0.0
	is_paused = false
	update_bar()
