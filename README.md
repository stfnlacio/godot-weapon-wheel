# Godot 4.6 Weapon Wheel UI Component

A highly customizable, math-driven radial selection menu UI component for Godot 4.6. This plugin utilizes a central fallback slot (e.g., "Unarmed/Fists") and dynamically divides outer slices into segments matching your weapon list size using Texture Atlas regions.

---

## 📦 Installation & Setup

1. Go to the **Releases** tab on the right side of this repository page.
2. Download the `weapon_wheel_v1.0.0.zip` file from the latest release assets.
3. Extract the `.zip` archive directly into the root directory (`res://`) of your Godot project. Your final folder structure should look like this:
   ```text
   your_project/
   └── addons/
       └── weapon_wheel/
           ├── icon.png
           ├── plugin.cfg
           ├── plugin_entry.gd
           ├── weapon_wheel.gd
           └── wheel_option.gd
   ```
4. Open your Godot Project, navigate to **Project** > **Project Settings** > **Plugins**, and check **Enable** next to the Weapon Wheel UI Component.

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
