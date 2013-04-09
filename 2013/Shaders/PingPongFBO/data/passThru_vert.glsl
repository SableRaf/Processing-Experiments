// This shader simply passes the vertex position 
// and texture coordinate to the fragment shader

uniform mat4 transform;

attribute vec4 vertex;
attribute vec4 color;

varying vec4 vertColor;

//----------------------

varying vec2 uv;

void main( void )
{
	uv			= gl_MultiTexCoord0.st;
	gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
}
