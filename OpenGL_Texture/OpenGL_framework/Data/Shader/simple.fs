precision mediump float;

uniform vec4 U_Color;
uniform sampler2D U_MainTexture;
varying vec2 V_Texcoord;

void main(){

    gl_FragColor = U_Color*texture2D(U_MainTexture,V_Texcoord);
}
