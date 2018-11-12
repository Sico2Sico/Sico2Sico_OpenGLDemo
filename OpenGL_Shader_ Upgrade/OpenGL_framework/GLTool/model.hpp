//
//  model.hpp
//  OpenGLGToolDemo
//
//  Created by 德志 on 2018/11/12.
//  Copyright © 2018 com.aiiage.www. All rights reserved.
//

#ifndef model_hpp
#define model_hpp
#include "Header.h"
#include "utils.hpp"
#include "vertexbuffer.hpp"
#include "shader.hpp"

class Model {
public:
    VertexBuffer*mVertexBuffer;
    Shader*mShader;
public:
    glm::mat4 mModelMatrix;
    float *mLightViewMatrix, *mLightProjectionMatrix;
    Model();
    void Init(const char*modelPath);
    void Draw(glm::mat4 & viewMatrix, glm::mat4 projectionMatrix, float x, float y, float z);
    void SetPosition(float x, float y, float z);
    void SetAmbientMaterial(float r, float g, float b, float a);
    void SetDiffuseMaterial(float r, float g, float b, float a);
    void SetSpecularMaterial(float r, float g, float b, float a);
    void SetTexture(const char*imagePath);
};

#endif /* model_hpp */
















