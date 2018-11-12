#ifdef GL_ES
precision mediump float;
#endif
varying vec2 V_Texcoord;
uniform sampler2D U_Texture;
void main()
{
	float texelOffset=1/200.0;
	float weight[5]=float[](0.22,0.19,0.12,0.08,0.01);
	vec4 color=texture2D(U_Texture,V_Texcoord)*weight[0];
	for(int i=1;i<5;i++)
	{
		color+=texture2D(U_Texture,vec2(V_Texcoord.x,V_Texcoord.y+texelOffset*i))*weight[i];
		color+=texture2D(U_Texture,vec2(V_Texcoord.x,V_Texcoord.y-texelOffset*i))*weight[i];
	}
	gl_FragColor=color;
}