precision mediump float;
uniform vec4 U_Color;
uniform sampler2D U_MainTexture;
varying vec4 V_Color;

void main()
{
    gl_FragColor=V_Color;
}
