// Blend mode: Color

// Original "Photoshop Blends" shader by ben
// https://www.shadertoy.com/view/XdS3RW 

// Compositing formulas from http://www.w3.org/TR/compositing-1

// Port by Raphaël de Courville <twitter: @sableRaph>

/*******************************

For simplicity, we only use source-over compositing
For information about the other Porter-Duff modes, 
see: http://www.w3.org/TR/compositing-1/#porterduffcompositingoperators_srcover

Apply the mixing function

	Cm = B(Cb, Cs)

Apply the blend in place

	Cs = (1 - αb) * Cs + αb * Cm

Composite

	Co = αs x Cs + αb x Cb x (1 – αs)
	αo = αs + αb x (1 – αs)


Where:
	Cs: is the color of the source
	Cb: is the color of the backdrop
	αs: is the alpha of the source
	αb: is the alpha of the backdrop
	Co: is the color of the output
	αo: is the coverage of the output
	B(Cb, Cs): is the mixing function

********************************/


#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

// viewport resolution (in pixels)
uniform vec2  sketchSize;      

// Textures to blend
uniform sampler2D sourceImage; 
uniform sampler2D backdropImage; 

// Resolution of the textures
uniform vec2 sourceImageResolution;
uniform vec2 backdropImageResolution;

//	rgb<-->hsv functions by Sam Hocevar
//	http://lolengine.net/blog/2013/07/27/rgb-to-hsv-in-glsl
vec3 rgb2hsv(vec3 c)
{
	vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
	vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
	vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));
	
	float d = q.x - min(q.w, q.y);
	float e = 1.0e-10;
	return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 hsv2rgb(vec3 c)
{
	vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
	vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
	return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

// Mixing function
vec3 mixing(vec3 b, vec3 s) {
	s = rgb2hsv(s);
	s.z = rgb2hsv(b).z;
	return hsv2rgb(s);
}


void main(void)
{
	vec2 uv = gl_FragCoord.xy / sketchSize.xy * vec2(1.0,-1.0) + vec2(0.0, 1.0);
	
	// Sample the source texture (upper layer) note: y axis is mirrored because of Processing's inverted coordinate system
	vec2 sPos = vec2( gl_FragCoord.x / sourceImageResolution.x, 1.0 - (gl_FragCoord.y / sourceImageResolution.y) );
	vec4 s = texture2D(sourceImage, sPos ).rgba;

	
	// Sample the backdrop texture (lower layer) note: y axis is mirrored because of Processing's inverted coordinate system
    vec2 bPos = vec2( gl_FragCoord.x / backdropImageResolution.x, 1.0 - (gl_FragCoord.y / backdropImageResolution.y) );
	vec4 b = texture2D(backdropImage, bPos ).rgba;
	vec3  bColor = b.rgb;
	float bAlpha = b.a;

	// Step 1: Mixing 
	vec3 mix = mixing(b.rgb, s.rgb);

	// Step 2: Blending 
	vec3 blend = (1.0 - b.a) * s.rgb + b.a * mix;

	// Step 3: Compositing ("Source Over")
	vec3 composite = s.a * blend + b.a * b.rgb * (1.0 - s.a);

	// Step 4: Coverage
	float coverage = s.a + b.a * (1.0 - s.a);

	// Limit values to the [0.0,1.0] range
	vec4 pixelColor = vec4( clamp( composite, 0.0, 1.0 ), clamp( coverage, 0.0, 1.0 ) );

	// Apply to the fragment
	gl_FragColor = pixelColor;
}
