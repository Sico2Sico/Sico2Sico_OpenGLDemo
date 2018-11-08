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
#include "Glm/glm.hpp"
#include "Glm/ext.hpp"


GLuint vbo,gpuProgram,texture;
GLint posLoaction, colorLoaction, textureLoaction, texcoordLoaction;
GLint MLocation, VLocation, PLocation;

float color[] = {0.6, 0.2, 0.4, 1.0};
char * frame[2];
int currentFrameIndex = 0;
glm::mat4 projection=glm::perspective(50.0f,640.0f/1136.0f,0.1f,100.0f);


float identity[]=
{
    1.0f,0.0f,0.0f,0.0f,
    0.0f,1.0f,0.0f,0.0f,
    0.0f,0.0f,1.0f,0.0f,
    0.0f,0.0f,0.0f,1.0f
};

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

    float datas[] = {

        -0.5f,-0.5f,0.0f,0.0f,0.0f,
        0.5f,-0.5f,0.0f,1.0f,0.0f,
        -0.5,0.5f,0.0f,0.0f,1.0f,

        0.5f,-0.5f,0.0f,1.0f,0.0f,
        -0.5f,0.5f,0.0f,0.0f,1.0f,
        0.5f,0.5f,0.0f,1.0f,1.0f
    };

    vbo = CreateBufferObject(GL_ARRAY_BUFFER, sizeof(float)*5*6,datas, GL_STATIC_DRAW);
    char * vsCode = LoadAssetConten("/Data/Shader/simple.vs");
    char * fsCode = LoadAssetConten("/Data/Shader/simple.fs");

    gpuProgram = GreateGUPProgram(vsCode, fsCode);
    posLoaction = glGetAttribLocation(gpuProgram, "pos");
    colorLoaction = glGetUniformLocation(gpuProgram,"U_Color");

    texcoordLoaction = glGetAttribLocation(gpuProgram,"texcoord");
    textureLoaction = glGetUniformLocation(gpuProgram, "U_MainTexture");

    MLocation = glGetUniformLocation(gpuProgram,"M");
    VLocation = glGetUniformLocation(gpuProgram,"V");
    PLocation = glGetUniformLocation(gpuProgram,"P");

    texture = GenerateAlphaTexture(256);

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

    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

    glUseProgram(gpuProgram);
    glUniform4fv(colorLoaction,1, color);


    glBindTexture(GL_TEXTURE_2D, texture);
    glUniformMatrix4fv(MLocation, 1, GL_FALSE,identity);
    glUniformMatrix4fv(VLocation, 1, GL_FALSE,identity);
    glUniformMatrix4fv(PLocation, 1, GL_FALSE,glm::value_ptr(projection));

    glUniform1i(textureLoaction, 0);
    glBindBuffer(GL_ARRAY_BUFFER,vbo);

    glEnableVertexAttribArray(posLoaction);
    glVertexAttribPointer(posLoaction, 3, GL_FLOAT, GL_FALSE, sizeof(float)*5,0);

    glEnableVertexAttribArray(texcoordLoaction);
    glVertexAttribPointer(texcoordLoaction, 2, GL_FLOAT, GL_FALSE, sizeof(float)*5, (void*)(sizeof(float)*3));

    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glDrawArrays(GL_POINTS, 0, 6);
    glUseProgram(0);
}

@end
