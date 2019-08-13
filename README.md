
# 开发环境配置
详细的开发环境配置可以查看[Ledger's documentation](http://ledger.readthedocs.io)的官方文档。 这里只是简要说明一下

### 环境要求
    必须是Linux操作系统， Windows就不要想了。 

### 编译和依赖软件安装
    安装gcc交叉编译工具和C语言。 并配置BOLOS_ENV环境变量， 这个环境变量非常重要， makefile在执行编译操作时是依赖此变量才找到对应的编译工具

### 下载依赖的SDK

注意这个地方有很大的坑， 一定要检查自己的硬件钱包当前的固件版本号， 去其github官方下载SDK时， 注意版本号一定要和固件号一致。 否则会出现很多问题，比如莫名的安装不成功， 或者自动退出。 这些问题在github上总是有人问， 但却没有人告诉原因。我也是自己摸索才发现是这个原因。

### 配置Python loader环境
Ledger是使用Python的一个驱动库将编译的二进制文件写到硬件钱包中。 而且使用这个库可以直接和钱包进行通信。 我们在进行测试的时候也是使用这个库。 所有这个Python loader必须安装成功。 
由于依赖的是Python2.7版本 建议使用沙盒环境。

首先需要安装一下几个包(ubuntu 直接apt install 即可安装)

libudev-dev

libusb-1.0.0-dev

python-dev

> 创建沙盒环境
```shell
virtualenv -p python2.7  ledger
source ledger/bin/active
```

# 如何安装和编译
当上述步骤都成功之后，即可进行编译。
编译只需要在当前目录下的执行`make`即可。
安装和删除只需要执行下面操作:
* Ledger nanaos 连接电脑 并输入PIN码解锁
* 执行`make delete`确保之前的应用已经被删除
* 执行`make load`开始进行源码编译并下载二进制执行文件到钱包中


## 其他
如何想了解LedgerHQ的工作原理可以查看文档 [Ledger's documentation](http://ledger.readthedocs.io)

定义的APDU通信协议可以查看[此文档](./doc.md)