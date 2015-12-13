tftp
	0.1 install tftp server

		TFTP 环境搭建：
		
		
		
		(1) Setup tftp server files （下载并安装 tftp）
		$ sudo apt-get install tftpd tftp openbsd-inetd
		
		(2) make a tftp directory
		(新建tftp目录和改变其属性)
		
		Here we make /home/myzr/tftpt be a tftp directory.
		$ mkdir /home/myzr/tftp
		$ chmod 777 /home/myzr/tftp
		
		(3) Open /etc/inetd.conf and edit it
		(修改配置文件的tftp目录)
		
		$ sudo gedit /etc/inetd.conf
		Coment this line :
		#tftp dgram udp wait nobody /usr/sbin/tcpd /usr/sbin/in.tftpd /srv/tftp
		Add new line:
		tftp dgram udp wait nobody /usr/sbin/tcpd /usr/sbin/in.tftpd /home/myzr/tftp
		
		(4)Restarting tftp service
		

1.nfs
	1.1 setup nfs server
		NFS 环境搭建:


		(1) Install NFS server package
		$ sudo apt-get install nfs-kernel-server
		
		
		
		
		(2) Create NFS directory:/home/myzr/nfsroot
		$ mkdir /home/myzr/nfsroot
		(3) Configure mounted directory and authority   pay attation !!!(error : NFS起根文件系统，显示VFS: Unable to mount root fs via NFS,&nb)
		$ sudo gedit /etc/exports
		Add the following line at the end of the file:
		/home/myzr/nfsroot *(rw,sync,no_root_squash)
		/home/spirit/nfsroot *(rw,sync,no_root_squash)

[root@www bin]# vi /etc/exports  
在里面添加“/nfsroot/rootfs                192.168.0.*(rw,sync)”，
其中/nfsroot/rootfs:允许其他计算机访问的目录，

192.168.0.*：被允许访问该目录的客户端IP地址，

r'w：文件系统可读可写，

sync：同步写磁盘（async：资料会先暂存于内存当中，而非直接写入磁盘）。
		
		
		(4) Restart the NFS service
		$ sudo /etc/init.d/portmap restart
		$ sudo /etc/init.d/nfs-kernel-server restart

test:
	mount -t nfs -o nolock 192.168.1.105:/home/bati/weidongshan_rootfs

	other
	 ask :nfs /etc/exports multiple directories

	1.2 set nfs in target linux system
		uboot printenv setenv 
		setenv nfsroot /home/spirit/nfsroot
2.busybox
	2.1 prerequisites 
		Building a minimal RootFS with Busybox, GLIBC and DropBear
		BusyBox is a collection of cut down versions of common UNIX utilities compiled into a single small executable. This makes BusyBox an ideal foundation for resource constrained systems.
		
		Prerequisites
		Install the following prerequisites (assuming an Ubuntu 14.04 build machine):
		
		apt-get install gcc-arm-linux-gnueabi
		apt-get install libncurses5-dev
		apt-get install gawk
	2.2 BusyBox
		BusyBox can be built either as a single static binary requiring no external libraries, or built requiring shared libraries such as GLIBC (default). This setting can be found under BusyBox Settings -> Build Options -> Build BusyBox as a static binary (no shared libs).
		
		I generally choose to build BusyBox to require GLIBC as it is highly likely you will want to run additional applications that will require GLIBC sometime in the future.
		
		wget http://busybox.net/downloads/busybox-1.23.2.tar.bz2
		tar -xjf busybox-1.23.2.tar.bz2
		cd busybox-1.23.2/
		make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- defconfig
		make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- menuconfig

		At the menu, you can configure BusyBox options. Once configured, you can build BusyBox:
		
		make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- 
		make ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- install CONFIG_PREFIX=/home/export/rootfs

		2.2.1 glibc
	2.3 dinamic lib (vs static lib)
				GLIBC
			GLIBC is the GNU C Library and includes common system calls required by executables running on your system.
			
			Download, build and install GLIBC:
			
			wget http://ftp.gnu.org/gnu/libc/glibc-2.21.tar.xz
			tar -xJf glibc-2.21.tar.xz
			mkdir glibc-build
			cd glibc-build/
			../glibc-2.21/configure arm-linux-gnueabi --target=arm-linux-gnueabi --build=i686-pc-linux-gnu --prefix= --enable-add-ons
			make
			make install install_root=/home/export/rootfs 
			Some programs may require libgcc_s.so, otherwise you will receive an error:
			
			error while loading shared libraries: libgcc_s.so.1: cannot open shared object file: No such file or directory 
			libgcc_s.so.1 can be copied over from your arm-linux-gnueabi installation:
			
			cp /usr/lib/gcc-cross/arm-linux-gnueabi/4.7.3/libgcc_s.so.1 /home/export/rootfs/lib 
	2.4 preparing rootfs
		cp busybox   /home/spirit/tmp/make_rootfs/busybox_2/test_busybox1/busybox-1.23.2/examples/bootfloppy/etc/
			➜  etc  tree
			.
			├── fstab
			├── init.d
			│   └── rcS
			├── inittab
			└── profile

		Preparing RootFS
		Once BusyBox and GLIBC has been cross-compiled, you will want to create the remainder of the root file system. Start by creating the necessary directory structure:
		
		mkdir proc sys dev etc/init.d usr/lib
		Now we must mount the /proc & /sys filesystem and populate the /dev nodes. This can be done at runtime by creating a file called etc/init.d/rcS and adding:
		
		#!bin/sh
		mount -t proc none /proc
		mount -t sysfs none /sys
		echo /sbin/mdev > /proc/sys/kernel/hotplug
		/sbin/mdev -s
		and make executable:
		
		chmod +x etc/init.d/rcS 
		You should now have a basic, yet quite functional, BusyBox root file system.

		2.4.0 init.d/rcS
			use mdev or manual

		2.4.1 inittab
			➜  etc  cat inittab 
			::sysinit:/etc/init.d/rcS
			::respawn:-/bin/sh
			tty2::askfirst:-/bin/sh
			::ctrlaltdel:/bin/umount -a -r

				for more detail
				下面看一下busybox中原始的inittab文件内容：
				
				::sysint:/etc/init.d/rcS
				
				::respawn:-/bin/sh
				
				tty2：：askfirst：-/bin/sh
				
				::ctrlaltdel:/bin/umount –a -r
				
				其中第一行指定系统的启动脚本为/etc/init.d/rcS
				
				第二行指定打开一个登录会话
				
				第三行指定在第三个虚拟终端打开一个无须登录验证的shell
				
				第四行指定了当按下ctrl+alt+del组合键时的执行命令
				
		2.4.2 fstab文件：定义了文件系统的各个“挂载点”，需要与实际的系统 相配合。默认的fstab文件内容为：
				
				proc   /proc proc defaults 0 0
				
				其他的根据需要再进行添加，比如devpts  /dev/pts devpts defaults 0 0
				
		profile文件：终端登陆之后首先运行的脚本。

		
		2.4.2 or use  manual creat dev
			添加dev目录及基本设备文件
			调试时要通过串口发送消息到终端显示。因此串口控制台和终端2个设备文件是必不可少的。
			
			#mkdir dev
			
			#mknod dev/console c 5 1
			
			#mknod dev/ttyS0 c 204 64
			
			#mknod dev/null  c 1 3
			
		在启动参数中，设置console=ttyS0


	2.5 add app
		gcc hello.c -o hello.out
		arm-linux-gnueabi-gcc hello.c -o hello.out
 
	
		
100.tips 
	100.1 eabi oabi application binaru interface
\r\n
1.回车换行符，是2个符。一个回车，一个换行。\r仅仅是回车，\n是换行。一个是控制屏幕或者从键盘的Enter键输入。另一个是控制“打印机”！

内核停顿于“Sending DHCP requests”

解决：在uboot的bootarg参数里设置静态IP地址，配合UBOOT环境变量设置：setenv ethaddr  setenv ipaddr setenv serverip setenv netmask setenv gatewayip等等。


bootargs=noinitrd root=/dev/nfs rw nfsroot=192.168.1.88:/home/nfs/rootfs ip=192.168.1.25:192.168.1.1::255.255.255.0 console=ttySAC0,115200 init=/linuxrc mem=64M


101. dev/
	see detail in ./rootfs_make/dev_polulation.txt				
