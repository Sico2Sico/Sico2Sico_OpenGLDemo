#ifdef GL_ES
precision mediump float;
#endif
uniform vec4 U_AmbientMaterial;
uniform vec4 U_DiffuseMaterial;
uniform vec4 U_AmbientLight;
uniform vec4 U_LightPos;
uniform vec4 U_DiffuseLight;
varying vec4 V_Normal;
void main()
{
	vec3 L=U_LightPos.xyz;
	L=normalize(L);
	vec3 n=normalize(V_Normal.xyz);
	float diffuseIntensity=max(0.0,dot(L,n));
	vec4 diffuseColor=U_DiffuseLight*U_DiffuseMaterial*diffuseIntensity;
	gl_FragColor=U_AmbientMaterial*U_AmbientLight+diffuseColor;
}