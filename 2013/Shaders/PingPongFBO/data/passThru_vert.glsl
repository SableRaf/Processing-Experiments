// This shader simply passes the vertex position 
// and texture coordinate to the fragment shader

uniform mat4 transform;

attribute vec4 vertex;
attribute vec4 color;

varying vec4 vertColor;

//----------------------

varying vec4 vertTexCoord;

void main( void )
{
	vertTexCoord	= gl_MultiTexCoord0;
	gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
}
