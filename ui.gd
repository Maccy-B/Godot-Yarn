extends Control

signal house_selected(scene: PackedScene)

const SMALL_HOUSE = preload("res://SmallHouse.tscn")
const BIG_HOUSE = preload("res://BigHouse.tscn")

func _on_item_list_item_selected(index: int) -> void:
	match index:
		0: house_selected.emit(SMALL_HOUSE)
		1: house_selected.emit(BIG_HOUSE)
