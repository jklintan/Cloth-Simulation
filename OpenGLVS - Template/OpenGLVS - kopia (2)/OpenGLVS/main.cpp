/* Josefine Klintberg, OpenGL template */

#include <iostream>
#include <cmath>
#include <vector>

//Include GLEW
#define GLEW_STATIC
#include <C:/Users/MeckBook/Documents/!TNM085/Cloth-Simulation/OpenGLVS - Template/External resources/GLEW/include/GL/glew.h>

//Include GLFW, define for being able to use glad
#define GLFW_INCLUDE_NONE
#include <C:/Users/MeckBook/Documents/!TNM085/Cloth-Simulation/OpenGLVS - Template/External resources/GLFW/include/GLFW/glfw3.h>

//Include header files
#include "Shader.hpp"
#include "MatrixStack.hpp"
#include "Utilities.hpp"
#include "TriangleSoup.hpp"
#include "Texture.hpp"
#include "Rotator.hpp"

#ifndef M_PI
#define M_PI (3.141592653589793)
#endif

//Math
#include <cmath>

//Window dimensions
const GLuint WIDTH = 800, HEIGHT = 800;

using namespace std;

int main() {

	//Declaration of variables
	float  time;
	GLint  location_time, location_object, location_light, location_view;
	GLfloat modelview, projection;
	MatrixStack myStack; //Stack used for transformations
	TriangleSoup Box, Sphere, Teapot, Trex;
	float PM[16] = { 0 }; //Initialize projection matrix
	Texture Text1, trexTex, earthTexture, lightTex, displacement;
	GLint location_tex;
	KeyRotator myKeyRotator;
	MouseRotator myMouseRotator;
	float light[16] = { 1 };

	// Init GLFW
	glfwInit();

	// Set all the required options for GLFW, make sure to use correct version
	glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
	glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
	glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
	glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);

	glfwWindowHint(GLFW_RESIZABLE, GL_FALSE);

	// Create a window
	GLFWwindow *window = glfwCreateWindow(WIDTH, HEIGHT, "OpenGL", nullptr, nullptr);

	int screenWidth, screenHeight;

	// Handles framebuffer resize callbacks
	glfwGetFramebufferSize(window, &screenWidth, &screenHeight);

	// If we couldn't initialize the window
	if (nullptr == window) {
		cout << "Failed to create GLFW window" << std::endl;
		glfwTerminate();
		return EXIT_FAILURE;
	}

	//Set the window to be the current context
	glfwMakeContextCurrent(window);

	// Set this to true so GLEW knows to use a modern approach to retrieving function pointers and extensions
	glewExperimental = GL_TRUE;

	// Initialize GLEW to setup the OpenGL Function pointers
	if (GLEW_OK != glewInit()) {
		cout << "Failed to initialize GLEW" << endl;
		return EXIT_FAILURE;
	}

	// Define the viewport dimensions
	glViewport(0, 0, screenWidth, screenHeight);

	/* <---------------------- Compilation of Shaders ----------------------> */

	Shader lightningShader("vertex.glsl", "fragment.glsl");
	//Shader textureShader("vertex.glsl", "fragmentTex.glsl");

	/* <--------------- Vertex, index and transformation data ---------------> */

	//Is now done inside the triangle Soup class

	/* <---------------------- Create and send vertex data and buffer objects ----------------------> */

	//Is now done inside the triangle Soup class for objects

	/* <---------------------- Shader variables ----------------------> */

	location_object = glGetUniformLocation(lightningShader.ID, "model");

	location_view = glGetUniformLocation(lightningShader.ID, "view");

	location_light = glGetUniformLocation(lightningShader.ID, "lightP");

	location_time = glGetUniformLocation(lightningShader.ID, "time"); if (location_time == -1) {
		cout << "Unable  to  locate  variable 'time' in  shader!" << endl;
	}

	projection = glGetUniformLocation(lightningShader.ID, "projection");
	//glUniformMatrix4fv(projection, 1, GL_FALSE, projection.glLoadIdentity()); //Replace the current matrix with identity matrix

	//Note, we use the upper 3x3 of the MV matrix as normal matrix

	/* <---------------------- Texture handling ----------------------> */

	// Locate the sampler2D uniform in the shader program
	location_tex = glGetUniformLocation(lightningShader.ID, "ourTexture");
	// Generate one texture object with data from a TGA file
	Text1.createTexture("textures/crate.tga");
	trexTex.createTexture("textures/trex.tga");
	earthTexture.createTexture("textures/earth.tga");
	lightTex.createTexture("textures/light.tga");
	displacement.createTexture("textures/displ.tga");

	/* <---------------------- Create objects ----------------------> */

	// Intialize the matrix to an identity transformation
	myStack.init();

	Sphere.createSphere(0.2, 10);
	Box.createBox(0.5, 0.5, 0.5);
	Teapot.readOBJ("./meshes/teapot.obj");
	Trex.readOBJ("./meshes/trex.obj");

	int angle = M_PI / 180;
	int angle2 = M_PI / 180;

	// Rendering loop
	while (!glfwWindowShouldClose(window))
	{

		//myKeyRotator.init(window);
		//myMouseRotator.init(window);

		/* <--- Rendering loop ---> */

		//myKeyRotator.poll(window);
		//myMouseRotator.poll(window);


		//	Update time
		time = (float)glfwGetTime();
		glUseProgram(lightningShader.ID); //  Activate the shader to set its variables
		glUniform1f(location_time, time); // Copy  the  value to the shader program

		GLuint loc = glGetUniformLocation(lightningShader.ID, "light");
		glUniform3fv(loc, sizeof(loc), (float*)loc);

		//// Clear the colorbuffer & Setup depth buffer
		glEnable(GL_DEPTH_TEST);
		glDepthFunc(GL_LESS);
		glClearColor(0.0f, 0.0f, 0.0f, 0.0f); //Set clear color, background
		glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
		//glClear(GL_COLOR_BUFFER_BIT);

		glEnable(GL_CULL_FACE); //Enable back face culling
		glCullFace(GL_BACK);
		//glPolygonMode(GL_FRONT_AND_BACK, GL_LINE); //Set to wireframe mode

		//Bind textures
		glActiveTexture(GL_TEXTURE0);
		glBindTexture(GL_TEXTURE_2D, Text1.textureID);

		//// Drawing
		lightningShader.use();
		glBindTexture(GL_TEXTURE_2D, 0);


		//Start the stack operations, draw the scene with transformation
		myStack.push();

		// The view transformations, world frame
		myStack.translate(0, -0.2, -1);
		myStack.rotX(M_PI / 20);

		glUniformMatrix4fv(location_view, 1, GL_FALSE, myStack.getCurrentMatrix());
		//myStack.translate(0.5, -0.2, -0.5); //Trex

		
		myStack.push();
			
			//if (glfwGetKey(window, GLFW_KEY_D)) {
			//	myStack.rotY(time*40 * M_PI / 180);
			//	glUniformMatrix4fv(location_light, 1, GL_FALSE, myStack.getCurrentMatrix());
			//}
			//if (glfwGetKey(window, GLFW_KEY_A)) {
			//	myStack.rotY(-time*40* M_PI/180);
			//	glUniformMatrix4fv(location_light, 1, GL_FALSE, myStack.getCurrentMatrix());
			//}
			//if (glfwGetKey(window, GLFW_KEY_S)) {
			//	myStack.rotX(time * 40 * M_PI / 180);
			//	glUniformMatrix4fv(location_light, 1, GL_FALSE, myStack.getCurrentMatrix());
			//}
			//if (glfwGetKey(window, GLFW_KEY_W)) {
			//	myStack.rotX(-time * 40 * M_PI / 180);
			//	glUniformMatrix4fv(location_light, 1, GL_FALSE, myStack.getCurrentMatrix());
			//}

			//Initialize position for light position
			myStack.translate(0, 0, 2);

			//Show the light transformations with different objects
			
			//Box
			glBindTexture(GL_TEXTURE_2D, Text1.textureID);
			Box.render();
			
			//T-rex
			//glBindTexture(GL_TEXTURE_2D, trexTex.textureID);
			//Trex.render();

			glUniformMatrix4fv(location_object, 1, GL_FALSE, myStack.getCurrentMatrix());
		myStack.pop();


		//glUniform3dv(location_light, light.size(), reinterpret_cast<GLdouble *>(light.data()));

		
		myStack.push();

		// Update the transformation matrix in the shader
		//glUniformMatrix4fv(location_object, 1, GL_FALSE, myStack.getCurrentMatrix());

		//if (glfwGetKey(window, GLFW_KEY_RIGHT)) {
		//	myStack.rotY(time*40*M_PI/180);
		//	//myStack.rotZ(time*50*M_PI/180);
		//}
		//if (glfwGetKey(window, GLFW_KEY_LEFT)){
		//	myStack.rotY(-time / 10 * myKeyRotator.phi);
		//	//myStack.rotZ(time / 10 * myKeyRotator.phi);
		//}
		//if (glfwGetKey(window, GLFW_KEY_DOWN)) {
		//	myStack.rotX(time*40*M_PI/180);
		//}
		//if (glfwGetKey(window, GLFW_KEY_UP)) {
		//	myStack.rotX(-time * 40 * M_PI / 180);
		//}

		
		glBindTexture(GL_TEXTURE_2D, lightTex.textureID);
		
		//Render light source
		//Sphere.render();

		glUniformMatrix4fv(location_object, 1, GL_FALSE, myStack.getCurrentMatrix());


		myStack.pop();
		
		//Earth floating around t-rex

		////Center object
		//myStack.push();
		//	myStack.translate(-1.4, 0, 0.2);
		//	myStack.scale(0.6); //Scale to fit screen
		//	myStack.rotY(M_PI/7); //Scale to fit screen

		//	// Update the transformation matrix in the shader
		//	glUniformMatrix4fv(location_object, 1, GL_FALSE, myStack.getCurrentMatrix());
		//	glUniformMatrix4fv(location_view, 1, GL_FALSE, myStack.getCurrentMatrix());
		//	
		//	glBindTexture(GL_TEXTURE_2D, trexTex.textureID);
		//	Trex.render();
		//myStack.pop();

		//myStack.translate(1.0, 0, 0);
		////Orbiting object
		//myStack.push();
		//	myStack.translate(-3, 0, 0);
		//	myStack.rotY(time*M_PI / 12);
		//	myStack.scale(0.5);

		//	// Update the transformation matrix in the shader
		//	glUniformMatrix4fv(location_object, 1, GL_FALSE, myStack.getCurrentMatrix());
		//	glUniformMatrix4fv(location_view, 1, GL_FALSE, myStack.getCurrentMatrix());

		//	glBindTexture(GL_TEXTURE_2D, earthTexture.textureID);
		//	Sphere.render();
		//myStack.pop();

		//Perform the perspective projection
		myStack.translate(0, 0, -2);
		myStack.mat4perspective(PM, M_PI / 4, 1, 0.5, 10); //Turns PM into the correct projection matrix and multiply to current matrix
		glUniformMatrix4fv(projection, 1, GL_FALSE, PM); //Send the projection matrix to the vertex shader




	//Restore the initial matrix
		myStack.pop();

		// Check key press event
		glfwPollEvents();

		glUseProgram(0);

		// Swap the screen buffers
		glfwSwapBuffers(window);
	}

	// Terminate GLFW, clearing any resources allocated by GLFW.
	glfwTerminate();

	return EXIT_SUCCESS;
}

