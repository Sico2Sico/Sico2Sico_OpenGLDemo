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



/**
 根据路径加载资源

 @param path 路径
 @return nil
 */
char* LoadAssetConten(const char * path);



/**
解码图片
 @param bmpFileContent <#bmpFileContent description#>
 @param width <#width description#>
 @param height <#height description#>
 @return <#return value description#>
 */
char* DecodeBMP(char * bmpFileContent, int &width, int &height);


#endif /* Utils_hpp */
