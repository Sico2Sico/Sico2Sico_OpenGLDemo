#ifdef GL_ES
precision mediump float;
#endif
uniform sampler2D U_ShadowMap;
uniform vec4 U_AmbientMaterial;
uniform vec4 U_DiffuseMaterial;
uniform vec4 U_SpecularMaterial;
uniform vec4 U_AmbientLight;
uniform vec4 U_LightPos;
uniform vec4 U_DiffuseLight;
uniform vec4 U_SpecularLight;
uniform vec4 U_CameraPos;
varying vec4 V_Normal;
varying vec4 V_WorldPos;
varying vec4 V_LightSpaceFragPos;
float CalculateShadow()
{
	vec3 fragPos=V_LightSpaceFragPos.xyz/V_LightSpaceFragPos.w;
	fragPos=fragPos*0.5+vec3(0.5);
	float depthInShadowMap=texture2D(U_ShadowMap,fragPos.xy).r;
	float currentDepth=fragPos.z;
	vec2 texelSize=vec2(1.0/200.0,1.0/200.0);
	float shadow=0.0;
	for(int y=-1;y<1;++y)
	{
		for(int x=-1;x<1;++x)
		{
			float pcfDepth=texture2D(U_ShadowMap,fragPos.xy+texelSize*vec2(x,y)).r;
			shadow+=(currentDepth-0.001)>pcfDepth?1.0:0.0;
		}
	}
	shadow/=9.0;
	return shadow;
}
void main()
{
	vec3 L=vec3(0.0,0.0,0.0);
	vec3 n=normalize(V_Normal.xyz);
	float distance=0.0;
	float attenuation=1.0;
	float constantFactor=0.5;
	float linearFactor=0.3;
	float expFactor=0.1;
	L=U_LightPos.xyz-V_WorldPos.xyz;
	distance=length(L);
	attenuation=1.0/(constantFactor+linearFactor*distance+expFactor*distance*distance);
	L=normalize(L);
	float diffuseIntensity=max(0.0,dot(L,n));
	vec4 diffuseColor=U_DiffuseLight*U_DiffuseMaterial*diffuseIntensity;
	vec4 specularColor=vec4(0.0,0.0,0.0,0.0);
	if(diffuseIntensity>0.0){
		vec3 reflectDir=reflect(-L,n);
		reflectDir=normalize(reflectDir);
		vec3 worldPos=V_WorldPos.xyz;
		vec3 viewDir=normalize(U_CameraPos.xyz-worldPos);
		specularColor=U_SpecularLight*U_SpecularMaterial*pow(max(0.0,dot(viewDir,reflectDir)),4.0);
	}
	vec4 color=U_AmbientMaterial*U_AmbientLight+diffuseColor+specularColor;
	color=color*vec4(vec3(1.0-CalculateShadow()),1.0);
	gl_FragColor=color;
}