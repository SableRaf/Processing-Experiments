#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D movieFrame;
uniform vec2 resolution;

void main() {  

	gl_FragColor = vec4(texture2D( movieFrame, gl_FragPosition/resolution ));

}