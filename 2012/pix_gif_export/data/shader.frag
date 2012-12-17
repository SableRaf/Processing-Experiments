#ifdef GL_ES
precision highp float;
#endif

// This is the interface between the sketch and the shader
// “Uniforms act as parameters that the user of a shader program
// can pass to that program”: http://www.opengl.org/wiki/Uniform_(GLSL)
uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;
uniform float side;
uniform float seed; // seed of the random function

// f will be used to store the color of the current fragment
vec4 f = vec4(1.,1.,1.,1.);

float rand(vec2 p)
{
 p+=.2127+p.x+.3713*p.y;
 vec2 r=4.789*sin(789.123*(p));
 return fract(r.x*r.y);
}

void main(void)
{    
 // c will contain the position information for the current fragment (from -1,-1 to 1,1)
 vec2 c = vec2 (-1.0 + 2.0 * gl_FragCoord.x / resolution.x, 1.0 - 2.0 * gl_FragCoord.y / resolution.y) ;

 // d is the position information for the current fragment, repeating from (0,0) to (side,side)
 vec2 d = vec2 (mod(gl_FragCoord.x,side), mod(gl_FragCoord.y, side));
 
 // mousepos will contain the current mouse position (from -1,-1 to 1,1)
 vec2 mousepos = -1.0 + 2.0 * mouse.xy / resolution.xy;
    
 float t = time;
    
 // define the color of the current pixel
 f=vec4(step(.5,rand(floor(vec2(resolution.xy)*d.xy)+seed)));
    
 // apply the color
 gl_FragColor = f;

}