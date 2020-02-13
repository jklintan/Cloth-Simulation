#include <cmath>
#include <cstdlib>
#include <cstdio>
#include <GLFW/glfw3.h>

// A linked list implementing a matrix stack
struct Matrix {
	float m[16];
	Matrix *previous;
};

class MatrixStack {

public:
	Matrix *currentMatrix;

	//Constructor of a matrix stack
	MatrixStack();

	//Destructor
	~MatrixStack();

	//Pointer to top element
	float* getCurrentMatrix();

	//Set the top element
	void init();

	//Rotation around x for the top element
	void rotX(float angle);

	//Rotation around y for the top element
	void rotY(float angle);

	//Rotation around z for the top element
	void rotZ(float angle);

	//Scaling for the top element
	void scale(float s);

	//Translate the top element
	void translate(float x, float y, float z);

	//Push to the stack
	void push();

	//Pop from the stack
	void pop();

	//Remove all elements except the last one from the stack
	void flush();

	//Count the number of elements
	int depth();

	//Print the entire contents of the stack (for debugging purposes)
	void print();

private:
	void matrixMult(float M1[], float M2[], float Mout[]);
	void matrixPrint(float M[]);
};
