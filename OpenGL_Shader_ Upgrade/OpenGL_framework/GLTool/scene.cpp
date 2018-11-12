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
glm::vec3 cameraPos(4.0f,3.0f,4.0f);
Model model;

void Init(){
    model.Init("Res/Sphere.obj");
    model.mShader->Init("Res/diffuse_vs.vs","Res/diffuse_vs.fs");
    model.SetPosition(0.0f, 0.0f, 0.0f);

    /// 环境光 *  环境关材质反射系数
    model.SetAmbientMaterial(0.1f,0.1f, 0.1f,1.0f);
    model.mShader->SetVec4("U_AmbientLight", 0.5f,0.6f, 0.3f,1.0f);

    /// 漫反射光
    model.SetDiffuseMaterial(0.4, 0.4, 0.4,1.0f);
    model.mShader->SetVec4("U_DiffuseLight", 0.8f, 0.8f,0.8f,1.0f);
    model.mShader->SetVec4("U_LightPos",1.0, 1.0, 0.0, 0.0);

    viewMatrix = glm::lookAt(cameraPos, glm::vec3(0.0f, 0.0f, 0.0f), glm::vec3(0.0f, 1.0f, 0.0f));

}
void SetViewPortSize(float width, float height){
    projectionMatrix = glm::perspective(50.0f,width/height,0.1f,100.0f);
}
void Draw(){
    glClearColor(0.4f,0.6f, 0.1f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
    model.Draw(viewMatrix, projectionMatrix, cameraPos.x,cameraPos.y, cameraPos.z);
}
