extends Node2D

# HP values
var player_hp = 100
var opponent_hp = 100

# Images (replace with your real/fake dataset)
var images = [
	{"path": "res://assets/real1.png", "is_fake": false},
	{"path": "res://assets/real2.png", "is_fake": false},
	{"path": "res://assets/fake1.png", "is_fake": true},
	{"path": "res://assets/fake2.png", "is_fake": true},
]

var current_image = null

func _ready():
	randomize()
	$PlayerHP.max_value = 100
	$OpponentHP.max_value = 100
	$PlayerHP.value = player_hp
	$OpponentHP.value = opponent_hp
	
	# Connect buttons
	$RealButton.connect("pressed", self, "_on_real_pressed")
	$FakeButton.connect("pressed", self, "_on_fake_pressed")
	
	show_new_image()

func show_new_image():
	current_image = images[randi() % images.size()]
	$ImageDisplay.texture = load(current_image["path"])
	$FeedbackLabel.text = ""   # clear feedback

func _on_real_pressed():
	handle_answer(false)

func _on_fake_pressed():
	handle_answer(true)

func handle_answer(answer_is_fake: bool):
	if current_image["is_fake"] == answer_is_fake:
		# Correct
		opponent_hp -= 20
		$FeedbackLabel.text = "Correct!"
	else:
		# Wrong
		player_hp -= 20
		$FeedbackLabel.text = "Wrong!"
	
	# Update HP bars
	$PlayerHP.value = player_hp
	$OpponentHP.value = opponent_hp
	
	# Check win/loss
	if player_hp <= 0:
		$FeedbackLabel.text = "You Lost!"
		$RealButton.disabled = true
		$FakeButton.disabled = true
	elif opponent_hp <= 0:
		$FeedbackLabel.text = "You Won!"
		$RealButton.disabled = true
		$FakeButton.disabled = true
	else:
		show_new_image()
