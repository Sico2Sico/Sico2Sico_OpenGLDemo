//
//  shader.hpp
//  OpenGLGToolDemo
//
//  Created by 德志 on 2018/11/11.
//  Copyright © 2018 com.aiiage.www. All rights reserved.
//

#ifndef shader_hpp
#define shader_hpp
#include "Header.h"

struct UniformTexture {
    GLint mLocation;
    GLuint mTexture;
    UniformTexture() {
        mLocation = -1;
        mTexture = 0;
    }
};
struct UniformTextureCube {
    GLint mLocation;
    GLuint mTexture;
    UniformTextureCube() {
        mLocation = -1;
        mTexture = 0;
    }
};
struct UniformVector4f {
    GLint mLocation;
    float v[4];
    UniformVector4f() {
        mLocation = -1;
        memset(v, 0, sizeof(float) * 4);
    }
};
class Shader {
public:
    static GLuint CompileShader(GLenum shaderType, const char*shaderCode);
    static GLuint CreateProgram(GLuint vsShader, GLuint fsShader);
public:
    GLuint mProgram;
    std::map<std::string, UniformTexture*> mUniformTextures;
    std::map<std::string, UniformTextureCube*> mUniformTextureCubes;
    std::map<std::string, UniformVector4f*> mUniformVec4s;
    GLint mModelMatrixLocation, mViewMatrixLocation, mProjectionMatrixLocation;
    GLint mPositionLocation, mColorLocation, mTexcoordLocation, mNormalLocation;
    void Init(const char*vs, const char*fs);
    void Bind(float *M, float *V, float*P);
    void SetTexture(const char * name, const char*imagePath);
    GLuint SetTexture(const char * name, GLuint texture);
    GLuint SetTextureCube(const char * name, GLuint texture);
    void SetVec4(const char * name, float x, float y, float z, float w);
};


#endif /* shader_hpp */












