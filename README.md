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

- 设置 ebo

  ```C++
  GLuint ebo;
  unsigned short indexes[] = {1,2,3,1,3,4};
  glGenBuffers(1,&ebo);
  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER,ebo);
  glBufferData(GL_ELEMENT_ARRAY_BUFFER,sizeof(float)*6,indexes,GL_STATIC_DEAW);
  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER,0);
  
  /// EBO绘制方法
  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER,ebo);
  glDrawElements(GL_TRIANGES,4,GL_UNSINGNED_SHORT,0)
  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER,0); 
  
  ```


- 属性变量的启用

  ```c++
  
  /// 顶点坐标 
  /// 启用
  glEnableVertexAttribArray(mPositionLocation);
  
  /// 第一个参数 地址
  /// 第二个参数 需要读取几个数据(顶点 x y z w 4 ) (颜色 R G B A 4个)
  /// 第三个参数 数据类型
  /// 第四个参数 是否需要转至
  /// 第五个参数 （每一个Code 核心 单独一个单元 数据大小 （顶点+颜色+纹理）-个小的buffer 可以看作是一个二维数组的一行数据） 的大小
  
  /// 第六个参数 改属性从一个code的哪个位置 下标开始获取值 获取值的起始位置或下标
  glVertexAttribPointer(mPositionLocation, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), 0);
  
  /// 颜色
  glEnableVertexAttribArray(mColorLocation);
  glVertexAttribPointer(mColorLocation, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (void*)(sizeof(float) * 4));
  
  /// 纹理坐标
  glEnableVertexAttribArray(mTexcoordLocation);
  glVertexAttribPointer(mTexcoordLocation, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (void*)(sizeof(float) * 8));
  ```



- 纹理设置

  ```c++
  GLuint texture;
  glGenTextures(1, &texture);
  glBindTexture(GL_TEXTURE_2D, texture);
  
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
  
  /// 第一个参数 纹理类型
  /// 第二个参数 0；
  /// 第三个参数 数据类型
  /// 第四个参数 宽度
  /// 第五个参数 高度
  /// 第六个参数 0
  /// 第七个参数 内存中数据类型
  /// 第八个参数 单个数据的数据类型
  /// 第九个参数 数据集起始地址
  /// 拷贝数据到GPU上了
  glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, width, height, 0, GL_RGB, GL_UNSIGNED_BYTE, pixelData);
  
  /// 把当前纹理设置为0 号纹理
  glBindTexture(GL_TEXTURE_2D, 0);
  ```
