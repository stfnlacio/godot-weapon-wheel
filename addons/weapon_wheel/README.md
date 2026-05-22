# Godot 4.6 Weapon Wheel UI Component

A highly customizable, math-driven radial selection menu UI component for Godot 4.6. This plugin utilizes a central fallback slot (e.g., "Unarmed/Fists") and dynamically divides outer slices into segments matching your weapon list size using Texture Atlas regions.

---

## 🚀 Features
* **Dynamic Slicing:** Automatically splits outer selection segments based on array data.
* **Resource-Driven:** Add, remove, or modify items directly in the Inspector using custom `WheelOption` resources.
* **Atlas Texture Support:** Draws specific weapon slices from a single spritesheet texture using region rectangles.
* **Central Anchor Node:** Selects index `0` when the cursor stays inside the inner ring deadzone.

---

## 📦 Installation & Setup

1. **Copy Plugin Files:** Ensure your project folder structure looks like this:
   ```text
   your_project/
   └── addons/
	   └── weapon_wheel/
		   ├── icon_1.png
		   ├── plugin.cfg
		   ├── plugin_entry.gd
		   ├── wheel_option.gd
		   └── weapon_wheel.gd
   ```
2. **Enable the Plugin:** 
   * Open Godot 4.6.
   * Go to **Project** > **Project Settings** > **Plugins** tab.
   * Locate **Weapon Wheel UI Component** and check **Enable**.

---

## ⚙️ Configuration (Inspector)

1. Create or open your User Interface (UI) Scene.
2. **Add Node:** Right-click your UI hierarchy container, click **Add Child Node**, search for `WeaponWheel`, and add it.
3. In the Inspector panel, configure your layout parameters:
   * `Inner Radius`: Center radius zone size (default: `64`).
   * `Outer Radius`: Maximum bound size of the menu (default: `256`).
   * `Line Width`: Size of sector dividing separation line layout borders.
   * `Bag Color / Highlight Color`: Visual style color options.

### Populating Weapon Data Slots
1. Expand the **Options** array in the Inspector.
2. Increase the size counter (e.g., set to `4` elements).
   * **Index 0:** This represents the **Center core element** (e.g., Fists/Melee/Cancel).
   * **Indices 1+:** These populate the surrounding outer wheels slices starting from 0° (Right direction).
3. For each array entry element dropdown, choose **New WheelOption**.
4. Pass your spritesheet asset to the `Atlas` slot, and adjust the `Region` coordinates to map the exact weapon frame pixels (e.g., `x:0, y:0, w:200, h:128`).

---

## 💻 Code Integration Tutorial

Attach the following example code block directly to your core game scene or master CanvasLayer scene node to handle opening, closing, and tracking selections.

### Input Mapping Setup
Before running, go to **Project** > **Project Settings** > **Input Map** and create an action named:
* `toggle_weapon_wheel` (e.g., bound to **Tab** key or **Gamepad L1** button).

### Manager Script Implementation

```gdscript
extends CanvasLayer

@onready var weapon_wheel: WeaponWheel = $WeaponWheel

func _ready() -> void:
	# Connect to the selection confirmation signal
	weapon_wheel.selection_confirmed.connect(_on_weapon_chosen)
	# Hide the wheel at startup
	weapon_wheel.active = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_weapon_wheel"):
		# Show wheel and freeze camera/mouse capture if necessary
		weapon_wheel.active = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
	elif event.is_action_released("toggle_weapon_wheel"):
		if weapon_wheel.active:
			# Process current selection choice slice frame upon releasing action key
			weapon_wheel.confirm_current_selection()
			weapon_wheel.active = false
			# Re-hide or lock cursor layout if making a first-person shooter
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_weapon_chosen(option_index: int, option_data: WheelOption) -> void:
	if option_data:
		print("Switched to Weapon Index: ", option_index, " | Name: ", option_data.name)
		# Trigger your game's weapon switching manager code right here!
	else:
		print("Empty weapon slot selected.")
```

---

## 🛠️ Customization Notes
* **Text Displays:** To show item names in the center of the screen, listen to the internal mouse tracking loop index updates to populate standard `Label` nodes dynamically.
* **Gamepad Support:** If targeting gamepads, swap out `get_local_mouse_position()` calculations within `_process()` for direct vector polling readings derived from `Input.get_vector("look_left", "look_right", "look_up", "look_down")`.
