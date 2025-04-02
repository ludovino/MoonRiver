shader_type canvas_item;

uniform sampler2D ripples;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 grad = textureGrad(ripples, SCREEN_UV, vec2(1., 0.), vec2(0., 1.));
	COLOR = texture(TEXTURE, UV + grad.xy);
	COLOR = grad;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
