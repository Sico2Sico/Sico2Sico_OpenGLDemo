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


GLuint vbo,ebo, gpuProgram, texture;
GLint posLocation,texcoorLocation,textureLocation, normalLocation,MLocation,VLocation,PLocation,NMLocation;

int indexCount = 0;

float color[] = {0.5,0.3,0.1,1.0};
float identity[] = {
    1.0f,0.0f,0.0f,0.0f,
    0.0f,1.0f,0.0f,0.0f,
    0.0f,0.0f,1.0f,0.0f,
    0.0f,0.0f,0.0f,1.0f
};

glm::mat4 projection=glm::perspective(50.0f,640.0f/1136.0f,0.1f,100.0f);
glm::mat4 modelMatrix=glm::translate(0.0f,0.f,-5.0f)*glm::rotate(-90.0f,0.0f,1.0f,0.0f)*glm::scale(0.01f, 0.01f,0.01f);
glm::mat4 normalmatrix = glm::inverseTranspose(modelMatrix);

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

    char *vscode = LoadAssetConten("/Data/Shader/default.vs");
    char *fscode = LoadAssetConten("/Data/Shader/default.fs");

    gpuProgram = CreateGPUProgram(vscode, fscode);
    posLocation = glGetAttribLocation(gpuProgram,"pos");
    normalLocation = glGetAttribLocation(gpuProgram,"normal");
    texcoorLocation = glGetAttribLocation(gpuProgram,"texcoord");

    NMLocation = glGetUniformLocation(gpuProgram,"NM");
    MLocation = glGetUniformLocation(gpuProgram,"M");
    VLocation = glGetUniformLocation(gpuProgram,"V");
    PLocation = glGetUniformLocation(gpuProgram,"P");
    textureLocation = glGetUniformLocation(gpuProgram,"U_MainTexture");

    char * bmpFile  = LoadAssetConten("Data/niutou.bmp");
    int width,height;
    char *pixelData = DecodeBMP(bmpFile,width,height);
    glGenBuffers(1, &texture);
    glBindBuffer(GL_TEXTURE_2D,texture);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexImage2D(GL_TEXTURE_2D,0,GL_RGB,width,height,0, GL_RGB,GL_UNSIGNED_BYTE,pixelData);
    glBindBuffer(GL_TEXTURE_2D,0);

    char* objModeFile = LoadAssetConten("Data/niutou.obj");
    unsigned short *indices = nullptr;
    int vertexCounrt = 0;
    Vertex * vertices = nullptr;

    if(DecodeobjModel(objModeFile,&indices,indexCount,&vertices, vertexCounrt)){

        vbo = CreateBufferObject(GL_ARRAY_BUFFER,
                                 sizeof(Vertex)*vertexCounrt,
                                 vertices,
                                 GL_STATIC_DRAW);

        ebo = CreateBufferObject(GL_ELEMENT_ARRAY_BUFFER,
                                 sizeof(unsigned short)*indexCount
                                 ,indices,
                                 GL_STATIC_DRAW);
    }
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


//    angle += 0.8f;
//    if (angle > 360.0f) {
//        angle= 0;
//    }
//
//    modelMatrix = glm::rotate(angle, 0.0f, 0.0f,1.0f);
//    for (int i = 0; i < nParticleConut; i++) {
//        float p = particles[i].color[0];
//        if (fadeIn[i]) {
//            p -= 0.05f;
//
//            if (p < 0.05) {
//                p = 0.4;
//                fadeIn[i] = GL_TRUE;
//            }
//
//        }else {
//            p+=0.05f;
//            if (p > 1.0f) {
//                p = 1.0f;
//                fadeIn[i] = GL_TRUE;
//            }
//        }
//    }
//
//    glBindBuffer(GL_ARRAY_BUFFER, vbo);
//    glBufferSubData(GL_ARRAY_BUFFER, 0, sizeof(Particel)*nParticleConut,particles);
//    glBindBuffer(GL_ARRAY_BUFFER, 0);

}


- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect{

    glClearColor(0.1f, 0.4f, 0.6f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glEnable(GL_DEPTH_TEST);

    glUseProgram(gpuProgram);

    glBindBuffer(GL_TEXTURE_2D,texture);
    glUniform1i(textureLocation,0);

    glUniformMatrix4fv(MLocation, 1, GL_FALSE, glm::value_ptr(modelMatrix));
    glUniformMatrix4fv(VLocation, 1, GL_FALSE, identity);
    glUniformMatrix4fv(PLocation, 1, GL_FALSE, glm::value_ptr(projection));
    glUniformMatrix4fv(NMLocation,1, GL_FALSE, glm::value_ptr(normalmatrix));


    glBindBuffer(GL_ARRAY_BUFFER, vbo);
    glEnableVertexAttribArray(posLocation);
    glVertexAttribPointer(posLocation, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), 0);

    glEnableVertexAttribArray(texcoorLocation);
    glVertexAttribPointer(texcoorLocation, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex),(void*)(sizeof(float)*3));

    glEnableVertexAttribArray(normalLocation);
    glVertexAttribPointer(normalLocation, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex),(void*)(sizeof(float)*5));


    glBindBuffer(GL_ARRAY_BUFFER, 0);


    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER,ebo);
    glDrawElements(GL_TRIANGLES,indexCount, GL_UNSIGNED_SHORT,0);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER,0);

    glUseProgram(0);
}

@end
