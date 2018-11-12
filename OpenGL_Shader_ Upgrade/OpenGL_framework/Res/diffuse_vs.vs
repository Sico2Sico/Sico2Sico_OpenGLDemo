#ifdef GL_ES
precision mediump float;
#endif
attribute vec4 position;
attribute vec4 texcoord;
attribute vec4 normal;
uniform mat4 ModelMatrix;
uniform mat4 ViewMatrix;
uniform mat4 ProjectionMatrix;
uniform mat4 IT_ModelMatrix;
uniform vec4 U_AmbientMaterial;
uniform vec4 U_DiffuseMaterial;
uniform vec4 U_AmbientLight;
uniform vec4 U_LightPos;
uniform vec4 U_DiffuseLight;
varying vec4 V_Color;
void main()
{
	vec3 L=U_LightPos.xyz;
	L=normalize(L);
	vec3 n=normalize((IT_ModelMatrix*normal).xyz);
	float diffuseIntensity=max(0.0,dot(L,n));
	vec4 diffuseColor=U_DiffuseLight*U_DiffuseMaterial*diffuseIntensity;
	V_Color=U_AmbientMaterial*U_AmbientLight+diffuseColor;
	gl_Position=ProjectionMatrix*ViewMatrix*ModelMatrix*position;
}