shader_type canvas_item;
uniform sampler2D scrolling_tex;
uniform vec2 scrolling_speed;
uniform float speed_mod;
void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 offset = texture(scrolling_tex, fract(UV + sin(TIME * scrolling_speed * speed_mod))).xy;
	vec4 tex = texture(TEXTURE, UV + (offset - 0.5) * 0.1);
	COLOR = tex;
}
