# version 330 core

//Global variables
uniform float time;
uniform int colorMode = 1;
uniform int numb = 200;
uniform float enhanceFactor = 10;
uniform float speed;
uniform vec2 resolution;

in vec3 normals;
in vec3 position;
out vec4 FragColor;  

//Lightning model according to the Phong lighting model
float ambientStrength = 0.8;
float specularStrength = 0.1;

vec3 objectColor = vec3(0.1f, 0.1f, 0.1f);
vec3 lightColor = vec3(0.9f, 0.9f, 0.9f);
vec3 lightDirection = vec3(-0.2, -0.1, 1);

//Generate 2 somewhat random numbers
vec2 random2( vec2 p, float i ) {
    return fract(sin(vec2(dot(p,vec2(15.2,i)),dot(p,vec2(26,18))))*4785.3);
}

//Generate pseudo random numbers, following "The book of Shaders"
float random(vec2 st) {
    return fract(sin(dot(st.xy,vec2(12.9898,78.233)))*43758.5453123);
}

void main()
{
    //Light model
    
    //Ambient lightning
	vec3 Ia = ambientStrength*lightColor;

	//Diffuse color
	vec3 norm = normalize(normals);
	vec3 lightDir = normalize(lightDirection - position);
	float diff = max(dot(norm, lightDir), 0.0);
	vec3 Id = diff*lightColor; //Light model

    //Specular lighting
	vec3 viewDir = normalize(lightDirection - position);
	vec3 reflectDir = max(reflect(-lightDir, norm), 0.0);
	float spec = pow(max(dot(viewDir, reflectDir), 0.0), 4);
	vec3 Is = 3*specularStrength * spec * lightColor;

	//Get the coord. position on the window
    vec2 thePosition = gl_FragCoord.xy/resolution.xy;

	//Set the backgroundcolor
	vec3 color = vec3(0);

	//Set the output color
    FragColor = (1.5*vec4(Ia, 1.0) + 10*vec4(Id, 1.0) + 0.7*vec4(Is, 1.0))*vec4(objectColor, 1.0);
}

