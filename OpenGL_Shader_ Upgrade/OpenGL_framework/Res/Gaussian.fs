#ifdef GL_ES
precision mediump float;
#endif
varying vec2 V_Texcoord;
uniform sampler2D U_Texture;
void main()
{
	vec4 color=vec4(0.0);
	int coreSize=3;
	float texelOffset=1/200.0;
	float kernel[9];
	kernel[6]=1;kernel[7]=2;kernel[8]=1;
	kernel[3]=2;kernel[4]=4;kernel[5]=2;
	kernel[0]=1;kernel[1]=2;kernel[2]=1;
	int index=0;
	for(int y=0;y<coreSize;y++)
	{
		for(int x=0;x<coreSize;x++)
		{
			vec4 currentColor=texture2D(U_Texture,V_Texcoord+vec2((-1+x)*texelOffset,(-1+y)*texelOffset));
			color+=currentColor*kernel[index++];
		}
	}
	color/=16.0;
	gl_FragColor=color;
}