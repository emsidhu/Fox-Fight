shader_type canvas_item;

uniform bool active = false;

void fragment() {
	vec4 prev_colour = texture(TEXTURE, UV);
	vec4 white_colour = vec4(1.0, 1.0, 1.0, prev_colour.a);
	vec4 new_colour = prev_colour;
	if (active) {
		new_colour = white_colour;
	}
	COLOR = new_colour;
}