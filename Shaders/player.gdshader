shader_type canvas_item;

uniform float mixer: hint_range(0.0, 1.0, 0.01) = 0.0;
uniform float r_mixer: hint_range(0.0, 1.0, 0.01) = 0.0;
uniform float g_mixer: hint_range(0.0, 1.0, 0.01) = 0.0;
uniform float b_mixer: hint_range(0.0, 1.0, 0.01) = 0.0;

void fragment() {
	vec4 input_color = texture(TEXTURE, UV);
	input_color.r = 0.0 + r_mixer;
	input_color.g = 0.0 + g_mixer;
	input_color.b = 0.0 + b_mixer;
	input_color.rgb = input_color.rgb + mixer;
	COLOR = input_color;
}

