//
//  scene.cpp
//  OpenGL_framework
//
//  Created by 德志 on 2018/11/12.
//  Copyright © 2018 com.aiiage.www. All rights reserved.
//

#include "scene.hpp"
#include "utils.hpp"
#include "model.hpp"
glm::mat4 viewMatrix, projectionMatrix;
glm::vec3 cameraPos(0.0f,0.0f,0.0f);
Model model;

void Init(){
    model.Init("Res/Cube.obj");
    model.mShader->Init("Res/skybox.vs","Res/skybox.fs");
    model.mShader->SetTextureCube("U_Texture", CreateTextureCubeFromBMP("Res/front.bmp","Res/back.bmp","Res/left.bmp","Res/right.bmp","Res/bottom.bmp","Res/top.bmp"));
    viewMatrix = glm::lookAt(cameraPos, glm::vec3(0.0f, 0.0f, -1.0f), glm::vec3(0.0f, 1.0f, 0.0f));

}
void SetViewPortSize(float width, float height){
    projectionMatrix = glm::perspective(50.0f,width/height,0.1f,100.0f);
}
void Draw(){
    glClearColor(0.0f,0.0f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
    model.Draw(viewMatrix, projectionMatrix, cameraPos.x,cameraPos.y, cameraPos.z);
}






