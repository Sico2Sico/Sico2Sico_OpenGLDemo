#ifdef GL_ES
precision mediump float;
#endif
varying vec2 V_Texcoord;
uniform sampler2D U_Texture1;
uniform sampler2D U_Texture2;
void main()
{
	vec4 baseColor=texture2D(U_Texture1,V_Texcoord);
	vec4 blendColor=texture2D(U_Texture2,V_Texcoord);
	gl_FragColor=vec4(vec3(1.0)-abs(vec3(1.0)-baseColor.rgb-blendColor.rgb),1.0);
}