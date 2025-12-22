shader_type spatial;
render_mode unshaded;

// Include the library, containing some shared functions.




// Uniforms.
// Their names should be pretty self-explanatory.

uniform vec3 color: source_color = vec3(1.0, 1.0, 1.0);

group_uniforms Texture;

	uniform bool useTexture = false;
	uniform sampler2D textureSource:
		source_color,
		hint_default_transparent,
		filter_linear_mipmap;

group_uniforms;

group_uniforms Debanding;
	
	uniform bool deband = true;
	uniform float debandDepth: hint_range(4.0, 256.0, 1.0) = 256.0;
	
group_uniforms;

// Used for blending colors for the gradients ONLY!
// This very simple mix, but allows for easy overwriting.
// Go nuts! This can make things look very stylish.
vec3 blendGradient(vec3 colA, vec3 colB, float amt) {
	
	return mix(colA, colB, amt);
	
	// A fun example of what changing this function can do:
	// return mix(colA, colB, sin((amt + TIME * 0.25) * TAU));
	
}

// Darker colors, especially on mobile screens, can make gradients look choppy.
// This is a simple dither-like algorithm used to 'deband' the final color.
// https://www.shadertoy.com/view/4dcSRX
vec3 valveDeband(vec2 screenUV, float colorDepth, float time) {
    vec3 dither = vec3(dot(vec2(131.0, 312.0), screenUV.xy + time));
    dither = fract(dither / vec3(103.0, 71.0, 97.0)) - vec3(0.5, 0.5, 0.5);
    return (dither / colorDepth) * 0.375;
}

// Functions

// The fragment (per-pixel) logic.
void fragment() {
	
	// We already know the color! ;)
	vec3 finalColor = color;
	
	// Add the texture if enabled.
	if (useTexture) {
		vec4 tex = texture(textureSource, UV);
		finalColor = mix(
			finalColor,
			tex.rgb,
			tex.a
		);
	}
	
	if (deband) {
		finalColor += valveDeband(FRAGCOORD.xy, debandDepth, TIME);
	}
	
	ALBEDO = finalColor * COLOR.rgb;
	
}