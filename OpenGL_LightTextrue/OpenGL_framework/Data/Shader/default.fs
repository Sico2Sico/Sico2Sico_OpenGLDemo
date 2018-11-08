precision mediump float;
uniform sampler2D U_MainTexture;

varying vec3 V_Normal;
varying vec4 V_WorldPos;
varying vec2 V_Texcoord;

void main()
{
    vec4 ambientLight = vec4(0.4,0.4,0.4,0.1);
    vec4 ambienrMaterial = vec4(0.4,0.4,0.4,0.1);
    vec4 diffuseLight = vec4(1.0,1.0,1.0,1.0);
    vec4 diffuseMaterial = vec4(0.4,0.4,0.4,0.1);
    vec4 specularLight = vec4(0.1);
    vec4 specularLightMaterial = vec4(0.1);
    vec4 ambientColor = ambientLight*ambienrMaterial;

    vec3 L = vec3(1.0);
    L = normalize(L);

    vec3 n = normalize(V_Normal);
    float diffuseInterensity = max(0.0,dot(L,n));

    vec4 diffuseColor = diffuseLight*diffuseMaterial*diffuseInterensity*texture2D(U_MainTexture,V_Texcoord);

    vec3 refletDir = reflect(-L,n);
    refletDir = normalize(refletDir);

    vec3 viewDir = vec3(0.0)-V_WorldPos.xyz;
    viewDir = normalize(viewDir);

    float shinese = 128.0;
    vec4 specularColor = specularLight*specularLightMaterial*pow(max(0.0,dot(viewDir,refletDir)),shinese);

    gl_FragColor = ambientColor + diffuseColor + specularColor;
}
