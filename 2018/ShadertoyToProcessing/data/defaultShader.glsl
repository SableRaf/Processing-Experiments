#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

// From Processing 2.1 and up, this line is optional
#define PROCESSING_COLOR_SHADER

// if you are using the filter() function, replace the above with
// #define PROCESSING_TEXTURE_SHADER

// ----------------------
//  SHADERTOY UNIFORMS  -
// ----------------------

uniform vec3      iResolution;           // viewport resolution (in pixels)
uniform float     iTime;                 // shader playback time (in seconds) (replaces iGlobalTime which is now obsolete)
uniform float     iTimeDelta;            // render time (in seconds)
uniform int       iFrame;                // shader playback frame

uniform vec4      iMouse;                // mouse pixel coords. xy: current (if MLB down), zw: click
uniform vec4      iDate;                 // (year, month, day, time in seconds)

//uniform float     iChannelTime[2];
//uniform vec3      iChannelResolution[2];


// Channels can be either 2D maps or Cubemaps.
// Pick the ones you need and uncomment them.


// uniform float     iChannelTime[1..4];       // channel playback time (in seconds)
// uniform vec3      iChannelResolution[1..4]; // channel resolution (in pixels)

/*
uniform sampler2D iChannel0;
uniform sampler2D iChannel1;
uniform sampler2D iChannel2;
uniform sampler2D iChannel3;

uniform samplerCube iChannel0;
uniform samplerCube iChannel1;
uniform samplerCube iChannel2;
uniform samplerCube iChannel3;

uniform vec3  iChannelResolution[4]; // channel resolution (in pixels)

uniform float iChannelTime[4]; // Channel playback time (in seconds)
*/

vec4 fragColor;
vec2 fragCoord = gl_FragCoord.xy;

// ------------------------------
//  SHADERTOY CODE BEGINS HERE  -
// ------------------------------

// FOR PROCESSING: REPLACE 'void mainImage(...)' WITH 'void main(void)'
// void mainImage( out vec4 fragColor, in vec2 fragCoord )
void main(void)
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = fragCoord/iResolution.xy;

    // Time varying pixel color
    vec3 col = 0.5 + 0.5*cos(iTime+uv.xyx+vec3(0,2,4));

    // Output to screen
    fragColor = vec4(col,1.0);

		// FOR PROCESSING: ADD THIS LINE AT THE END OF THE mainImage() FUNCTION
		gl_FragColor = fragColor;
}

// ----------------------------
//  SHADERTOY CODE ENDS HERE  -
// ----------------------------
