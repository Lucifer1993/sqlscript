#!/bin/bash
echo -e "\e[36mLinux 主机配置检查工具 By.Lucifer\e[40m"
echo -e "\e[36m========================================\e[40m"

#应对登录操作系统和数据库系统的用户进行身份标识和鉴别
echo -e "\e[34m身份标识和鉴别-检查\e[40m"
CMD=`awk -F: '($2 == "") { print $1 }' /etc/shadow`
if [ -z "$CMD" ]; then
    echo -e "\e[32m[+]完全符合,不存在空口令账户\e[40m"
else
    echo -e "\e[31m[-]不符合,存在空口令账户 $CMD\e[40m"
    echo -e "\e[37m输出信息: $CMD\e[40m"
fi
echo -e "\e[36m========================================\e[40m"

#系统中仅仅允许root的UID为0，UID为0的帐户具有和root同样的权限。
echo -e "\e[34mroot账户安全-检查\e[40m"
CMD=`awk -F: '($3 == 0) { print $1 }' /etc/passwd`
if [ $CMD="root" ]; then
    echo -e "\e[32m[+]完全符合,root账户权限唯一\e[40m"
else
    echo -e "\e[31m[-]不符合,root账户权限不唯一 $CMD\e[40m"
    echo -e "\e[37m输出信息: $CMD\e[40m"
fi
echo -e "\e[36m========================================\e[40m"

#root用户环境变量中存在当前目录“.”，可能会导致超级用户误执行一个恶意文件。
echo -e "\e[34mroot搜索路径-检查\e[40m"
files=("/.login" "/etc/.login" "/etc/default/login" "/.cshrc" "/etc/skel/local.cshrc" "/etc/skel/local.login" "/etc/skel/local.profile" "/.profile" "/etc/profile")
for file in ${files[@]}
do
    if [ ! -f $file ]; then
        echo -e "\e[32m[+]$file不存在,无恶意文件\e[40m"
    else
        echo -e "\e[31m[-]$file存在,请根据输出信息查看是否有隐藏目录\e[40m"
        CMD=`grep "PATH" $file`
        echo -e "\e[37m$file输出信息:\e[40m"
        echo -e "\e[37m$CMD\e[40m"
    fi
done
echo -e "\e[36m========================================\e[40m"

#操作系统和数据库系统管理用户身份标识应具有不易被冒用的特点，口令应有复杂度要求并定期更换。
echo -e "\e[34m密码策略-检查\e[40m"
passwds=("PASS_MAX_DAYS" "PASS_MIN_DAYS" "PASS_MIN_LEN" "PASS_WARN_AGE")
for passwd in ${passwds[@]}
do
    CMD=`grep "^$passwd\s*[0-9]*$" /etc/login.defs`
    if [ -z "$CMD" ]; then
        echo -e "\e[31m[-]$passwd未设置,不符合\e[40m"
    else
        echo -e "\e[32m[+]$passwd已设置,仔细查看数值是否匹配规范\e[40m"
        echo -e "\e[37m输出信息:\e[40m"
        echo -e "\e[37m$CMD\e[40m"
    fi
done
echo -e "\e[36m========================================\e[40m"

#应启用登录失败处理功能，可采取结束会话、限制非法登录次数和自动退出等措施
echo -e "\e[34m登录失败处理策略-检查\e[40m"
CMD=`grep "account required /lib/security/pam_tally.so deny=3 no_magic_root reset" /etc/pam.d/system-auth`
if [ -z "$CMD" ]; then
    echo -e "\e[31m[+]没有配置[account required /lib/security/pam_tally.so deny=3 no_magic_root reset],请仔细查看输出信息\e[40m"
    CMD=`cat /etc/pam.d/system-auth`
    echo -e "\e[37m/etc/pam.d/system-auth输出信息:\e[40m"
    echo -e "\e[37m$CMD\e[40m"
else
    echo -e "\e[32m[-]已配置[account required /lib/security/pam_tally.so deny=3 no_magic_root reset],完全符合\e[40m"
fi
echo -e "\e[36m========================================\e[40m"

#当对服务器进行远程管理时，应采取必要措施，防止鉴别信息在网络传输过程中被窃听
echo -e "\e[34m远程管理是否加密传输-检查\e[40m"
CMD=`rpm -qa | grep ssh`
echo -e "\e[32m[+]执行命令..rpm -qa | grep ssh,检查ssh\e[40m"
echo -e "\e[37m输出信息:$CMD\e[40m"
CMD=`ps -ef | grep sshd`
echo -e "\e[32m[+]执行命令..ps -ef | grep sshd,检查ssh\e[40m"
echo -e "\e[37m输出信息:$CMD\e[40m"
CMD=`chkconfig --list | grep telnet`
echo -e "\e[32m[+]执行命令..chkconfig --list | grep telnet,检查telnet\e[40m"
echo -e "\e[37m输出信息:$CMD\e[40m"
CMD=`cat /etc/ssh/sshd_config | grep PermitRootLogin`
echo -e "\e[32m[+]执行命令..cat /etc/ssh/sshd_config | grep PermitRootLogin,检查ssh\e[40m"
echo -e "\e[37m输出信息:$CMD\e[40m"
CMD=`cat /etc/sshd_config | grep PermitRootLogin`
echo -e "\e[32m[+]执行命令..cat /etc/sshd_config | grep PermitRootLogin,检查ssh\e[40m"
echo -e "\e[37m输出信息:$CMD\e[40m"
echo -e "\e[36m========================================\e[40m"

#应及时删除多余的、过期的帐户，避免共享帐户的存在。
echo -e "\e[34m未删除无用账户-检查\e[40m"
CMD=`cat /etc/passwd`
echo -e "\e[37m/etc/passwd输出信息:\e[40m"
echo -e "\e[32m$CMD\e[40m"
echo "\n"
CMD=`cat /etc/shadow`
echo -e "\e[37m/etc/shadow输出信息:\e[40m"
echo -e "\e[32m$CMD\e[40m"
echo -e "\e[36m========================================\e[40m"

#应启用访问控制功能，依据安全策略控制用户对资源的访问
echo -e "\e[34m文件权限配置-检查\e[40m"
files=("/etc/passwd" "/etc/shadow" "/etc/group" "/etc/rc.d" "/etc/profile" "/etc/inet.conf" "/etc/xinet.conf")
for file in ${files[@]}
do
    if [ ! -f $file ]; then
        echo -e "\e[32m[+]$file不存在\e[40m"
    else
        CMD=`ls -l $file`
        echo -e "\e[37m输出信息:\e[40m"
        echo -e "\e[37m$file权限: $CMD\e[40m"
    fi
done
echo -e "\e[36m========================================\e[40m"

#应严格限制默认帐户的访问权限，重命名系统默认帐户，修改这些帐户的默认口令
echo -e "\e[34m是否存在默认账号-访谈\e[40m"
echo -e "\e[37m询问管理员是否存在默认账号\e[40m"
echo -e "\e[36m========================================\e[40m"

#应实现操作系统和数据库系统特权用户的权限分离
echo -e "\e[34m账户最小原则-访谈\e[40m"
echo -e "\e[37m询问管理员操作系统管理员和数据库管理员是否为同一自然人\e[40m"
echo -e "\e[36m========================================\e[40m"

#如果登录提示banner信息包含操作系统类型或内核版本等内容，则为恶意攻击者的进一步攻击尝试提供参考信息。建议设置为警示信息，可以对恶意入侵者起到威慑作用。
echo -e "\e[34m登录提示banner显示敏感信息-检查\e[40m"
CMD=`echo "quit" | nc -v 127.0.0.1 20-30`
echo -e "\e[37mbanner输出信息: \n$CMD\e[40m"
echo -e "\e[36m========================================\e[40m"

#避免远程猜解root口令，建议日常维护操作另建一个普通帐户，必要时使用su命令切换到root帐户。
echo -e "\e[34mroot远程登录-检查\e[40m"
CMD=`grep "sufficient" /etc/pam.d/su`
echo -e "\e[37m输出信息: \n$CMD\e[40m"
echo -e "\e[36m========================================\e[40m"

#系统在指定时间内未完成登录，系统将断开登录会话。
echo -e "\e[34m未设置登录超时-检查\e[40m"
CMD=`grep "TMOUT" /etc/profile`
echo -e "\e[37m/etc/profile输出信息: \n$CMD\e[40m"
CMD=`grep "sshd" /etc/hosts.allow`
echo -e "\e[37m/etc/hosts.allow输出信息: \n$CMD\e[40m"
echo -e "\e[36m========================================\e[40m"

#应通过设定终端接入方式、网络地址范围等条件限制终端登录
echo -e "\e[34mIP访问控制-检查\e[40m"
CMD=`grep "ALL:" /etc/hosts.deny`
echo -e "\e[37m/etc/hosts.deny输出信息: \n$CMD\e[40m"
echo -e "\e[36m========================================\e[40m"

#默认Linux系统root登录的tty设备有7个，建议限制tty个数为0个。
echo -e "\e[34mIP设置终端登陆限制安全-检查\e[40m"
CMD=`cat /etc/securetty`
echo -e "\e[37m/etc/securetty输出信息: \n$CMD\e[40m"
echo -e "\e[36m========================================\e[40m"

#cron.allow和at.allow文件列出了允许crontab和at命令的用户名单, 在多数系统上通常只有系统管理员才需要运行这些命令。
echo -e "\e[34m限制at/cron授予用户-检查\e[40m"
files=("/etc/cron.allow" "/etc/at.allow")
for file in ${files[@]}
do
    if [ ! -f $file ]; then
        echo -e "\e[31m[-]$file不存在,不符合\e[40m"
    else
        echo -e "\e[32m[+]$file存在,检查计划任务\e[40m"
        echo -e "\e[37m$file输出信息:\e[40m"
        CMD=`cat $file`
        echo -e "\e[37m$CMD\e[40m"
    fi
done
echo -e "\e[36m========================================\e[40m"

#应对重要服务器进行监视，包括监视服务器的CPU、硬盘、内存、网络等资源的使用情况
echo -e "\e[34m资源监控-检查,访谈\e[40m"
echo -e "\e[37m1、访谈系统管理员，询问系统上是否安装有如下Tivoli的第三方主机监控软件或自制的监控脚本。2、如果有相关文档记录也可参阅。\e[40m"
echo -e "\e[36m========================================\e[40m"

#应限制单个用户对系统资源的最大或最小使用限度
echo -e "\e[34m资源使用限制-检查,访谈\e[40m"
CMD=`grep "hard" /etc/security/limits.conf`
echo -e "\e[37m/etc/security/limits.conf输出信息: \n$CMD\e[40m"
echo -e "\e[36m========================================\e[40m"

#应能够对系统的服务水平降低到预先规定的最小值进行检测和报警
echo -e "\e[34m资源报警-检查,访谈\e[40m"
CMD=`df -k`
echo -e "\e[37m磁盘状况输出信息: \n$CMD\e[40m"
echo -e "\e[36m========================================\e[40m"

#创建文件或目录时，将使用一组缺省权限进行创建，Linux默认为022，即文件属主所在的组用户和其他组用户没有写权限，根据安全性级别不同，SUN建议设为027,026,077。
echo -e "\e[34m默认文件安全属性umask-检查\e[40m"
CMD=`umask`
echo -e "\e[37mumask输出信息: \n$CMD\e[40m"
echo -e "\e[36m========================================\e[40m"

#对于重要的目录或者文件，如果设为所有的用户可读写，则很容易造成数据泄露或者破坏。
echo -e "\e[34m存在全局可写的文件或者目录-检查\e[40m"
#CMD=`find / -type d -perm -2`
echo -e "\e[37m可写目录输出信息: \n$CMD\e[40m"
echo -e "\e[36m========================================\e[40m"

#passwd、group、shadow包含有用户信息、组信息和经过加密保护的密码信息。此文件和其相关的拷贝文件，只能由所有者root拥有读或写的权限。
echo -e "\e[34m帐户密码文件属性安全-检查\e[40m"
files=("/etc/passwd" "/etc/shadow" "/etc/group")
for file in ${files[@]}
do
    CMD=`ls -l $file`
    echo -e "\e[37m$file权限输出信息: \n$CMD\e[40m"
done
echo -e "\e[36m========================================\e[40m"

#操作系统应遵循最小安装的原则，仅安装需要的组件和应用程序，并通过设置升级服务器等方式保持系统补丁及时得到更新。
echo -e "\e[34m最小原则，补丁更新-检查,访谈\e[40m"
echo -e "\e[37mchconfig输出信息: \n访谈系统管理员系统目前是否采取了最小化安装原则\e[40m"
echo -e "\e[36m========================================\e[40m"

#系统默认安装开启了许多不必要的服务，带来诸多的安全问题。应有选择关闭无用的网络服务，在保证业务系统正常运行下，选择关闭不必要的服务。
echo -e "\e[34m关闭不必要的网络服务-检查\e[40m"
files=("tftp" "echo" "discard" "daytime" "chargen" "rsh" "rexecd" "fingerd" "in.lpd" "rpc.ttdbserver" "rcp" "sadmind" "talk" "comsat" "uucp" "cups" "isdn" "iptables" "sendmail" "hpoj" "xfs")
echo -e "\e[37mchconfig输出信息: \e[40m"
for file in ${files[@]}
do
    CMD=`/sbin/chkconfig --list | grep $file`
    if [ ! -z "$CMD" ]; then
        echo $CMD
    fi
done
echo -e "\e[36m========================================\e[40m"

#ping命令是计算机之间进行相互检测线路完好的一个应用程序，计算机间交流数据的传输没有经过任何的加密处理，因此我们在用ping命令来检测某一个服务器时，可能在因特网上存在某个非法分子，通过专门的黑客程序把在网络线路上传输的信息中途窃取，并利用偷盗过来的信息对指定的服务器或者系统进行攻击，为此我们有必要在Linux系统中禁止使用Linux命令，如果没人能ping通你的系统，安全性自然增加了。
echo -e "\e[34m阻止ping服务-检查\e[40m"
CMD=`grep "icmp_echo_ignore_all" /etc/sysctl.conf`
if [ -z "$CMD" ]; then
    echo -e "\e[31m[-]不符合,net.ipv4.icmp_echo_ignore_all未设置\e[40m"
else
    echo -e "\e[32m[+]完全符合,已设置net.ipv4.icmp_echo_ignore_all\e[40m"
    echo -e "\e[37m/etc/sysctl.conf输出信息: \n$CMD\e[40m"
fi
echo -e "\e[36m========================================\e[40m"

#应能够检测到对重要服务器进行入侵的行为，能够记录入侵的源IP、攻击的类型、攻击的目的、攻击的时间，并在发生严重入侵事件时提供报警
echo -e "\e[34m入侵检测-检查,访谈\e[40m"
CMD=`grep "refused" /var/log/secure`
if [ -z "$CMD" ]; then
    echo -e "\e[31m[-]不符合,/var/log/secure文件未设置refused\e[40m"
else
    echo -e "\e[32m[+]完全符合,存在/var/log/secure文件\e[40m"
    echo -e "\e[37m/etc/sysctl.conf输出信息: \n$CMD\e[40m"
fi
echo -e "\e[37m/var/log/secure输出信息: \n$CMD\e[40m"
CMD=`iptables -L`
echo -e "\e[37miptables输出信息: \n$CMD\e[40m"
echo -e "\e[36m========================================\e[40m"

#应安装防恶意代码软件，并及时更新防恶意代码软件版本和恶意代码库
echo -e "\e[34m应安装防病毒软件-访谈\e[40m"
echo -e "\e[37m查看系统中安装了什么防病毒软件。询问管理员病毒库是否经常更新。查看病毒库的最新版本更新日期是否超过一个星期。\e[40m"
echo -e "\e[36m========================================\e[40m"

#审计范围应覆盖到服务器和重要客户端上的每个操作系统用户和数据库用户
echo -e "\e[34m打开日志审计-检查\e[40m"
CMD=`service syslog status`
echo -e "\e[32m[+]执行命令..service syslog status,检查syslog状态\e[40m"
echo -e "\e[37m输出信息: \n$CMD\e[40m"
CMD=`service audit status`
echo -e "\e[32m[+]执行命令..service audit status,检查audit状态\e[40m"
echo -e "\e[37m输出信息: \n$CMD\e[40m"
CMD=`ps -ef | grep auditd`
echo -e "\e[32m[+]执行命令..ps -ef | grep auditd,检查auditd进程\e[40m"
echo -e "\e[37m输出信息: \n$CMD\e[40m"
echo -e "\e[36m========================================\e[40m"

#审计内容应包括重要用户行为、系统资源的异常使用和重要系统命令的使用等系统内重要的安全相关事件
echo -e "\e[34m审计内容-检查\e[40m"
files=("/etc/audit/filter.conf" "/etc/syslog.conf" "/etc/audit/audit.conf")
for file in ${files[@]}
do
    if [ ! -f $file ]; then
        echo -e "\e[31m[+]$file不存在,不符合\e[40m"
    else
        CMD=`cat $file`
        echo -e "\e[32m[-]$file存在,请根据输出信息查看是否符合规范\e[40m"
        echo -e "\e[37m输出信息: \n\e[40m"
        echo -e "\e[37m$CMD\e[40m"
    fi
done
echo -e "\e[36m========================================\e[40m"

#应保护审计记录，避免受到未预期的删除、修改或覆盖等
echo -e "\e[34m审计要素-检查\e[40m"
CMD=`aucat | tail -10`
echo -e "\e[32m[+]执行命令..aucat | tail -10,查看审计记录\e[40m"
echo -e "\e[37m输出信息: \n$CMD\e[40m"
CMD=`augrep -e TEXP -U AUTH_success`
echo -e "\e[32m[+]执行命令..augrep -e TEXP -U AUTH_success,查看PAM成功授权\e[40m"
echo -e "\e[37m输出信息: \n$CMD\e[40m"
filet="/etc/var/seclog"
if [ ! -f $filet ]; then
        echo -e "\e[31m[+]$file不存在,不符合\e[40m"
    else
        echo -e "\e[32m[-]$filet存在,完全符合\e[40m"
fi
echo -e "\e[36m========================================\e[40m"
####################
echo -e "\e[34m审计记录保护-检查\e[40m"
echo -e "\e[37m同上\e[40m"
echo -e "\e[36m========================================\e[40m"

#应能够根据审计记录数据进行分析，并生成审计报表
echo -e "\e[34m审计记录分析-访谈\e[40m"
echo -e "\e[37m访谈并查看对审计记录的查看、分析和生成审计报表情况\e[40m"


