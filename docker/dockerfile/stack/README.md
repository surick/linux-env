# 租赁平台容器化的思考与实践

## 一、为什么要做容器化？

容器化的一些好处，或者说尝试通过容器化技术来解决的开发、测试、上线过程中的一些痛点和需求包括：

* 多测试环境的管理

在团队中，我们通常有多个项目同时进行，这些项目的开发和测试的节奏各不相同，但很可能是交错着进行；即使是同一个项目，也会有不同的版本在同时进行着测试。在测试服务器资源有限的情况下，我们往往需要快速的在服务器上启动、停止某些项目（版本）。

* 测试环境一键生成

新上马一个项目，需要一整套完整的环境，这样的一套环境往往需要开发、运维的参与才能搭建成功，即使这样，也常常需要耗费较多时间。能不能让测试人员，甚至项目经理，都具备这样的环境搭建能力呢？一键生成，自动初始化必要数据等等，都是提效的好方法。

* 开发测试的衔接

开发和测试之间的衔接，如果完全靠人的话，势必会产生效率问题。解决这种配合上的效率问题，最好的办法是职责分明，并且将一些边界责任划分给合适的人。这里我们可以假设让开发负责代码编写，按照规范提交到指定的分支或者打标签；而测试环境部署是由工具自动完成的，工具还会通知测试人员部署的完成。人与人之间的沟通还是非常必要的，但是我们可以用工具来让这种沟通更加高效、更加准确。

* 生产部署

在生产环境中使用容器，可以非常快的根据业务需求，实现横向扩容。容器的启动是毫秒级的（相比于虚拟机分钟级的启动）。当然，容器池需要额外的工作来搭建，本文并无覆盖。

* 版本升级

部署到客户服务器上的应用如何进行升级。我们应用版本还在快速迭代当中，这样的升级必不可少，而且会较为频繁。容器和 DaoCloud 技术的结合，提供了一个方便的方法。

* 开发环境的快速搭建

新成员加入团队以后，怎么样快速融入团队、快速参与开发工作。容器技术可以让开发者在几分钟之内就完成环境的搭建，并且在开发团队内部使用标准环境，也能够让大家养成统一的开发习惯，进一步提升效率。

## 二、容器架构的设计

### 2.1 开发环境

（待完成）

### 2.2 测试环境

租赁平台在架构上由以下几部分组成：

* 管理后台（backend）
是一个 Java Spring 的应用，部署在 Tomcat 下。主要是业务管理系统的后台功能，以 API 的形式向前端提供服务。

* 管理后台的前端（lease-frontend）
是一个纯前端的 React 应用，开发的时候会用 Roadhog 服务器，在测试和生产平台上会部署在 Nginx 反向代理之后。

* 后台任务（job）
跑在后台的任务，独立部署在 Tomcat 里面，没有对外的界面。

* 数据同步服务（netty）
跑在后台，与云平台保持长连接，进行数据的传输。独立部署在 Tomcat 里面，没有对外的界面。

* 微信应用的后台（app）
微信后台应用，部署在 Tomcat 下。

* 微信应用的前端（wap）
是一个纯前端的 React 应用，开发的时候会用 Roadhog 服务器，在测试和生产平台上会部署在 Nginx 反向代理之后。

以上的几个服务都会部署在自己的容器里，除了它们之外，我们还会有以下的几个容器用做支持：

* 数据库（MySQL）
保存所有数据，目前还没有应用分库。

* redis
redis 缓存服务。

* 邮件服务（postfix）
发送邮件的服务。目前这一服务还没有配置好。

### 2.3 生产环境

（待完成）

## 三、基于 DaoCloud 架设持续集成流程

### 3.1 项目设置

我们目前在 DaoCloud 上面配置了以下项目：

* lease-backend
* lease-app
* lease-job
* lease-netty
* lease-frontend

这些项目从名称上可以看出各自的内容。其中前四个其实是共享了同一个代码仓库，最后一个（frontend）目前包含了两个前端应用（lease-frontend 和 wap）。同一次代码提交，我们会构建四次，原因是我们 1）我们目前是源代码级的库依赖，全部在一个仓库里构建会更方便；2）不同的应用需要有自己单独的一个容器。这样的构建方式肯定是存在效率问题，不过我们可以先放一放。

我们设置了构建完成后，自动为构建出来的容器打标签，目前会打 "latest" 和 "<分支名>" 两个标签。其中分支名的标签很重要，我们可以利用这一特性来做我们的多客户项目部署。

### 3.2 应用 Stack 设置

应用 Stack 是一个容器组的概念，我们通常会用多个容器互相配合，提供一个完整的服务。我们在 DaoCloud（自有主机 => Stack）上，配置了一个 lease_platform_qa1 的 Stack，里面包含了租赁平台所有的服务，可以用来复制新的环境（qa2, qa3, ...）或者作为参考来部署剪裁后的服务。

应用 Stack 是由一个 YAML 文件来定义的，我们先来看看完整的定义文件：

```
lease-frontend:
  image: daocloud.io/gizwits2015/lease-frontend:latest
  links:
  - lease-backend:backend
  - lease-app:app
  - lease-job:job
  - lease-netty:netty
  environment:
  - TZ=Asia/Shanghai
  command:
  - nginx
  - -g
  - daemon off;
  restart: always
  ports:
  - 8000:80
  volumes:
  - /data/lease/logs-qa1/nginx:/data/lease/logs
lease-backend:
  image: daocloud.io/gizwits2015/lease-backend:latest
  links:
  - lease-mysql:mysql
  - lease-redis:redis
  ports:
  - 8080:8080
  environment:
  - TZ=Asia/Shanghai
  - MYSQL_USERNAME=xxx
  - MYSQL_PASSWORD=yyy
  volumes:
  - /data/lease/logs-qa1:/data/lease/logs
  restart: always
lease-app:
  image: daocloud.io/gizwits2015/lease-app:latest
  links:
  - lease-mysql:mysql
  - lease-redis:redis
  ports:
  - 8081:8080
  environment:
  - TZ=Asia/Shanghai
  - MYSQL_USERNAME=xxx
  - MYSQL_PASSWORD=yyy
  volumes:
  - /data/lease/logs-qa1:/data/lease/logs
  restart: always
lease-job:
  image: daocloud.io/gizwits2015/lease-job:latest
  links:
  - lease-mysql:mysql
  - lease-redis:redis
  ports:
  - 8082:8080
  environment:
  - TZ=Asia/Shanghai
  - MYSQL_USERNAME=xxx
  - MYSQL_PASSWORD=yyy
  volumes:
  - /data/lease/logs-qa1:/data/lease/logs
  restart: always
lease-netty:
  image: daocloud.io/gizwits2015/lease-netty:latest
  links:
  - lease-mysql:mysql
  - lease-redis:redis
  ports:
  - 8083:8080
  environment:
  - TZ=Asia/Shanghai
  - MYSQL_USERNAME=xxx
  - MYSQL_PASSWORD=yyy
  volumes:
  - /data/lease/logs-qa1:/data/lease/logs
  restart: always
lease-mysql:
  image: index.docker.io/library/mysql:5.7
  volumes:
  - /data/lease/mysql-conf-qa1:/etc/mysql
  - /data/lease/mysql-data-qa1:/var/lib/mysql
  environment:
  - MYSQL_ROOT_PASSWORD=ROOT_PASS
  - MYSQL_DATABASE=gizwits_lease
  - MYSQL_USER=xxx
  - MYSQL_PASSWORD=yyy
  - TZ=Asia/Shanghai
lease-redis:
  image: index.docker.io/library/redis:3.2.10
  volumes:
  - /data/lease/redis-qa1:/data
  environment:
  - TZ=Asia/Shanghai
```

其中，顶格开始的 lease-frontend，lease-mysql 这些是容器的名称，缩进的内容都是该容器相关的配置信息。我们下面来看看每个容器的配置信息。

#### lease-frontend

```
lease-frontend:
  image: daocloud.io/gizwits2015/lease-frontend:latest
  links:
  - lease-backend:backend
  - lease-app:app
  - lease-job:job
  - lease-netty:netty
  environment:
  - TZ=Asia/Shanghai
  command:
  - nginx
  - -g
  - daemon off;
  restart: always
  ports:
  - 8000:80
  volumes:
  - /data/lease/logs-qa1/nginx:/data/lease/logs
```

* image: daocloud.io/gizwits2015/lease-frontend:latest
容器镜像名称，这是一个前端的镜像，连着 Nginx 服务。最后 "latest" 可以换成某个具体的分支，如 "release-xzy"。注意 gitlab 分支的名称是 release/xzy，在镜像标签里会表示成 release-xzy。

* links:
容器间可以通过指定的名称来访问。如 _lease-backend:backend_，其中前面的 lease-backend 是这个 Stack 里面另外一个容器的名称，在当前容器内可以用 backend 这个名称访问 lease-backend 这个容器。如我们在 nginx 的配置文件里，会用以下的表达方式：

```
...

upstream lease_backend {
  server backend:8080;
}

...
```

其中 _server backend:8080;_ 这一行中的 backend 就是这一名称。

* environment:
只有一行来指定容器的时区。

* command:
容器启动命令，这个容器是指启动 Nginx。

* restart: always
在 Docker 服务本身被重启的时候总是重启这个容器。

* ports:
这里的 _- 8000:80_ 是指容器的 80 端口（Nginx）被影射到主机的 8000 端口。我们访问这台主机的 8000 端口，其实就是在访问容器的 Nginx 服务。

* volumes: - /data/lease/logs-qa1/nginx:/data/lease/logs
容器里的日志记录在 /data/lease/logs 里，这个文件夹被影射到主机的 /data/lease/logs-qa1 文件夹。所以，我们可以在主机上直接看 /data/lease/logs-qa1 文件夹中的内容来找到日志。另外，如果我们创建一个新的部署，我们可以吧主机的目录改成如 /data/lease/logs-qa2，或者 /data/lease/logs-xzy，来对应不同的项目。

#### lease-backend

```
lease-backend:
  image: daocloud.io/gizwits2015/lease-backend:latest
  links:
  - lease-mysql:mysql
  - lease-redis:redis
  ports:
  - 8080:8080
  environment:
  - TZ=Asia/Shanghai
  - MYSQL_USERNAME=xxx
  - MYSQL_PASSWORD=yyy
  volumes:
  - /data/lease/logs-qa1:/data/lease/logs
  restart: always
```

* image: daocloud.io/gizwits2015/lease-backend:latest
同上，用的是 lease-backend 这个镜像，可以通过将 latest 替换成不同的分支名称来做不同项目的部署。

* links:
指定了两个容器（分别是 MySQL 和 redis）的容器和引用名称。在配置文件中（application.yml），对 redis 服务的引用是：

```
...

  redis:
    database: 0
    host: redis

...
```

_host: redis_ 中就是这个引用。而对 MySQL 服务的配置在：

```
...

  datasource:
    type: com.alibaba.druid.pool.DruidDataSource
    driverClassName: com.mysql.jdbc.Driver
    url: jdbc:mysql://mysql:3306/gizwits_lease?createDatabaseIfNotExist=true&useUnicode=true&characterEncoding=UTF-8&autoReconnect=true
    
...
```

其中 url: jdbc:mysql://_mysql_:3306 中的第二个 mysql 就是这个引用。

* ports:
容器的 8080 端口影射到主机的 8080 端口。

* environment:

 * TZ=Asia/Shanghai 指定了容器的时区
 * MYSQL_USERNAME=xxx xxx 是 MySQL 服务的用户名
 * MYSQL_PASSWORD=yyy yyy 是 MySQL 服务的密码

* volumes:
日志影射，同样可以将主机的文件夹路径改成 /data/lease/logs-qa2 或者 /data/lease/logs-xzy 这些。好处还有一个，就是容器重新部署、启动后，之前的日志可以得到保留。

* restart: always
在 Docker 服务本身被重启的时候总是重启这个容器。

#### lease-app, lease-job, lease-netty

这三个的配置与 lease-backend 雷同，这里就不赘述了。唯一要注意的是端口影射要区分开来，容器的 8080 端口要影射到主机上 4 个不同的端口（这里是 8080 到 8083）。

#### lease-mysql

```
lease-mysql:
  image: index.docker.io/library/mysql:5.7
  volumes:
  - /data/lease/mysql-conf-qa1:/etc/mysql
  - /data/lease/mysql-data-qa1:/var/lib/mysql
  environment:
  - MYSQL_ROOT_PASSWORD=ROOT_PASS
  - MYSQL_DATABASE=gizwits_lease
  - MYSQL_USER=xxx
  - MYSQL_PASSWORD=yyy
  - TZ=Asia/Shanghai
```

* image: index.docker.io/library/mysql:5.7
用 MySQL 5.7 的社区版本

* volumes:
MySQL 的配置文件影射到主机的 /data/lease/mysql-conf-qa1 文件夹，数据文件影射到主机的 /data/lease/mysql-data-qa1 文件夹。这两个文件夹都可以按照不同的部署来配置，如 /data/lease/mysql-conf-xzy 和 /data/lease/mysql-data-xzy 等。

* environment:

 * MYSQL_ROOT_PASSWORD=ROOT_PASS 指定 MySQL 数据库的 root 密码
 * MYSQL_DATABASE=gizwits_lease 第一次启动时默认创建 gizwits_lease 这个数据库，但没有表结构
 * MYSQL_USER=xxx xxx 是 MySQL 服务的用户名
 * MYSQL_PASSWORD=yyy yyy 是 MySQL 服务的密码
 * TZ=Asia/Shanghai 指定了容器的时区

#### lease-redis

```
lease-redis:
  image: index.docker.io/library/redis:3.2.10
  volumes:
  - /data/lease/redis-qa1:/data
  environment:
  - TZ=Asia/Shanghai
```

* image: index.docker.io/library/redis:3.2.10
指定了 redis 服务容器的镜像地址，官方的 3.2.10 版本。

* volumes:
保存了 redis 的数据，可以在镜像重启的情况下快速加载数据（某些特定情况下）。同样的，主机的文件夹可以配置成 /data/lease/redis-qa2 或者 /data/lease/redis-xzy 这样。

* environment:
指定了容器的时区

### 3.3 常用操作

* 查看日志
* 重启某个服务（容器）
* 重启整个 Stack（应用）
* MySQL 数据
* redis 数据

### 3.4 多项目交付的场景

* 3.4.1 设定项目分支规范

所有要交付（测试）的项目都会建立一个对应的 _release/xxx_ 的分支。比如享智云就是 release/xzy，比如享智云就是 release/mahjong，平台产品可以叫 release/platform。通过这样的配置，不管我们在哪个 release/xxx 分支下提交代码（或者合并代码），DaoCloud 都可以为该分支构建对应的镜像，并且打上对应的标签。

* 3.4.2 创建和配置相应的应用 Stack

在 DaoCloud 上，我们可以为每一个要交付的项目（客户、平台）创建一个相应的应用 Stack，配置的 YAML 可以参考上文所说的内容。可以考虑用这样一套名字：

 * lease_platform_qa1 租赁平台测试环境一
 * lease_platform_qa2 租赁平台测试环境二
 * lease_xzy_qa 享智云测试环境
 * lease_mahjong_qa 麻将机测试环境
 * ……

配置这些环境时要注意的就是：1）主机的端口要分开，如 lease_platform_qa1 用的端口是 8000 (Nginx) 和 8080~8083 (Tomcat)，那么 lease_platform_qa2 可以用 9000 (Nginx) 和 9080~9083 (Tomcat)，依此类推；2）影射到主机上的文件夹名称要区别开来；3）每个容器用的 image 一定是这个项目的分支，不能不带分支，也不能用 latest 分支。

* 3.4.3 提交代码并重新部署

接下来就是往对应的 release/xxx 分支里提交代码的事情了，提交以后，自动打包构建，在手动重新部署一下对应的应用 Stack。有一下几种可选姿势：

 * 手动重新部署整个 Stack，所花时间可能较长，但方便且不易出错；
 * 手动重新部署 Stack 中对应的容器，重启较快，需要熟练技巧；
 * 在项目构建完成后增加直接部署的任务，可以直接部署。这一块尚未尝试，可以自行研究。

## 四、还存在的一些问题

以下是一些还待解决的问题：

* 数据库的版本管理
* 初始化数据库
* 版本库依赖和源代码依赖的权衡
