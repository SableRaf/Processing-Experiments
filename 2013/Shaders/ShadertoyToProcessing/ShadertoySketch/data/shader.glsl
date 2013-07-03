#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_COLOR_SHADER

uniform vec2 iResolution;      // viewport resolution (in pixels)
uniform float iGlobalTime;     // shader playback time (in seconds)
uniform vec4 iMouse;           // mouse pixel coords. xy: current (if MLB down), zw: click


// not implemented yet

uniform float iChannelTime[4]; // channel playback time (in seconds)
uniform vec4 iDate;            // (year, month, day, time in seconds)


// Channels can be either 2D maps or Cubemaps. Pick the ones you need.

/*
uniform sampler2D iChannel0;
uniform sampler2D iChannel1;
uniform sampler2D iChannel2;
uniform sampler2D iChannel3;

uniform samplerCube iChannel0;
uniform samplerCube iChannel1;
uniform samplerCube iChannel2;
uniform samplerCube iChannel3;
*/


// -------- Below is the code you can directly paste back and forth from www.shadertoy.com---------

void main(void)
{
	vec2 uv = gl_FragCoord.xy / iResolution.xy;
	gl_FragColor = vec4(uv,0.5+0.5*sin(iGlobalTime),1.0);
}