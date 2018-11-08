//
//  Utils.hpp
//  OpenGL_framework
//
//  Created by 德志 on 2018/11/6.
//  Copyright © 2018 com.aiiage.www. All rights reserved.
//

#ifndef Utils_hpp
#define Utils_hpp

#include <stdio.h>
#include <OpenGLES/ES2/glext.h>

GLuint CompileShader(GLenum shadType, const char * code);
GLuint GreateGUPProgram(const char * vsCode, const char * fsCode);
GLuint CreateBufferObject(GLenum objType, int objSzie, void *data,GLenum usage);


char* LoadAssetConten(const char * path);

#endif /* Utils_hpp */
