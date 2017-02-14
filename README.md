# AppInteractive

## 简介
该项目是模拟公司项目跟第三方交互的整个闭环操作  
其中：  
——第三方包括server端和app端  
该项目就是实现了一个server端和app端，并且与现有项目之间的互相操作过程

## 逻辑图
口袋助理跳转第三方app逻辑示意图：  
  
![image](https://github.com/tunsuy/ThirdPlatInteraction/blob/master/%E9%80%BB%E8%BE%91%E5%9B%BE/toThirdApp.jpg)  
  
第三方跳转口袋助理逻辑示意图：  
  
![image](https://github.com/tunsuy/ThirdPlatInteraction/blob/master/%E9%80%BB%E8%BE%91%E5%9B%BE/fromThirdApp.jpg)  

## 实现
#### server端：
go语言实现  
一个简易的http服务器，  
分别与自身App和公司项目server进行http通讯  

#### App端：
使用object-c实现的iOS应用  
与自身的server端进行http通讯，  
与公司项目App进行Scheme间的相互调用  

通讯协议：http
