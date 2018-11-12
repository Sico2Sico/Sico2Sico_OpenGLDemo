//
//  utils.hpp
//  OpenGLGToolDemo
//
//  Created by 德志 on 2018/11/11.
//  Copyright © 2018 com.aiiage.www. All rights reserved.
//

#pragma once
#ifndef utils_hpp
#define utils_hpp

#include <stdio.h>
#include "Header.h"


float GetFrameTime();

/**
 加载文件

 @param path 文件路径
 @param filesize 大小
 @return 返回文件地址
 */
unsigned char * LoadFileContent(const char * path, int &filesize);


/**
 解码图片资源 bgr ---> rgb

 @param bmpFileData 地址
 @param width
 @param int&height
 @return 地址
 */
unsigned char * DecodeBMP(unsigned char * bmpFileData,int &width, int&height);


/**
 @param pixelData <#pixelData description#>
 @param width <#width description#>
 @param height <#height description#>
 @param type <#type description#>
 @return <#return value description#>
 */
GLuint CreateTexture2D(unsigned char * pixelData, int width, int height ,GLenum type);


/**
 @param bmpPath <#bmpPath description#>
 @return <#return value description#>
 */
GLuint CreateTexture2DFromBMP(const char* bmpPath);



/**
 @param front <#front description#>
 @param back <#back description#>
 @param left <#left description#>
 @param right <#right description#>
 @param top <#top description#>
 @param bottom <#bottom description#>
 @return <#return value description#>
 */
GLuint CreateTextureCubeFromBMP(const char * front, const char* back, const char * left,
                                const char * right, const char * top, const char * bottom);


#endif /* utils_hpp */











