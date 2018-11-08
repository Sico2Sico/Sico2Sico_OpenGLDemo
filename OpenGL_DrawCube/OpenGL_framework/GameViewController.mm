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
GLint posLocation, colorLocation, textureLocation,colorAtteriLocation,MLocation,VLocation,PLocation;
float color[] = {0.5,0.3,0.1,1.0};
float identity[] = {
    1.0f,0.0f,0.0f,0.0f,
    0.0f,1.0f,0.0f,0.0f,
    0.0f,0.0f,1.0f,0.0f,
    0.0f,0.0f,0.0f,1.0f
};

glm::mat4 projection=glm::perspective(50.0f,640.0f/1136.0f,0.1f,100.0f);
glm::mat4 modelMatrix=glm::translate(0.0f,0.f,-5.0f)*glm::rotate(30.0f,1.0f,1.0f,1.0f);

float angle = 0.0f;

struct Particel {
    float pos[3];
    float color[3];
};

struct Vertex {
    float pos[3];
};


Particel * particles = nullptr;
bool * fadeIn = nullptr;
int nParticleConut = 100;



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

    char *vscode = LoadAssetConten("/Data/Shader/drawCube.vs");
    char *fscode = LoadAssetConten("/Data/Shader/drawCube.fs");

    gpuProgram = CreateGPUProgram(vscode, fscode);
    posLocation = glGetAttribLocation(gpuProgram,"pos");

    MLocation = glGetUniformLocation(gpuProgram,"M");
    VLocation = glGetUniformLocation(gpuProgram,"V");
    PLocation = glGetUniformLocation(gpuProgram,"P");

    Vertex vertexes[24];

    //z
    vertexes[0].pos[0]=-0.5f;
    vertexes[0].pos[1]=-0.5f;
    vertexes[0].pos[2]=0.5f;
    vertexes[1].pos[0]=0.5f;
    vertexes[1].pos[1]=-0.5f;
    vertexes[1].pos[2]=0.5f;
    vertexes[2].pos[0]=0.5f;
    vertexes[2].pos[1]=0.5f;
    vertexes[2].pos[2]=0.5f;
    vertexes[3].pos[0]=-0.5f;
    vertexes[3].pos[1]=0.5f;
    vertexes[3].pos[2]=0.5f;
    //-z
    vertexes[4].pos[0]=0.5f;
    vertexes[4].pos[1]=-0.5f;
    vertexes[4].pos[2]=-0.5f;

    vertexes[5].pos[0]=-0.5f;
    vertexes[5].pos[1]=-0.5f;
    vertexes[5].pos[2]=-0.5f;

    vertexes[6].pos[0]=-0.5f;
    vertexes[6].pos[1]=0.5f;
    vertexes[6].pos[2]=-0.5f;

    vertexes[7].pos[0]=0.5f;
    vertexes[7].pos[1]=0.5f;
    vertexes[7].pos[2]=-0.5f;

    //x
    vertexes[8].pos[0]=0.5f;
    vertexes[8].pos[1]=-0.5f;
    vertexes[8].pos[2]=0.5f;

    vertexes[9].pos[0]=0.5f;
    vertexes[9].pos[1]=-0.5f;
    vertexes[9].pos[2]=-0.5f;

    vertexes[10].pos[0]=0.5f;
    vertexes[10].pos[1]=0.5f;
    vertexes[10].pos[2]=-0.5f;

    vertexes[11].pos[0]=0.5f;
    vertexes[11].pos[1]=0.5f;
    vertexes[11].pos[2]=0.5f;
    //-x
    vertexes[12].pos[0]=-0.5f;
    vertexes[12].pos[1]=-0.5f;
    vertexes[12].pos[2]=-0.5f;

    vertexes[13].pos[0]=-0.5f;
    vertexes[13].pos[1]=-0.5f;
    vertexes[13].pos[2]=0.5f;

    vertexes[14].pos[0]=-0.5f;
    vertexes[14].pos[1]=0.5f;
    vertexes[14].pos[2]=0.5f;

    vertexes[15].pos[0]=-0.5f;
    vertexes[15].pos[1]=0.5f;
    vertexes[15].pos[2]=-0.5f;
    //y
    vertexes[16].pos[0]=-0.5f;
    vertexes[16].pos[1]=0.5f;
    vertexes[16].pos[2]=0.5f;

    vertexes[17].pos[0]=0.5f;
    vertexes[17].pos[1]=0.5f;
    vertexes[17].pos[2]=0.5f;

    vertexes[18].pos[0]=0.5f;
    vertexes[18].pos[1]=0.5f;
    vertexes[18].pos[2]=-0.5f;

    vertexes[19].pos[0]=-0.5f;
    vertexes[19].pos[1]=0.5f;
    vertexes[19].pos[2]=-0.5f;
    //-y
    vertexes[20].pos[0]=-0.5f;
    vertexes[20].pos[1]=-0.5f;
    vertexes[20].pos[2]=-0.5f;

    vertexes[21].pos[0]=0.5f;
    vertexes[21].pos[1]=-0.5f;
    vertexes[21].pos[2]=-0.5f;

    vertexes[22].pos[0]=0.5f;
    vertexes[22].pos[1]=-0.5f;
    vertexes[22].pos[2]=0.5f;

    vertexes[23].pos[0]=-0.5f;
    vertexes[23].pos[1]=-0.5f;
    vertexes[23].pos[2]=0.5f;


    vbo = CreateBufferObject(GL_ARRAY_BUFFER,
                             sizeof(Vertex)*24,
                             vertexes,
                             GL_STATIC_DRAW);

    unsigned short indexes[] = {0,1,2,0,2,3,4,5,6,4,6,7,8,9,10,8,10,11,12,13,14,12,14,15,16,17,18,16,18,19,20,21,22,20,22,23};

    ebo = CreateBufferObject(GL_ELEMENT_ARRAY_BUFFER,
                             sizeof(unsigned short)*(sizeof(indexes)/sizeof(unsigned short))
                             ,indexes,
                             GL_STATIC_DRAW);


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
    glEnable(GL_BLEND);


    glUseProgram(gpuProgram);
    glUniformMatrix4fv(MLocation, 1, GL_FALSE, glm::value_ptr(modelMatrix));
    glUniformMatrix4fv(VLocation, 1, GL_FALSE, identity);
    glUniformMatrix4fv(PLocation, 1, GL_FALSE, glm::value_ptr(projection));
    glUniform1f(gpuProgram, 0);

    glBindBuffer(GL_ARRAY_BUFFER, vbo);
    glEnableVertexAttribArray(posLocation);
    glVertexAttribPointer(posLocation, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), 0);
    glBindBuffer(GL_ARRAY_BUFFER, 0);


    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER,ebo);
    glDrawElements(GL_TRIANGLES,36, GL_UNSIGNED_SHORT,0);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER,0);

    glUseProgram(0);
}

@end
