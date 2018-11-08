//
//  GameViewController.m
//  OpenGL_framework
//
//  Created by 德志 on 2018/11/6.
//  Copyright © 2018 com.aiiage.www. All rights reserved.
//

#import "GameViewController.h"
#import <OpenGLES/ES2/glext.h>
#include "Utils.hpp"


GLuint vbo,gpuProgram;
GLint posLoaction, colorLoaction;
float color[] = {0.6, 0.2, 0.4, 1.0};


char* LoadAssetConten(const char * path){
    char * assetContent = nullptr;
    NSString * nsPath = [[NSBundle mainBundle]  pathForResource:[NSString stringWithUTF8String:path] ofType:nil];
    NSData * data = [NSData dataWithContentsOfFile:nsPath];
    assetContent  = new char [[data length] +1];
    memcpy(assetContent, [data bytes], [data length]);
    assetContent[[data length]+1] = '\0';
    return assetContent;
}

@interface GameViewController()

@property(nonatomic, strong) EAGLContext *context;

@end


@implementation GameViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
     self.context = [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES3];
    if (self.context == nil) {
         self.context = [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
    }


    GLKView *view = (GLKView*)self.view;
    view.context = self.context;

    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    [EAGLContext setCurrentContext:self.context];


    [self initScence];
}

-(void)initScence{

    float postions[] = {
        -0.5f,0.0f,0.0f,
        0.5f,0.0f,0.0f,
        0.0f,0.5f,0.0f
    };

    vbo = CreateBufferObject(GL_ARRAY_BUFFER, sizeof(float)*9,postions, GL_STATIC_DRAW);
    char * vsCode = LoadAssetConten("/Data/Shader/simple.vs");
    char * fsCode = LoadAssetConten("/Data/Shader/simple.fs");

    gpuProgram = GreateGUPProgram(vsCode, fsCode);
    posLoaction = glGetAttribLocation(gpuProgram, "pos");
    colorLoaction = glGetUniformLocation(gpuProgram,"U_Color");
}

-(void)dealloc{
    [self tearDownGL];

    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }

}

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];

    if ([self isViewLoaded] && [[self view] window] == nil) {
        self.view = nil;
        [self tearDownGL];

        if ([EAGLContext currentContext] == self.context) {
            [EAGLContext setCurrentContext:nil];
        }
        self.context = nil;
    }

}

- (BOOL)prefersStatusBarHidden{
    return  YES;
}


-(void)tearDownGL{
    [EAGLContext setCurrentContext:self.context];
}


-(void)update{

}


- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect{

    glClearColor(0.1f, 0.4f, 0.6f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);

    glUseProgram(gpuProgram);
    glUniform4fv(colorLoaction,1, color);
    glBindBuffer(GL_ARRAY_BUFFER,vbo);

    glEnableVertexAttribArray(posLoaction);
    glVertexAttribPointer(posLoaction, 3, GL_FLOAT, GL_FALSE, sizeof(float)*3,0);
    glBindBuffer(GL_ARRAY_BUFFER, 0);

    glDrawArrays(GL_TRIANGLES, 0, 3);
    glUseProgram(0);
}

@end
