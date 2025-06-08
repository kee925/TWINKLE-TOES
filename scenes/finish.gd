extends Area2D

@export var target_level : PackedScene

func _on_body_entered(body: Node2D):
	if (body.name == "CharacterBody2D"):
		get_tree().change_scene_to_file("res://scenes/game.tscn")
