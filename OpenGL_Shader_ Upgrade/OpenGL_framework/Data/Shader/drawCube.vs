attribute vec3 pos;
uniform mat4 M;
uniform mat4 V;
uniform mat4 P;
varying vec4 V_Color;

void main()
{
    V_Color=vec4(pos+vec3(0.5),1.0);
    gl_Position=P*V*M*vec4(pos,1.0);
}
