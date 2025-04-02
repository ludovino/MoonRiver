// NOTE: Shader automatically converted from Godot Engine 3.5.3.stable's CanvasItemMaterial.

shader_type canvas_item;
render_mode blend_mix,unshaded;

uniform sampler2D grad;
uniform sampler2D radial_grad;
uniform sampler2D noise;
uniform float time_scale_1;
uniform float time_scale_2;
uniform float noise_time_scale;
uniform float noise_uv_scale;

void fragment() {
	vec4 col = texture(grad, UV);
	float t = TIME * 0.1;
	col.rgb -= 0.5 * texture(radial_grad, vec2(UV.x, UV.y + 0.5 - floor(UV.y + 0.5))).rgb;
	col.rgb += 0.5 * texture(radial_grad, vec2(UV.y, UV.x + 0.5 - floor(UV.x + 0.5))).rgb;
	col = col * (.53 + texture(noise, UV * vec2(.4, 1.0) - vec2(t, 0.0) - floor(t)));
	col = floor(col * 5.) * 0.2;
	col = clamp(col, 0.0, 1.0);
	col.a = col.r;
	//col = vec4(MODULATE.rgb, col.a);
	COLOR = COLOR * col.rgba;
}