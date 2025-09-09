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

func _ready() -> void:
	randomize()
	$PlayerHP.max_value = 100
	$OpponentHP.max_value = 100
	$PlayerHP.value = player_hp
	$OpponentHP.value = opponent_hp
	
	# Connect buttons
	$RealButton.pressed.connect(_on_real_pressed)
	$FakeButton.pressed.connect(_on_fake_pressed)
	
	show_new_image()

func show_new_image() -> void:
	current_image = images[randi() % images.size()]
	$ImageDisplay.texture = load(current_image["path"])
	$FeedbackLabel.text = ""   # clear feedback

func _on_real_pressed() -> void:
	handle_answer(false)

func _on_fake_pressed() -> void:
	handle_answer(true)

# Attack animation for a TextureRect
func animate_attack(avatar: TextureRect) -> void:
	var idle_texture = avatar.texture
	avatar.texture = load("res://assets/player_attack.png")
	await get_tree().create_timer(0.25).timeout
	avatar.texture = idle_texture
	
func handle_answer(answer_is_fake: bool) -> void:
	if current_image["is_fake"] == answer_is_fake:
		await animate_attack($PlayerAvatar)
		opponent_hp -= 20
		$FeedbackLabel.text = "Correct!"
	else:
		await animate_attack($OpponentAvatar)
		player_hp -= 20
		$FeedbackLabel.text = "Wrong!"
	
	$PlayerHP.value = player_hp
	$OpponentHP.value = opponent_hp
	
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


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://player/player.tscn")
