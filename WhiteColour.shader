shader_type canvas_item;

uniform bool is_white = false;
uniform bool is_blue = false;

void fragment() {
	vec4 prev_colour = texture(TEXTURE, UV);
	vec4 white_colour = vec4(1.0, 1.0, 1.0, prev_colour.a);
	vec4 blue_colour = vec4(0, 1.0, 1.0, prev_colour.a);
	vec4 new_colour = prev_colour;
	if (is_white) {
		new_colour = white_colour;
	}
	else if (is_blue) {
		new_colour = blue_colour
	}
	COLOR = new_colour;
}