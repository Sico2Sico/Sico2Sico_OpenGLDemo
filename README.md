### OpenGL 使用步骤：

- ### 设置数据源 传入 GPU 

  ```c++
  /// 设置数据源
  float data[] = {
  		-0.2f,-0.2f,-0.6f,1.0f,
  		0.2f,-0.2f,-0.6f,1.0f,
  		0.0f,0.2f,-0.6f,1.0f
  	};
  
  /// 设置GPU缓存 唯一标识
  glGenBuffers(1, &vbo);
  
  /// 属性绑定
  glBindBuffer(GL_ARRAY_BUFFER, vbo);
  
  /// 数据绑定
  glBufferData(GL_ARRAY_BUFFER,sizeof(float)*12,data,GL_STATIC_DRAW);
  glBindBuffer(GL_ARRAY_BUFFER, 0);
  ```

- Shader 创建

  ```c++
  /// 参数为 Shader的类型   GL_FRAGMENT_SHADER  GL_VERTEX_SHADER  
  GLuint shader = glCreateShader(shaderType);
  ```

- shader codeStr 的加载

  ```C++
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
  ```

- ShaderCode导入

  ```c++
  /// 第一个参数 需要链接的Shader  
  /// 第二个参数 有多少个代码
  /// 第三个参数 shaderCode 的地址 多个代码时 为数组
  /// 第四个参数 多个代码的时候 为数组 存放每一个代码的大小
  glShaderSource(shader, 1, &shaderCode, nullptr);
  ```

- Shader 编译

  ```c++
  /// 编译
  glCompileShader(shader);
  
  GLint compileResult = GL_TRUE;
  /// 获取编译是否成功 
  glGetShaderiv(shader, GL_COMPILE_STATUS, &compileResult);
  
  /// 编译失败的话 获取编译失败信息
  if (compileResult == GL_FALSE){
      char szLog[1024] = { 0 };
      GLsizei logLen = 0;
      
      /// 获取编译失败信息
      glGetShaderInfoLog(shader, 1024, &logLen, szLog);
      printf("Compile Shader fail error log : %s \nshader code :\n%s\n", szLog, shaderCode);
      /// 编译失败 删除Shader
      glDeleteShader(shader);
      shader = 0;
  }
  ```

- 创建GPU程序

  ```C++
  GLuint mProgram = glCreateProgram();
  ```

- 程序 附加Shader 

  ```c++
  /// 第一个参数 为创建的程序
  /// 第二个参数 为编译后的Shader
  glAttachShader(mProgram, vsShader);
  glAttachShader(mProgram, fsShader);
  ```

- 链接

  ```c++
  /// 程序链接
  glLinkProgram(mProgram);
  
  /// 删除 Shader
  glDetachShader(mProgram, vsShader);
  glDetachShader(mProgram, fsShader);
  
  /// 获取链接状态
  GLint nResult;
  glGetProgramiv(mProgram, GL_LINK_STATUS, &nResult);
  if (nResult == GL_FALSE){
      char log[1024] = {0};
      GLsizei writed = 0;
      
      /// 链接失败 获取LOg
      glGetProgramInfoLog(mProgram, 1024, &writed, log);
      printf("create gpu program fail,link error : %s\n", log);
      glDeleteProgram(mProgram);
      mProgram = 0;
  }
  ```

- 从程序 获取Shader 属性 地址

  ```c++
  mModelMatrixLocation = glGetUniformLocation(mProgram, "ModelMatrix");
  mViewMatrixLocation = glGetUniformLocation(mProgram, "ViewMatrix");
  mProjectionMatrixLocation = glGetUniformLocation(mProgram, "ProjectionMatrix");
  mIT_ModelMatrix = glGetUniformLocation(mProgram, "IT_ModelMatrix");
  mPositionLocation = glGetAttribLocation(mProgram, "position");
  mColorLocation = glGetAttribLocation(mProgram, "color");
  mTexcoordLocation = glGetAttribLocation(mProgram, "texcoord");
  mNormalLocation = glGetAttribLocation(mProgram, "normal");
  ```

-  选择需要执行的程序

  ```c++
  glUseProgram(mProgram);
  ```

- 设置 M V  P

  ```c++
  /// 第一个参数 变量地址 
  /// 第二个参数 有多少个 
  /// 第三个参数 是否需要转至 
  /// 第四个参数 数据起始地址
  glUniformMatrix4fv(mModelMatrixLocation, 1, GL_FALSE, M);
  glUniformMatrix4fv(mViewMatrixLocation, 1, GL_FALSE, V);
  glUniformMatrix4fv(mProjectionMatrixLocation, 1, GL_FALSE, P);
  ```

- P

  ```c++
  /// 透视投影矩阵
  /// 第一参数 视角  <60度
  /// 第二个参数 宽高比
  /// 第三个参数 最近的距离
  /// 最远的距离
  projectionMatrix = glm:perspective(60,width/height,0.1,1000.0f);
  ```