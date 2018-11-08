//
//  GameViewController.m
//  OpenGL_framework
//
//  Created by 德志 on 2018/11/6.
//  Copyright © 2018 com.aiiage.www. All rights reserved.
//

#import "GameViewController.h"
#import <OpenGLES/ES2/glext.h>


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
    NSLog(@"update");
}


- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect{

    glClearColor(0.1f, 0.4f, 0.6f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    NSLog(@"glKview");

}

@end
