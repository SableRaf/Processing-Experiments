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

uniform int     iFrameRate;

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

void mainImage( out vec4 fragColor, in vec2 fragCoord );

void main() {
    mainImage(gl_FragColor,gl_FragCoord.xy);
}



// ------------------------------
//  SHADERTOY CODE BEGINS HERE  -
// ------------------------------


// Created by inigo quilez - iq/2016
// License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.


// See also:
//
// Input - Keyboard    : https://www.shadertoy.com/view/lsXGzf
// Input - Microphone  : https://www.shadertoy.com/view/llSGDh
// Input - Mouse       : https://www.shadertoy.com/view/Mss3zH
// Input - Sound       : https://www.shadertoy.com/view/Xds3Rr
// Input - SoundCloud  : https://www.shadertoy.com/view/MsdGzn
// Input - Time        : https://www.shadertoy.com/view/lsXGz8
// Input - TimeDelta   : https://www.shadertoy.com/view/lsKGWV
// Inout - 3D Texture  : https://www.shadertoy.com/view/4llcR4


float udRoundBox( vec2 p, vec2 b, float r )
{
  return length(max(abs(p)-b,0.0))-r;
}

float sdBox( vec2 p, vec2 b )
{
  vec2 d = abs(p) - b;
  return min(max(d.x,d.y),0.0) + length(max(d,0.0));
}


//-----------------------------------------------------------------
// Digit drawing function by P_Malin (https://www.shadertoy.com/view/4sf3RN)

float SampleDigit(const in float n, const in vec2 vUV)
{
	if(vUV.x  < 0.0) return 0.0;
	if(vUV.y  < 0.0) return 0.0;
	if(vUV.x >= 1.0) return 0.0;
	if(vUV.y >= 1.0) return 0.0;

	float data = 0.0;

	     if(n < 0.5) data = 7.0 + 5.0*16.0 + 5.0*256.0 + 5.0*4096.0 + 7.0*65536.0;
	else if(n < 1.5) data = 2.0 + 2.0*16.0 + 2.0*256.0 + 2.0*4096.0 + 2.0*65536.0;
	else if(n < 2.5) data = 7.0 + 1.0*16.0 + 7.0*256.0 + 4.0*4096.0 + 7.0*65536.0;
	else if(n < 3.5) data = 7.0 + 4.0*16.0 + 7.0*256.0 + 4.0*4096.0 + 7.0*65536.0;
	else if(n < 4.5) data = 4.0 + 7.0*16.0 + 5.0*256.0 + 1.0*4096.0 + 1.0*65536.0;
	else if(n < 5.5) data = 7.0 + 4.0*16.0 + 7.0*256.0 + 1.0*4096.0 + 7.0*65536.0;
	else if(n < 6.5) data = 7.0 + 5.0*16.0 + 7.0*256.0 + 1.0*4096.0 + 7.0*65536.0;
	else if(n < 7.5) data = 4.0 + 4.0*16.0 + 4.0*256.0 + 4.0*4096.0 + 7.0*65536.0;
	else if(n < 8.5) data = 7.0 + 5.0*16.0 + 7.0*256.0 + 5.0*4096.0 + 7.0*65536.0;
	else if(n < 9.5) data = 7.0 + 4.0*16.0 + 7.0*256.0 + 5.0*4096.0 + 7.0*65536.0;

	vec2 vPixel = floor(vUV * vec2(4.0, 5.0));
	float fIndex = vPixel.x + (vPixel.y * 4.0);

	return mod(floor(data / pow(2.0, fIndex)), 2.0);
}

float PrintInt(const in vec2 uv, const in float value )
{
	float res = 0.0;
	float maxDigits = 1.0+ceil(log2(value)/log2(10.0));
	float digitID = floor(uv.x);
	if( digitID>0.0 && digitID<maxDigits )
	{
        float digitVa = mod( floor( value/pow(10.0,maxDigits-1.0-digitID) ), 10.0 );
        res = SampleDigit( digitVa, vec2(fract(uv.x), uv.y) );
	}

	return res;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    float px = 1.0 / iResolution.y;
    vec2 uv = fragCoord*px;

    // 1.0/iTimeDelta as an integer
    float col = PrintInt( (uv-vec2(0.2,0.5))*10.0, floor( 1.0/iTimeDelta + 0.5) );

    // fps as an integer
    col += PrintInt( (uv-vec2(0.2,0.75))*10.0, iFrameRate );

    // odd/even frame box
    col += (1.0-smoothstep( 0.0, px, udRoundBox( uv-vec2(0.4,0.2), vec2(0.1), 0.05  ))) *
            step( abs(fract(0.5*float(iFrame))-0.5), 0.1 );

    // iTimeDelta as vertical bar
    col += (1.0-smoothstep( 0.0, px, sdBox( uv-vec2(0.1,0.0), vec2(0.02,60.0*iTimeDelta) )));

	fragColor = vec4(col,col,col,1.0);
}


// ----------------------------
//  SHADERTOY CODE ENDS HERE  -
// ----------------------------
