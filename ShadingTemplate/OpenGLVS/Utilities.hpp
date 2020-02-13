/* Utilities.hpp */
/*
 * Some useful functions for the course TNM046
 * (Extension loading stuff for Windows and a frame timer)
 * Usage: call loadExtensions() after getting an OpenGL context.
 * Call displayFPS() once per frame to show the rendering speed.
 * Author: Stefan Gustavson 2013-2014 (stefan.gustavson@liu.se)
 * This code is in the public domain.
 */

#ifndef UTILITIES_HPP // Avoid including this header twice
#define UTILITIES_HPP

#ifdef __APPLE__
#define GLFW_INCLUDE_GLCOREARB
#endif

#ifdef __LINUX__
#define GL_GLEXT_PROTOTYPES
#endif

#include <GLFW/glfw3.h>

#include <cstdio>  // For console messages

#ifdef __WIN32__
 // Windows installations usually lack an up-to-date OpenGL extension header,
 // so make sure to supply your own, or at least make sure it's of a recent date.
#include <GL/glext.h>
/* Global function pointers for everything we need beyond OpenGL 1.1.
 * This is a requirement from Microsoft Windows. Other platforms have
 * proper built-in support for modern OpenGL, and don't need this.
 */
extern PFNGLCREATEPROGRAMPROC            glCreateProgram;
extern PFNGLDELETEPROGRAMPROC            glDeleteProgram;
extern PFNGLUSEPROGRAMPROC               glUseProgram;
extern PFNGLCREATESHADERPROC             glCreateShader;
extern PFNGLDELETESHADERPROC             glDeleteShader;
extern PFNGLSHADERSOURCEPROC             glShaderSource;
extern PFNGLCOMPILESHADERPROC            glCompileShader;
extern PFNGLGETSHADERIVPROC              glGetShaderiv;
extern PFNGLGETPROGRAMIVPROC             glGetProgramiv;
extern PFNGLATTACHSHADERPROC             glAttachShader;
extern PFNGLGETSHADERINFOLOGPROC         glGetShaderInfoLog;
extern PFNGLGETPROGRAMINFOLOGPROC        glGetProgramInfoLog;
extern PFNGLLINKPROGRAMPROC              glLinkProgram;
extern PFNGLGETUNIFORMLOCATIONPROC       glGetUniformLocation;
extern PFNGLUNIFORM1FPROC                glUniform1f;
extern PFNGLUNIFORM3FPROC                glUniform3f;
extern PFNGLUNIFORM1FVPROC               glUniform1fv;
extern PFNGLUNIFORM1IPROC                glUniform1i;
extern PFNGLUNIFORMMATRIX4FVPROC         glUniformMatrix4fv;
extern PFNGLGENBUFFERSPROC               glGenBuffers;
extern PFNGLISBUFFERPROC                 glIsBuffer;
extern PFNGLBINDBUFFERPROC               glBindBuffer;
extern PFNGLBUFFERDATAPROC               glBufferData;
extern PFNGLDELETEBUFFERSPROC            glDeleteBuffers;
extern PFNGLGENVERTEXARRAYSPROC          glGenVertexArrays;
extern PFNGLISVERTEXARRAYPROC            glIsVertexArray;
extern PFNGLBINDVERTEXARRAYPROC          glBindVertexArray;
extern PFNGLDELETEVERTEXARRAYSPROC       glDeleteVertexArrays;
extern PFNGLENABLEVERTEXATTRIBARRAYPROC  glEnableVertexAttribArray;
extern PFNGLVERTEXATTRIBPOINTERPROC      glVertexAttribPointer;
extern PFNGLDISABLEVERTEXATTRIBARRAYPROC glDisableVertexAttribArray;
extern PFNGLGENERATEMIPMAPPROC           glGenerateMipmap;

#endif

namespace Utilities {
	/*
	 * printError() - Signal an error.
	 * Simple printf() to console for portability.
	 */
	void printError(const char *errtype, const char *errmsg);

	/*
	 * loadExtensions() - Load OpenGL extensions for anything above OpenGL
	 * version 1.1. (This is a requirement only on Windows, so on other
	 * platforms, this function does nothing.)
	 */
	void loadExtensions();

	/*
	 * displayFPS() - Calculate, display and return frame rate statistics.
	 * Called every frame, but statistics are updated only once per second.
	 * The time per frame is a better measure of performance than the
	 * number of frames per second, so both are displayed.
	 *
	 * NOTE: This function doesn't work properly if you call it for multiple
	 * windows. Call it only for one window, and only once for each frame.
	 */
	double displayFPS(GLFWwindow *window);

}

#endif // UTILITIES_HPP
