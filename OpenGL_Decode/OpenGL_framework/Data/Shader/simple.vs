attribute vec3 pos;
attribute vec2 texcoord;

uniform mat4 M;
uniform mat4 V;
uniform mat4 P;
varying vec2 V_Texcoord;


void main(){

    gl_Position = vec4(pos,1.0);

}
