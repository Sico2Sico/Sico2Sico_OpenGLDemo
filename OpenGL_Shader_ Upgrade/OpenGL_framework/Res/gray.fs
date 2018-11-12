#ifdef GL_ES
precision mediump float;
#endif
varying vec2 V_Texcoord;
uniform sampler2D U_Texture;
void main()
{
	vec4 color=texture2D(U_Texture,V_Texcoord);
	float gray=(color.r+color.g+color.b)/3.0;
	gl_FragColor=vec4(gray,gray,gray,1.0);
}
