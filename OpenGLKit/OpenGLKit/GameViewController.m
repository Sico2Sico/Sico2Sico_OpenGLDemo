//
//  GameViewController.m
//  OpenGLKit
//
//  Created by 德志 on 2018/11/9.
//  Copyright © 2018 com.aiiage.www. All rights reserved.
//

#import "GameViewController.h"
#import <GLKit/GLKit.h>
#import <GLKit/GLKMath.h>
#import <GLKit/GLKMatrix3.h>
#import <GLKit/GLKEffects.h>
#import <GLKit/GLKMathUtils.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import <Masonry.h>

@interface GameViewController()

@property (nonatomic, strong) EAGLContext * context;
@property (nonatomic, strong) GLKBaseEffect * mEffect;


@property (nonatomic, assign) int mCount;
@property (nonatomic, assign) float dDegreex;
@property (nonatomic, assign) float dDegreey;
@property (nonatomic, assign) float dDegreez;

@property (nonatomic, assign) BOOL mBoolx;
@property (nonatomic, assign) BOOL mBooly;
@property (nonatomic, assign) BOOL mBoolz;

@property (nonatomic, strong) UIButton * butx;
@property (nonatomic, strong) UIButton * buty;
@property (nonatomic, strong) UIButton * butz;


@end



@implementation GameViewController

{
    dispatch_source_t timer;
}


-(void)viewDidLoad{
    [super viewDidLoad];
    self.context = [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
    GLKView * view = (GLKView*)self.view;

    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    view.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;

    [EAGLContext setCurrentContext:self.context];
    glEnable(GL_DEPTH_TEST);

    [self renderNew];
}


-(void)renderNew {

    GLfloat attrArr[]= {
        -0.5f, 0.5f, 0.0f,      0.0f, 0.0f, 0.5f,       0.0f, 1.0f,//左上
        0.5f, 0.5f, 0.0f,       0.0f, 0.5f, 0.0f,       1.0f, 1.0f,//右上
        -0.5f, -0.5f, 0.0f,     0.5f, 0.0f, 1.0f,       0.0f, 0.0f,//左下
        0.5f, -0.5f, 0.0f,      0.0f, 0.0f, 0.5f,       1.0f, 0.0f,//右下
        0.0f, 0.0f, 1.0f,       1.0f, 1.0f, 1.0f,       0.5f, 0.5f,//顶点
    };

    GLuint indices[] = {
        0, 3, 2,
        0, 1, 3,
        0, 2, 4,
        0, 4, 1,
        2, 3, 4,
        1, 4, 3,
    };

    /// 获取多少个点
    self.mCount = sizeof(indices)/ sizeof(GLuint);

    GLuint buffer;
    glGenBuffers(1, &buffer);
    glBindBuffer(GL_ARRAY_BUFFER,buffer);
    glBufferData(GL_ARRAY_BUFFER,sizeof(attrArr) ,attrArr, GL_STATIC_DRAW);

    GLuint index;
    glGenBuffers(1, &index);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, index);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER,sizeof(indices),indices, GL_STATIC_DRAW);

    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT,GL_FALSE, sizeof(GLfloat)*8,(GLfloat*)NULL);


    glEnableVertexAttribArray(GLKVertexAttribColor);
    glVertexAttribPointer(GLKVertexAttribColor, 3, GL_FLOAT,GL_FALSE, sizeof(GLfloat)*8,(GLfloat*)NULL+3);

    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT,GL_FALSE, sizeof(GLfloat)*8,(GLfloat*)NULL+6);

    NSString * filePath = [[NSBundle mainBundle] pathForResource:@"for_test" ofType:@"png"];
    NSDictionary * options = [NSDictionary dictionaryWithObjectsAndKeys:@(1),GLKTextureLoaderOriginBottomLeft,nil];

    GLKTextureInfo * textureinfo = [GLKTextureLoader textureWithContentsOfFile:filePath options:options error:nil];

    /// 着色器
    self.mEffect = [[GLKBaseEffect alloc]init];
    self.mEffect.texture2d0.enabled = GL_TRUE;
    self.mEffect.texture2d0.name = textureinfo.name;

    /// 开始投影
    CGSize size = self.view.bounds.size;
    float aspect = fabs(size.width/size.height);
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(90),aspect, 0.1f, 10.0f);
    projectionMatrix = GLKMatrix4Scale(projectionMatrix,1.0f,1.0f,1.0f);
    self.mEffect.transform.projectionMatrix = projectionMatrix;

    GLKMatrix4 modelViewMatrix = GLKMatrix4Translate(GLKMatrix4Identity,0.0f,0.0f,-2.0f);
    self.mEffect.transform.modelviewMatrix = modelViewMatrix;

    /// 定时器
    double delayInSeconds = 0.1;
    timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER,0,0,dispatch_get_main_queue());
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, delayInSeconds*NSEC_PER_SEC,0.0);

    dispatch_source_set_event_handler(timer, ^{

        self.dDegreex += 0.1 * 1;
        self.dDegreey += 0.1 * 1;
        self.dDegreez += 0.1 * 1;
    });

    dispatch_resume(timer);
}


-(void)update{

    GLKMatrix4 modelViewMatrix = GLKMatrix4Translate(GLKMatrix4Identity, 0.0f, 0.0f, -2.0f);

    modelViewMatrix = GLKMatrix4RotateX(modelViewMatrix, self.dDegreex);
    modelViewMatrix = GLKMatrix4RotateY(modelViewMatrix, self.dDegreey);
    modelViewMatrix = GLKMatrix4RotateZ(modelViewMatrix, self.dDegreez);

    self.mEffect.transform.modelviewMatrix = modelViewMatrix;

}

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect{

    glClearColor(0.3f, 0.3f, 0.3f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    [self.mEffect prepareToDraw];
    glDrawElements(GL_TRIANGLES, self.mCount,GL_UNSIGNED_INT,0);
}
















@end
