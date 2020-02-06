# version 330 core

//Global variables
uniform float time;

//Lightning Model
in vec3 aNormal;
in vec2 st;
in vec3 fragPos;
out vec4 fragColor;  
in vec3 lightDirection;

//Lightning model according to the Phong lighting model
float ambientStrength = 0.4;
float specularStrength = 1;

vec3 objectColor = vec3(0.4f, 0.3f, 0.3f);
vec3 lightColor = vec3(1.0f, 1.0f, 1.0f);

//Texture
in vec2 TexCoord;
uniform sampler2D texture1;
uniform sampler2D texture2;

void main()
{
	//Ambient lightning
	vec3 Ia = ambientStrength*lightColor;

	//Diffuse color
	vec3 norm = normalize(aNormal);
	vec3 lightDir = normalize(lightDirection - fragPos);
	float diff = max(dot(norm, lightDir), 0.0);
	//vec3 Id = diff*lightColor; //Light model
	vec4 texturing = texture(texture1, TexCoord);
	vec3 Id = 3*vec3(texturing)*lightColor; //texture model

	//Specular lighting
	vec3 viewDir = normalize(lightDirection-fragPos);
	vec3 reflectDir = max(reflect(-lightDir, norm), 0.0);
	float spec = pow(max(dot(viewDir, reflectDir), 0.0), 16);
	vec3 Is = 10*specularStrength * spec * lightColor;

	vec3 result = (Ia+Id+Is)*objectColor;
	fragColor = vec4(result, 1.0);

	//Texturing
	//fragColor = mix(texture(texture1, TexCoord), texture(texture2, TexCoord), 0.2);
	//fragColor = texture(ourTexture, TexCoord);
}