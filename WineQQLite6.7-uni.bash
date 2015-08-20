#!/bin/bash
export TZ="Asia/Shanghai" 
export LANG=zh_CN.UTF-8
export WINETMP=$HOME/WineQQ-temp
export WINEPREFIX=$HOME/WineQQ

echo "欢迎使用Wine QQ 6.7轻聊版安装脚本"
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

if [ -d $HOME/.local/share/applications/ ]
then 
    true
else
    mkdir -p $HOME/.local/share/applications/
fi

wine_staging()
{
echo "正在获取Play on Linux编译好的Wine 1.7.49"
echo "也可以手动下载，放到$WINETMP里，然后重新运行脚本"
echo "下载地址：http://wine.playonlinux.com/binaries/linux-x86/PlayOnLinux-wine-1.7.49-staging-linux-x86.pol"
read -p "按回车键继续，或按Ctrl+C退出脚本，手动下载后再运行"
if wget http://wine.playonlinux.com/binaries/linux-x86/PlayOnLinux-wine-1.7.49-staging-linux-x86.pol -P $WINETMP -c
then 
    true
else
    read -p "下载失败，按回车键重新下载，或按Ctrl+C退出"
    wine_staging
fi

echo
echo "正在解压Wine 1.7.49"

if [ -d $HOME/.winevers ]
then   
    true
else
    mkdir -p $HOME/.winevers
fi

if [ -d $HOME/.winevers/1.7.49-staging ]
then 
    rm -r $HOME/.winevers/1.7.49-staging
    tar xf $WINETMP/PlayOnLinux-wine-1.7.49-staging-linux-x86.pol -C $HOME/.winevers
    mv $HOME/.winevers/wineversion/1.7.49-staging $HOME/.winevers/1.7.49-staging
    rm -r $HOME/.winevers/wineversion $HOME/.winevers/files $HOME/.winevers/playonlinux
    export WINE=$HOME/.winevers/1.7.49-staging/bin/wine
    export WINE_PATH=$HOME/.winevers/1.7.49/bin
else 
    tar xf $WINETMP/PlayOnLinux-wine-1.7.49-staging-linux-x86.pol -C $HOME/.winevers
    mv $HOME/.winevers/wineversion/1.7.49-staging $HOME/.winevers/1.7.49-staging
    rm -r $HOME/.winevers/wineversion $HOME/.winevers/files $HOME/.winevers/playonlinux
    export WINE=$HOME/.winevers/1.7.49-staging/bin/wine
    export WINE_PATH=$HOME/.winevers/1.7.49-staging/bin
fi
}

if [ -f /usr/bin/wine ]
then 
    echo "目前的Wine版本是Wine 1.7.49或更高吗？可以打开一个新的终端标签或窗口，执行wine --version来查看"
    echo "如果不是，请更新Wine版本，或使用Play on Linux编译好的Wine 1.7.49 Staging，否则QQ安装可能会出问题。"
    read -p "y - 安装Wine 1.7.49，n - 继续使用系统的Wine ： " install_staging_or_not
    if [ $install_staging_or_not = "y" ]
    then
        wine_staging
    else
        export WINE=/usr/bin/wine
        export WINE_PATH=/usr/bin
    fi
else 
    echo "没有安装Wine，此脚本将会安装Play on Linux编译的Wine 1.7.49 Staging"
    read -p "按回车键继续，或按Ctrl+C退出脚本"
    wine_staging
fi

if [ -f /usr/bin/7z ]
then 
    true
else 
    echo "此脚本需要用到p7zip，请在安装后重新运行此脚本。（并确认/usr/bin/7z文件存在。）"
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
        $WINE wineboot >/dev/null 2>&1 
    else
        true
    fi
else
    $WINE wineboot >/dev/null 2>&1
fi

#安装字体
get_wenq()
{
install_microhei()
{
echo
echo "正在下载文泉驿微米黑，也可以手动下载并将文件放到$WINETMP下面"
echo "下载地址：http://jaist.dl.sourceforge.net/project/wqy/wqy-microhei/0.2.0-beta/wqy-microhei-0.2.0-beta.tar.gz"
read -p "按回车键继续，或按Ctrl+C退出脚本，手动下载后再运行"
if [ -f $WINETMP/wqy-microhei-0.2.0-beta.tar.gz ]
then
    true
else
    if wget http://jaist.dl.sourceforge.net/project/wqy/wqy-microhei/0.2.0-beta/wqy-microhei-0.2.0-beta.tar.gz -P $WINETMP -c
    then 
        true
    else
        echo
        echo "下载不成功，按回车键重试，或者按Ctrl+C退出，手动下载字体后再重新运行脚本。" 
        install_microhei
    fi
fi

if [ -d $HOME/.fonts ]
then
    true
else
    mkdir -p $HOME/.fonts
fi

tar xf $WINETMP/wqy-microhei-0.2.0-beta.tar.gz -C $WINETMP
cp $WINETMP/wqy-microhei/wqy-microhei.ttc $HOME/.fonts
rm -r $WINETMP/wqy-microhei
}

font_reg()
{
cat > $WINETMP/fonts.reg<<EOF
REGEDIT4

[HKEY_CURRENT_USER\Software\Wine\Fonts\Replacements]
"Arial Unicode MS"="文泉驿微米黑"
"Batang"="文泉驿微米黑"
"Dotum"="文泉驿微米黑"
"Gulim"="文泉驿微米黑"
"Lucida Console"="文泉驿微米黑"
"Microsoft Sans Serif"="文泉驿微米黑"
"Microsoft YaHei"="文泉驿微米黑"
"MingLiU"="文泉驿微米黑"
"MS Gothic"="文泉驿微米黑"
"MS Mincho"="文泉驿微米黑"
"MS PGothic"="文泉驿微米黑"
"MS PMincho"="文泉驿微米黑"
"MS UI Gothic"="文泉驿微米黑"
"NSimSun"="文泉驿微米黑"
"PMingLiU"="文泉驿微米黑"
"SimFang"="文泉驿微米黑"
"SimHei"="文泉驿微米黑"
"SimKai"="文泉驿微米黑"
"SimSun"="文泉驿微米黑"
"Tahoma"="文泉驿微米黑"
"YaHei"="文泉驿微米黑"
"Yahei UI"="文泉驿微米黑"
"宋体"="文泉驿微米黑"
"新細明體"="文泉驿微米黑"
"ＭＳＰゴシック"="文泉驿微米黑"
EOF
iconv -f utf8 -t gbk  $WINETMP/fonts.reg -o $WINETMP/fonts_reg.reg
rm WINETMP/fonts.reg
$WINE regedit  $WINETMP/fonts_reg.reg
$WINE_PATH/wineserver -k
if [ $WINE_PATH = /usr/bin ]
then
    if [ -d /usr/share/wine/font.disable ]
    then
        true
    else
        echo "删除Wine的Tahoma字体，以解决一处乱码的死角，这需要root权限，可能会提示输入密码。"
        sudo mkdir /usr/share/wine/font.disable
        sudo mv /usr/share/wine/fonts/tahoma* /usr/share/wine/font.disable
    fi
else
    mkdir $WINE_PATH/../share/wine/font.disable
    mv $WINE_PATH/../share/wine/fonts/tahoma* $WINE_PATH/../share/wine/font.disable
fi
}

echo
echo "即将设置字体，如果不清楚系统是否有文泉驿微米黑。"
echo "可以在系统设置的字体选项中查看，"
echo "或者在一些文本编辑器的字体设置中看看列表里有没有该字体。"
echo "如果实在不清楚，请选 1"
echo
echo "1 - 现在安装文泉驿微米黑并设置"
echo "2 - 系统里有文泉驿微米黑，直接设置"
echo "3 - 不用了，安装后自行设置字体"
read -p "选择：" font_choice

case $font_choice in
    1)
    install_microhei
    font_reg
    ;;
    2)
    font_reg
    ;;
    3)
    true
    ;;
    *)
    echo
    echo "选项无效，请在1，2，3中选择。"
    echo "再重复一遍："
    get_wenq
    ;;
esac

}

get_wenq

get_qq()
#为了实现递归，这里将获取QQ的过程写为函数
{
echo 
echo "即将下载QQ 6.7轻聊版。也可以手动下载，之后放在$WINETMP里"
echo "下载地址：http://dldir1.qq.com/qqfile/qq/QQ6.7Light/13466/QQ6.7Light.exe"
read -p "按回车键继续，或按Ctrl+C退出脚本，手动下载后再运行"
if wget http://dldir1.qq.com/qqfile/qq/QQ6.7Light/13466/QQ6.7Light.exe -P $WINETMP -c
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
"Version"="6.0"
EOF

$WINE regedit $WINETMP/iehack.reg >/dev/null 2>&1
$WINE $WINETMP/QQ6.7Light.exe >/dev/null 2>&1
$WINE_PATH/wineserver -k

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
$WINE regedit $WINETMP/txhack.reg >/dev/null 2>&1

echo "正在从QQ可执行程序中提取图标"
7z -y e $WINEPREFIX/drive_c/Program\ Files/Tencent/QQ/Bin/QQ.exe -o$WINETMP/qqicon >/dev/null
cp $WINETMP/qqicon/4  $HOME/.local/share/icons/hicolor/256x256/apps/WineQQ.png

echo "正在创建启动脚本"
cat > $WINEPREFIX/qq_launcher.sh <<EOF
#!/bin/sh
export TZ="Asia/Shanghai" 
export LC_ALL=zh_CN.UTF-8 
export WINEPREFIX=$WINEPREFIX
export WINE=$WINE
export WINE_PATH=$WINE_PATH
runqq()
{
\$WINE "C:\Program Files\Tencent\QQ\Bin\QQ.exe" >/dev/null 2>&1
}

wineqq_verbose()
{
\$WINE "C:\Program Files\Tencent\QQ\Bin\QQ.exe"
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
  $WINE regedit
  ;;
  "-c"|"--winecfg")
  $WINE winecfg
  ;;
  "-t"|"--taskmgr")
  $WINE taskmgr
  ;;
  "-e"|"--explorer")
  $WINE explorer
  ;;
  "-k"|"--kill")
  $WINE_PATH/wineserver -k
  ;;
  "-u"|"-uninstall")
  rm -rf \$WINEPREFIX
  rm -rf \$HOME\.winevers
  rm \$HOME/.local/share/applications/wineqq.desktop
  rm \$HOME/.local/share/icons/hicolor/256x256/apps/WineQQ.png
  ;;
*)
  if [ -z \$1 ];
  then 
    runqq
  else 
    echo "谁告诉你 \$1 这个选项的？"
    runhelp
  fi  
  ;;
 esac
 
EOF
chmod +x $WINEPREFIX/qq_launcher.sh

echo "创建菜单项"
cat >$WINETMP/QQ.desktop <<EOF
[Desktop Entry]
Name=QQ 6.7 Lite
Comment=Tencent QQ 6.7 Lite
Categories=Network;
Exec=$WINEPREFIX/qq_launcher.sh
Icon=WineQQ
Type=Application

EOF

cp $WINETMP/QQ.desktop $HOME/.local/share/applications/wineqq.desktop
$WINE_PATH/wineserver -k
echo "安装完成！在主菜单中找到QQ的菜单项启动。"
echo "第一次启动会比较慢，若启动后提示组件注册错误，请选上“不再显示”并确定。"
read -p "按回车键完成"
#rm -r $WINETMP
exit 0
