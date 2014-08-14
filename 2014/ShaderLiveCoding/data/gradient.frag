
uniform vec2 vec2_sketchSize;
uniform vec2 vec2_mouse;

void main() {

  float r = gl_FragCoord.x / vec2_sketchSize.x;
  float g = gl_FragCoord.y / vec2_sketchSize.y;
  float b = vec2_mouse.x / vec2_sketchSize.x;
  float a = 1.0;

  gl_FragColor = vec4(r,g,b,a);
}