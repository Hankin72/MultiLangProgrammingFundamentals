## java 技术平台

| 技术体系                             | 说明             |
|----------------------------------|----------------|
| java SE(Java Standard Edition)   | Java技术的核心和基础   |
| Java EE(Java Enterprise Edition) | 企业级应用开发的一套解决方案 |
| Java ME(Java Micro Edition)      | 针对移动设备应用的解决方案  |


## JDK (Java Development Kit ：Java开发者工具包)
Java语言的产品是 JDK（Java Development Kit ：Java开发者工具包) ，必须安装JDK才能使用Java语言

### 获取JDK
1、Oracle：https://www.oracle.com/java/technologies/downloads/
2、OpenJDK
通过IDEA在线下载安装，然后配置java，javac环境变量后可开始练习

## 编译运行
```shell
// 编译
javac HelloWolrd.java
// 运行
java HelloWolrd
```

## 程序执行原理
需要编译成计算机化底层可识别的机器语言执行

## JDK的组成，跨平台原理
1、JVM：JVM（Java Virtual Machine）：Java虚拟机, 真正运行Java程序的地方
2、核心类库：调用package
3、开发工具：java，javac
> 编译生成Class文件可跨平台使用: Window JVM, Linux JVM, MacOS JVM ...
