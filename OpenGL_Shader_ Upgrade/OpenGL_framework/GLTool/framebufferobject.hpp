//
//  framebufferobject.hpp
//  OpenGL_framework
//
//  Created by 德志 on 2018/11/12.
//  Copyright © 2018 com.aiiage.www. All rights reserved.
//

#ifndef framebufferobject_hpp
#define framebufferobject_hpp
#include "Header.h"

class FrameBufferObject{
public:
    GLuint mFrameBufferObject;
    std::map<std::string, GLuint> mBuffers;
    std::vector<GLenum> mDrawBuffers;
public:
    FrameBufferObject();
    void AttachColorBuffer(const char*bufferName,GLenum attachment,int width,int height);
    void AttachDepthBuffer(const char*bufferName, int width, int height);
    void Finish();
    void Bind();
    void Unbind();
    GLuint GetBuffer(const char*bufferName);
};


#endif /* framebufferobject_hpp */
