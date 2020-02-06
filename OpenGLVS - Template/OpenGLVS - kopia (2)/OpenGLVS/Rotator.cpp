#include "Rotator.hpp"

void KeyRotator::init(GLFWwindow *window) {
     phi = 0.0;
     theta = 0.0;
     lastTime = glfwGetTime();
};

void KeyRotator::poll(GLFWwindow *window) {

	double currentTime, elapsedTime;

	currentTime = glfwGetTime();
	elapsedTime = currentTime - lastTime;
	lastTime = currentTime;

	if(glfwGetKey(window, GLFW_KEY_RIGHT)) {
		phi += elapsedTime*M_PI/2.0; // Rotate 90 degrees per second (pi/2)
		phi = fmod(phi, M_PI*2.0); // Wrap around at 360 degrees (2*pi)
	}

	if(glfwGetKey(window, GLFW_KEY_LEFT)) {
		phi -= elapsedTime*M_PI/2.0; // Rotate 90 degrees per second (pi/2)
		phi = fmod(phi, M_PI*2.0);
		if (phi < 0.0) phi += M_PI*2.0; // If phi<0, then fmod(phi,2*pi)<0
	}

	if(glfwGetKey(window, GLFW_KEY_UP)) {
		theta += elapsedTime*M_PI/2.0; // Rotate 90 degrees per second
		if (theta >= M_PI/2.0) theta = M_PI/2.0; // Clamp at 90
	}

	if(glfwGetKey(window, GLFW_KEY_DOWN)) {
		theta -= elapsedTime*M_PI/2.0; // Rotate 90 degrees per second
		if (theta < -M_PI/2.0) theta = -M_PI/2.0;      // Clamp at -90
	}
}


void MouseRotator::init(GLFWwindow *window) {
    phi = 0.0;
    theta = 0.0;
    glfwGetCursorPos(window, &lastX, &lastY);
	lastLeft = GL_FALSE;
	lastRight = GL_FALSE;
}

void MouseRotator::poll(GLFWwindow *window) {

  double currentX;
  double currentY;
  int currentLeft;
  int currentRight;
  double moveX;
  double moveY;
  int windowWidth;
  int windowHeight;

  // Find out where the mouse pointer is, and which buttons are pressed
  glfwGetCursorPos(window, &currentX, &currentY);
  currentLeft = glfwGetMouseButton(window, GLFW_MOUSE_BUTTON_LEFT);
  currentRight = glfwGetMouseButton(window, GLFW_MOUSE_BUTTON_RIGHT);
  glfwGetWindowSize( window, &windowWidth, &windowHeight );

  if(currentLeft && lastLeft) { // If a left button drag is in progress
    moveX = currentX - lastX;
    moveY = currentY - lastY;
  	phi += M_PI * moveX/windowWidth; // Longest drag rotates 180 degrees
	if (phi >= M_PI*2.0) phi = fmod(phi, M_PI*2.0);
	if (phi < 0.0) phi += M_PI*2.0; // If phi<0, then fmod(phi,2*pi)<0
  	theta += M_PI * moveY/windowHeight; // Longest drag rotates 180 deg
	if (theta >= M_PI/2.0) theta = M_PI/2.0;  // Clamp at 90
	if (theta < -M_PI/2.0) theta = -M_PI/2.0; // Clamp at -90
  }
  lastLeft = currentLeft;
  lastRight = currentRight;
  lastX = currentX;
  lastY = currentY;
}
