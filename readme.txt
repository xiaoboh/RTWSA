﻿项目背景:
=============================================================================================
当前互联网应用比较主流的架构是通过nginx反射代理内部web server模式来做负载，这样做的优势明显，通过nginx可以实现分流负载，并

且在nginx代理层可以实施HTTP协议层的控制。

在今天互联网时代，网络攻击问题也日趋严重，针对WEB应用的攻击层出不群，互联网企业面临着巨大的挑战，而在这样的背景下，目前网络

上还没有一款产品可以实现自动实际统计、分析、报警、自动阻断攻击。
=================================================================================================
项目目标:

通过RTWSA （real time web security analytics）项目，为中小企业及个人用户提供一套开源的WEB应用安全监控防御平台

================================================================================================
项目设计：


             Proxy Server1(nginx)                       Porxy Server2(nginx2)   ......
                 /      \                                /        \
          Appserver1  Appserver2 ...(tomcat)     AppServer1    Appserver2(Apache+php)
                \     /                                   \     /
            DataBase master <==> DataBase backup    DataBase master <==> DataBase backup 

以上是互联网主流架构模型，实现在本项目中采用旁路模式接入，统计、分析 



             Proxy Server1(nginx)     ---------------Tcpcopy -----> 将流量复制到  nginx test server                    
                 /      \                               
          Appserver1  Appserver2 ...(tomcat)    
                \     /                                   
            DataBase master <==> DataBase backup     

通过tcpcopy将proxy server的流量通过交换机流量镜像功能，镜像到nginx test server ,在nginx test server中使用lua模式完成统计、

分析，策略生成，最终将统计结果保入数据库以供报表服务器展示


====================================================================================================
需求来源：
如何识别出扫描行为（收集、整理各类扫描器特殊，并将特殊生成特征库，在程序中匹配）
如何识别出针对HTTP的拒绝服务攻击（同1IP或多个IP，连续大量请求同一URL资源 ，或针对某一用户账号接口进行暴力破解）

具体的需求
1、统计被访问最多的 top 50 URL
2、统计发起请求最多的IP top 50
3、匹配攻击特征并记录日志 （特征库 https://www.owasp.org/index.php/Category:OWASP_ModSecurity_Core_Rule_Set_Project ,如贵所user-agent匹配扫描器，跟据正则区配到注入或XSS）




TBD
