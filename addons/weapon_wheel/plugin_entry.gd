@tool
extends EditorPlugin

func _enter_tree() -> void:
	add_custom_type("WeaponWheel", "Control", preload("weapon_wheel.gd"), preload("icon_1.png"))

func _exit_tree() -> void:
	remove_custom_type("WeaponWheel")
