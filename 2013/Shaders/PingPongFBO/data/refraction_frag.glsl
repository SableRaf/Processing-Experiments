#ifdef GL_ES
precision highp float;
#endif

// Type of shader expected by Processing
#define PROCESSING_TEXTURE_SHADER

// Processing specific input
uniform sampler2D texture;
uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;

varying vec4 vertColor;
varying vec4 vertTexCoord;

//-------------------------------------------------------------------------------

uniform vec2		pixel;	// Size of a pixel in [0,0]-[1,0]
uniform sampler2D	tex;	// Refraction texture (the image to be warped)


void main( void )
{
	vec2 uv = vertTexCoord.st; // Texture coordinates

	// Calculate refraction
	vec2 above		= texture2D( texture, uv + vec2( 0.0, -pixel.y ) ).rg;
	float x			= above.g - texture2D( texture, uv + vec2( pixel.x, 0.0 ) ).g;
	float y			= above.r - texture2D( texture, uv + vec2( 0.0, pixel.y ) ).r;

	// Sample the texture from the target position
	gl_FragColor	= texture2D( tex, uv + vec2( x, y ) );

	// DEBUG!!!! 
	//vec2 pos = gl_FragCoord.xy / resolution.xy;
	//gl_FragColor = vec4(pos,0.5+0.5*sin(time),1.0); // This should be displayed and is not...
}
