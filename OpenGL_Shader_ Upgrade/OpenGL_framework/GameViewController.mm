//
//  GameViewController.m
//  OpenGL_framework
//
//  Created by 德志 on 2018/11/6.
//  Copyright © 2018 com.aiiage.www. All rights reserved.
//

#import "GameViewController.h"
#include "Header.h"
#include "scene.hpp"

unsigned char * LoadFileContent(const char*path,int&filesize){
    unsigned char*fileContent=nullptr;
    filesize=0;
    NSString *nsPath=[[NSBundle mainBundle] pathForResource:[NSString stringWithUTF8String:path] ofType:nil];
    NSData*data=[NSData dataWithContentsOfFile:nsPath];
    if([data length]>0){
        filesize=[data length];
        fileContent=new unsigned char[filesize+1];
        memcpy(fileContent, [data bytes], filesize);
        fileContent[filesize]='\0';
    }
    return fileContent;
}

float GetFrameTime(){
    return 0.033f;
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
    Init();
    CGRect rect=[[UIScreen mainScreen] bounds];
    SetViewPortSize(rect.size.width,rect.size.height);
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
    Draw();
}

@end
