//
//  Utils.cpp
//  OpenGL_framework
//
//  Created by 德志 on 2018/11/6.
//  Copyright © 2018 com.aiiage.www. All rights reserved.
//

#include "Utils.hpp"



char* DecodeBMP(char * bmpFileContent, int &width, int &height){
    unsigned char * pixeData = nullptr;
    if (0x4D42 == *((unsigned short*)bmpFileContent)) {

        int pixelDataOffset = *((int*)(bmpFileContent+10));
        width  =  *((int*)(bmpFileContent+18));
        height =  *((int*)(bmpFileContent+22));

        pixeData = (unsigned char *)(bmpFileContent + pixelDataOffset);

        for (int i =0; i < width * height *3 ; i+=3) {
            unsigned char temp = pixeData[i+2];
            pixeData[i+2] = pixeData[i];
            pixeData[i] = temp;
        }
        return  (char * )pixeData;
    }
    return  (char *)pixeData;
}


GLuint CompileShader(GLenum shadType, const char * code) {

    GLuint shader = glCreateShader(shadType);

    glShaderSource(shader,1, &code,NULL);
    glCompileShader(shader);

    GLint complieStatus = GL_TRUE;
    glGetShaderiv(shader,GL_COMPILE_STATUS, &complieStatus);

    if (complieStatus == GL_FASTEST) {
        printf("complie shader error shader code is \n %s\n",code);
        char szBuffer[1024] = {0};
        GLsizei logLen = 0;
        glGetShaderInfoLog(shader, 1024, &logLen, szBuffer);
        printf("error log \n %s\n",szBuffer);
        glDeleteShader(shader);
        return 0;
    }
    return shader;
}


GLuint GreateGUPProgram(const char * vsCode, const char * fsCode){

    GLuint program;

    GLuint vsShader = CompileShader(GL_VERTEX_SHADER, vsCode);
    GLuint fsShader = CompileShader(GL_FRAGMENT_SHADER, fsCode);

    program = glCreateProgram();
    glAttachShader(program, vsShader);
    glAttachShader(program, fsShader);

    glLinkProgram(program);
    GLint programStatus = GL_TRUE;
    glGetProgramiv(program, GL_LINK_STATUS, &programStatus);

    if (programStatus == GL_FALSE) {
        printf("link program eroor");
        char szBuffer[1024] = {0};
        GLsizei logLen = 0;
        glGetProgramInfoLog(program, 1024, &logLen,szBuffer);
        printf("Link error  \n  %s\n",szBuffer);
        glDeleteProgram(program);
        return 0;
    }
    return program;
}

GLuint CreateBufferObject(GLenum objType, int objSzie, void *data,GLenum usage){

    GLuint bufferObject;
    glGenBuffers(1, &bufferObject);
    glBindBuffer(GL_ARRAY_BUFFER, bufferObject);
    glBufferData(GL_ARRAY_BUFFER, objSzie, data, usage);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    return bufferObject;
}




