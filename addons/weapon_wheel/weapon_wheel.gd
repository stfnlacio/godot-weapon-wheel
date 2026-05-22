@tool
class_name WeaponWheel
extends Control

signal selection_confirmed(option_index: int, option_data: WheelOption)

const SPRITE_SIZE = Vector2(200, 128)

@export var bag_color: Color = Color(0, 0, 0, 0.5)
@export var line_color: Color = Color(1, 1, 1, 1)
@export var highlight_color: Color = Color(1, 1, 0, 0.3)

@export var inner_radius: int = 64
@export var outer_radius: int = 256
@export var line_width: int = 4

@export var options: Array[WheelOption] = []:
	set(value):
		options = value
		queue_redraw()

var active := false:
	set(value):
		active = value
		set_process(active)
		visible = active
		if active:
			current_selection = 0
			queue_redraw()

var current_selection := 0

func _ready() -> void:
	# Center the pivot safely for math calculations
	set_anchors_and_offsets_preset(Control.PRESET_CENTER, Control.PRESET_MODE_MINSIZE)
	# Turn off processing until the wheel is explicitly opened/toggled active
	active = false

func _draw() -> void:
	var offset = SPRITE_SIZE / -2.0
	var option_count = options.size()
	
	# Draw main background ring
	draw_circle(Vector2.ZERO, outer_radius, bag_color)
	
	if option_count > 1:
		var slice_count = option_count - 1
		var angle_step = TAU / slice_count
		
		# 1. Draw the Highlight for the current outer selection
		if current_selection > 0 and current_selection <= slice_count:
			var start_angle = (current_selection - 1) * angle_step
			draw_arc_poly(start_angle, start_angle + angle_step, highlight_color)

		# 2. Draw the Slices and Icons
		for i in range(slice_count):
			var rads = angle_step * i
			var point = Vector2.from_angle(rads)
			
			# Draw Divider Lines
			draw_line(point * inner_radius, point * outer_radius, line_color, line_width, true)
			
			# Calculate position for Icons (Outer Slices)
			var mid_rads = rads + (angle_step / 2.0)
			var radius_mid = (inner_radius + outer_radius) / 2.0
			var draw_pos = (Vector2.from_angle(mid_rads) * radius_mid) + offset
			
			# Safe drawing check for resource and texture assignments
			if options[i + 1] and options[i + 1].atlas:
				draw_texture_rect_region(
					options[i + 1].atlas,
					Rect2(draw_pos, SPRITE_SIZE),
					options[i + 1].region
				)

	# 3. Draw Center Option (Index 0 / Central Node)
	if options.size() > 0:
		if current_selection == 0:
			draw_circle(Vector2.ZERO, inner_radius, highlight_color)
			
		if options[0] and options[0].atlas:
			draw_texture_rect_region(
				options[0].atlas,
				Rect2(offset, SPRITE_SIZE),
				options[0].region
			)
	
	# Draw Inner Circle Separation Line
	draw_arc(Vector2.ZERO, inner_radius, 0, TAU, 128, line_color, line_width, true)

func _process(_delta: float) -> void:
	if not active:
		return
		
	var mouse_pos = get_local_mouse_position()
	var dist = mouse_pos.length()
	
	if dist < inner_radius:
		if current_selection != 0:
			current_selection = 0
			queue_redraw()
	elif dist < outer_radius:
		var slice_count = options.size() - 1
		if slice_count > 0:
			var angle = mouse_pos.angle()
			if angle < 0: 
				angle += TAU
				
			var new_selection = int(angle / (TAU / slice_count)) + 1
			# Ensure index wrapping limits match options range safely
			new_selection = clampi(new_selection, 1, slice_count)
			
			if current_selection != new_selection:
				current_selection = new_selection
				queue_redraw()
	else:
		# If cursor moves completely outside outer ring bounds, deselect active state tracking
		if current_selection != -1:
			current_selection = -1
			queue_redraw()

func draw_arc_poly(start_angle: float, end_angle: float, color: Color) -> void:
	var points = PackedVector2Array()
	points.push_back(Vector2.from_angle(start_angle) * inner_radius)
	var steps = 16
	for i in range(steps + 1):
		var a = lerp(start_angle, end_angle, float(i) / steps)
		points.push_back(Vector2.from_angle(a) * outer_radius)
	for i in range(steps, -1, -1):
		var a = lerp(start_angle, end_angle, float(i) / steps)
		points.push_back(Vector2.from_angle(a) * inner_radius)
	draw_colored_polygon(points, color)

# Call this from your Player controller script to handle confirmations smoothly
func confirm_current_selection() -> void:
	if current_selection >= 0 and current_selection < options.size():
		selection_confirmed.emit(current_selection, options[current_selection])
