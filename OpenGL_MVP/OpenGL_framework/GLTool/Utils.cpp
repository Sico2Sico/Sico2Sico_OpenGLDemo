//
//  Utils.cpp
//  OpenGL_framework
//
//  Created by 德志 on 2018/11/6.
//  Copyright © 2018 com.aiiage.www. All rights reserved.
//

#include "Utils.hpp"
#include <math.h>


GLuint GenerateAlphaTexture(int size){

    GLuint texture;
    unsigned char*imgData=new unsigned char[size*size];
    float maxDistance=sqrtf(size/2.0f*size/2.0f+size/2.0f*size/2.0f);
    float centerX=(float)size/2.0f;
    float centerY=centerX;
    for (int y=0; y<size; ++y)
    {
        for (int x=0; x<size; ++x)
        {
            float distance=sqrtf((x-centerX)*(x-centerX)+(y-centerY)*(y-centerY));
            float alpha=1.0f-distance/maxDistance;
            alpha=alpha>1.0f?1.0f:alpha;
            alpha=powf(alpha, 4.0f);
            imgData[x+y*size]=(unsigned char)(alpha*255.0f);
        }
    }
    glGenTextures(1, &texture);
    glBindTexture(GL_TEXTURE_2D, texture);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_ALPHA, size, size, 0, GL_ALPHA, GL_UNSIGNED_BYTE, imgData);
    glBindTexture(GL_TEXTURE_2D, 0);
    return texture;
}


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




