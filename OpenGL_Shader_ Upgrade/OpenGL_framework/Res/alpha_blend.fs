#ifdef GL_ES
precision mediump float;
#endif
varying vec2 V_Texcoord;
uniform sampler2D U_Texture1;
uniform sampler2D U_Texture2;
void main()
{
	gl_FragColor=texture2D(U_Texture1,V_Texcoord)*0.5+texture2D(U_Texture2,V_Texcoord)*0.5;
}