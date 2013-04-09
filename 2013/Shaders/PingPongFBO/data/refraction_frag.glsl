
#ifdef GL_ES
precision highp float;
#endif

// Type of shader expected by Processing
#define PROCESSING_COLOR_SHADER

// Processing specific input
uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;

//-------------------------------------------------------------------------------

uniform sampler2D	buffer; // Data texture
uniform vec2		pixel;	// Size of a pixel in [0,0]-[1,0]
uniform sampler2D	tex;	// Refraction texture (the image to be warped)

varying vec2		uv;		// Texture coordinate


void main( void )
{
	// Calculate refraction
	vec2 above		= texture2D( buffer, uv + vec2( 0.0, -pixel.y ) ).rg;
	float x			= above.g - texture2D( buffer, uv + vec2( pixel.x, 0.0 ) ).g;
	float y			= above.r - texture2D( buffer, uv + vec2( 0.0, pixel.y ) ).r;

	// Sample the texture from the target position
	gl_FragColor	= texture2D( tex, uv + vec2( x, y ) );

	// DEBUG!!!! 
	vec2 pos = gl_FragCoord.xy / resolution.xy;
	gl_FragColor = vec4(pos,0.5+0.5*sin(time),1.0); // This should be displayed and is not...
}
