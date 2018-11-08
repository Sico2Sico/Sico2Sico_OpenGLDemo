precision mediump float;

uniform vec4 U_Color;
uniform sampler2D U_MainTexture;
varying vec2 V_Texcoord;

void main(){
    float r = length(gl_PointCoord.xy -vec2(0.5));
    if (r > 0.5) {
        discard;
    }
    gl_FragColor = U_Color*texture2D(U_MainTexture,V_Texcoord);
}
