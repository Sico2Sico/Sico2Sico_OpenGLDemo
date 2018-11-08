attribute vec3 pos;
attribute vec3 color;

uniform mat4 M;
uniform mat4 V;
uniform mat4 P;
varying vec3 V_Color;

void main()
{
    gl_PointSize=100.0;
    V_Color=color;
    gl_Position=P*V*M*vec4(pos,1.0);
}
