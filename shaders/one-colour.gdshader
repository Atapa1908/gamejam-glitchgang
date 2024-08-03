shader_type canvas_item;

uniform float mixer: hint_range(0.0, 1.0) = 0.0;
uniform float r_mixer: hint_range(0.0, 1.0) = 0.0;
uniform float g_mixer: hint_range(0.0, 1.0) = 0.0;
uniform float b_mixer: hint_range(0.0, 1.0) = 0.0;

void fragment() {
	vec4 input_color = texture(TEXTURE, UV);
	input_color.r = input_color.r + r_mixer;
	input_color.g = input_color.g + g_mixer;
	input_color.b = input_color.b + b_mixer;
	input_color.rgb = input_color.rgb + mixer;
	COLOR = input_color;
}

