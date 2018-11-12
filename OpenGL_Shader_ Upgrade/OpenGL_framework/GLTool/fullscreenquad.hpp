//
//  fullscreenquad.hpp
//  OpenGLGToolDemo
//
//  Created by 德志 on 2018/11/12.
//  Copyright © 2018 com.aiiage.www. All rights reserved.
//

#ifndef fullscreenquad_h
#define fullscreenquad_h
#include "Header.h"
#include "vertexbuffer.hpp"
#include "shader.hpp"
#include "utils.hpp"

class FullScreenQuad {
public:
    VertexBuffer *mVertexBuffer;
    Shader *mShader;

public:
    void Init();
    void Draw();
    void DrawToLeftTop();
    void DrawToRightTop();
    void DrawToLeftBottom();
    void DrawToRightBottom();
};


#endif /* fullscreenquad_h */
