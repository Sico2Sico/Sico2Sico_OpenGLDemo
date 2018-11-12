//
//  fullscreenquad.hpp
//  OpenGL_framework
//
//  Created by 德志 on 2018/11/12.
//  Copyright © 2018 com.aiiage.www. All rights reserved.
//

#ifndef fullscreenquad_hpp
#define fullscreenquad_hpp

#include "Header.h"
#include "vertexbuffer.hpp"
#include "shader.hpp"

class FullScreenQuad{
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

#endif /* fullscreenquad_hpp */
