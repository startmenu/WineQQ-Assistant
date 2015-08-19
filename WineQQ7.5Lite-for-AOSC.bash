#!/bin/bash
export TZ="Asia/Shanghai" 
export LANG=zh_CN.UTF-8
export WINETMP=$HOME/WineQQ-temp
export WINEPREFIX=$HOME/WineQQ

echo "欢迎使用Wine QQ安装脚本"
echo
#检查并创建临时目录
if [ -d $HOME/WineQQ-temp ]
then 
    true
else
    mkdir $HOME/WineQQ-temp
fi

if [ -d $HOME/.local/share/icons/hicolor/256x256/apps ]
then 
    true
else
    mkdir -p $HOME/.local/share/icons/hicolor/256x256/apps
fi

if [ -f /usr/bin/wine ]
then 
    true
else 
    echo "请先安装Wine再说，在命令行执行sudo apt-get install wine"
    exit 1
fi

if [ -f /usr/bin/winetricks ]
then
    true
else
    echo "请先安装winetricks，在命令行执行sudo apt-get install winetricks"
    exit 1
fi

if [ -f /usr/bin/7z ]
then 
    true
else 
    echo "此脚本需要用到p7zip，在命令行执行sudo apt-get install p7zip来安装。"
    exit 1
fi

if [ -d $HOME/WineQQ ]
then
    echo "检测到已存在的WineQQ容器，是否删除？"
    echo "若是使用此脚本上次安装所留下的，"
    echo "或是以前用旧版脚本安装过用此版本来更新，请选择删除"
    ping 127.0.0.1 -c 3 >/dev/null
    read -p "是否删除？(y/n) " remove_bottle
    if [ $remove_bottle = "y" ]
    then
        rm -r $HOME/WineQQ
        wineboot >/dev/null 2>&1 
    else
        true
    fi
else
    wineboot >/dev/null 2>&1
fi


get_qq()
#为了实现递归，这里将获取QQ的过程写为函数
{
echo 
echo "即将下载QQ 7.5轻聊版。也可以手动下载，之后放在$WINETMP里"
echo "下载地址：http://dldir1.qq.com/qqfile/qq/QQ7.5Light/15462/QQ7.5Light.exe"
if wget http://dldir1.qq.com/qqfile/qq/QQ7.5Light/15462/QQ7.5Light.exe -P $WINETMP -c
then
    true
else
        read -p "下载未成功，按回车键重新下载（支持断点续传），若要退出脚本手动下载，请按Ctrl + C"
        get_qq
fi
}
get_qq
#调用函数

echo "即将安装WineQQ。安装完毕后如果自动打开QQ登录窗口，请先关闭，因为安装后还需要一些处理才能正常使用，切记！"
ping 127.0.0.1 -c 3 >/dev/null
read -p "按回车键继续"
#可能遇到安装器提示IE版本过低问题
cat >$WINETMP/iehack.reg << EOF
REGEDIT4

[HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer]
"Version"="8.0"
EOF

wine regedit $WINETMP/iehack.reg >/dev/null 2>&1
wine $WINETMP/QQ7.5Light.exe >/dev/null 2>&1
wineserver -k

read -p "刚才点击了“安装完成”按钮吗？(y/n)" install_finished
if [ $install_finished = "y" ]
then
    true
else
    echo "可能安装没有成功，请重新运行此脚本"
    exit 1
fi

echo "正在hack注册表"
cat >$WINETMP/txhack.reg <<EOF
REGEDIT4

[HKEY_CURRENT_USER\Software\Wine\DllOverrides]
"*riched20"="native,builtin"
"riched20.dll"="native,builtin"
"txplatform.exe"=""
"txupd.exe"=""
EOF
wine regedit $WINETMP/txhack.reg >/dev/null 2>&1

echo "正在从QQ可执行程序中提取图标"
7z -y e $WINEPREFIX/drive_c/Program\ Files\ \(x86\)/Tencent/QQLite/Bin/QQ.exe -o$WINETMP/qqicon >/dev/null
cp $WINETMP/qqicon/4  $HOME/.local/share/icons/hicolor/256x256/apps/WineQQ.png

echo "正在创建启动脚本"
cat > $WINEPREFIX/qq_launcher.sh <<EOF
#!/bin/sh
export TZ="Asia/Shanghai" 
export LC_ALL=zh_CN.UTF-8 
export WINEPREFIX=$WINEPREFIX
runqq()
{
wine "C:\Program Files (x86)\Tencent\QQLite\Bin\QQ.exe" >/dev/null 2>&1
}

wineqq_verbose()
{
wine "C:\Program Files (x86)\Tencent\QQLite\Bin\QQ.exe"
}

runhelp()
{
echo 
echo "记住，只有选项能用："
echo "-h 或 --help :  就是你正在看的这些东西"
echo "-v 或 --verbose : 把QQ运行时那些又臭又长的东西显示出来 "
echo "-r 或 --regedit : 呼叫注册表编辑器，胆小者勿入"
echo "-c 或 --winecfg : 召唤winecfg来帮你设置酒瓶"
echo "-t 或 --taskmgr : 开启用来杀进程的任务管理器"
echo "-e 或 --explorer : 打开Wine的文件管理器，然而这并没有什么用"
echo "-w 或 --winetricks : 你懂的"
echo "-k 或 --kill : 关掉把酒瓶里运行的程序都关掉，但不会打碎这个酒瓶"
echo "-u 或 --uninstall ：把酒瓶里的东西全部倒掉（卸载）"
echo
}

case \$1 in
  "-h"|"--help")
  runhelp
  ;;
  "-v"|"--verbose")
  wineqq_verbose
  ;;
  "-r"|"--regedit")
  wine regedit
  ;;
  "-c"|"--winecfg")
  wine winecfg
  ;;
  "-t"|"--taskmgr")
  wine taskmgr
  ;;
  "-e"|"--explorer")
  wine explorer
  ;;
    "-w"|"--winetricks")
  winetricks
  ;;
  "-k"|"--kill")
  wineserver -k
  ;;
  "-u"|"-uninstall")
  rm -rf \$WINEPREFIX
  rm \$HOME/.local/share/applications/wineqq.desktop
  ;;
*)
  if [ -z \$1 ];
  then 
    runqq
  else 
    echo "谁告诉你 $1 这个选项的？"
    runhelp
  fi  
  ;;
 esac
 
EOF
chmod +x $WINEPREFIX/qq_launcher.sh

echo "创建菜单项"
cat >$WINETMP/QQ.desktop <<EOF
[Desktop Entry]
Name=QQ 7.5 Lite
Comment=Tencent QQ 7.5 Lite
Categories=Network;
Exec=$WINEPREFIX/qq_launcher.sh
Icon=WineQQ
Type=Application

EOF

cp $WINETMP/QQ.desktop $HOME/.local/share/applications/wineqq.desktop
echo "安装完成！在主菜单中找到QQ的菜单项启动。"
rm -r $WINETMP
exit 0
