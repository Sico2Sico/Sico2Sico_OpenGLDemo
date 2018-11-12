#ifdef GL_ES
precision mediump float;
#endif
uniform vec4 U_AmbientMaterial;
uniform vec4 U_AmbientLight;
void main()
{
	gl_FragColor=U_AmbientMaterial*U_AmbientLight;
}