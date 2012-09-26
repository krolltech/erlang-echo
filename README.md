一个erlang语言的echo服务器，从 https://github.com/tolbrino/hotwheels.git 项目移植出来.
经典的tcp模型。可以不断的丰富加入自己的项目代码。

若需要增大tcp连接数，你需要手动修改自己的操作系统限制.
测试8000个连接同时处理轻松实现。

server== 开始
* step 1 : make %%编译
* step 2 : make erl  %%进入erl终端.
* step 3 : application:start(tcp_link) %% 开启服务器.


client==
* step 1 : make erl %%另一个终端下.
* step 2 : echo_client:start(10).  %% 10 为开启客户端个数.

server== 停止
* step 2 : application:stop(tcp_link). %%停止服务器.


client==
* telnet 127.0.0.1 8081
