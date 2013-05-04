



#ifdef GL_ES
precision highp float;
#endif

#define PROCESSING_TEXTURE_SHADER

uniform sampler2D texture;
uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;

varying vec4 vertColor;
varying vec4 vertTexCoord;

//-------------------------------------------------------------------------------

uniform vec2		pixel;						// Size of a pixel in [0,0]-[1,0]

const float			dampen	= 0.993;			// Ripple dampening
const float			power	= 1.5;				// Input power
const float			speed	=  1.0;				// Ripple travel speed

// Samples velocity from neighbor
float getSpring( float height, vec2 position, float factor ) 
{
	return ( texture2D( texture, position ).r - height ) * factor;
}

void main( void ) 
{
	vec2 uv = vertTexCoord.st; // Texture coordinates

	// Kernel size
	vec2 kernel		= pixel * speed;

	// Sample the color to get the height and velocity of this pixel
	vec4 color		= texture2D( texture, uv );
	float height	= color.r;
	float vel		= color.g;

	// Sample neighbors to update this pixel's velocity. Sampling inside of for() loops
	// is very slow, so we write it all out.
	vel				+= getSpring( height, uv + kernel * vec2(  2.0,  3.0 ), 0.0022411859348636983 * power );
	vel				+= getSpring( height, uv + kernel * vec2(  0.0,  3.0 ), 0.0056818181818181820 * power );
	vel				+= getSpring( height, uv + kernel * vec2( -2.0,  3.0 ), 0.0022411859348636983 * power );
	vel				+= getSpring( height, uv + kernel * vec2(  2.0,  2.0 ), 0.0066566640639421000 * power );
	vel				+= getSpring( height, uv + kernel * vec2(  0.0,  2.0 ), 0.0113636363636363640 * power );
	vel				+= getSpring( height, uv + kernel * vec2( -2.0,  2.0 ), 0.0066566640639421000 * power );
	vel				+= getSpring( height, uv + kernel * vec2(  3.0,  1.0 ), 0.0047597860217705710 * power );
	vel				+= getSpring( height, uv + kernel * vec2(  1.0,  1.0 ), 0.0146919683956074150 * power );
	vel				+= getSpring( height, uv + kernel * vec2( -1.0,  1.0 ), 0.0146919683956074150 * power );
	vel				+= getSpring( height, uv + kernel * vec2( -3.0,  1.0 ), 0.0047597860217705710 * power );
	vel				+= getSpring( height, uv + kernel * vec2(  2.0,  0.0 ), 0.0113636363636363640 * power );
	vel				+= getSpring( height, uv + kernel * vec2( -2.0,  0.0 ), 0.0113636363636363640 * power );
	vel				+= getSpring( height, uv + kernel * vec2(  3.0, -1.0 ), 0.0047597860217705710 * power );
	vel				+= getSpring( height, uv + kernel * vec2(  1.0, -1.0 ), 0.0146919683956074150 * power );
	vel				+= getSpring( height, uv + kernel * vec2( -1.0, -1.0 ), 0.0146919683956074150 * power );
	vel				+= getSpring( height, uv + kernel * vec2( -3.0, -1.0 ), 0.0047597860217705710 * power );
	vel				+= getSpring( height, uv + kernel * vec2(  2.0, -2.0 ), 0.0066566640639421000 * power );
	vel				+= getSpring( height, uv + kernel * vec2(  0.0, -2.0 ), 0.0113636363636363640 * power );
	vel				+= getSpring( height, uv + kernel * vec2( -2.0, -2.0 ), 0.0066566640639421000 * power );
	vel				+= getSpring( height, uv + kernel * vec2(  2.0, -3.0 ), 0.0022411859348636983 * power );
	vel				+= getSpring( height, uv + kernel * vec2(  0.0, -3.0 ), 0.0056818181818181820 * power );
	vel				+= getSpring( height, uv + kernel * vec2( -2.0, -3.0 ), 0.0022411859348636983 * power );

	// Update this pixel's height (red channel)
	height			+= vel;
	
	// Reduce the velocity
	vel				*= dampen;

	// Store the height and velocity in the red and green channels
	gl_FragColor	= vec4( height, vel, 0.0, 1.0 );
}
