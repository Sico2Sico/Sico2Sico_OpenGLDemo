attribute vec3 pos;
attribute vec2 texcoord;
varying   vec2 V_Texcoord;

void main(){

    gl_PointSize = 100.0;
    V_Texcoord = texcoord;
    gl_Position = vec4(pos,1.0);

}
