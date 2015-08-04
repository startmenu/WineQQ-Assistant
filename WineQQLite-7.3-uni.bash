#!/bin/sh
export WINEPREFIX=$HOME/wineqq-bottle
export TZ="Asia/Shanghai"
export WINEARCH=win32
export LANG=zh_CN.UTF-8
export WINETMP=$HOME/WineQQ-temp
clear
echo "脚本我将帮你安装QQ 7.3轻聊版"
echo "安装过程中请保证网络畅通，否则，嘿嘿～"
echo

if [ -d $HOME/WineQQ-temp ]
then 
  true
else
  mkdir $HOME/WineQQ-temp
fi

check_dep()
{
  #检查wget
  if [ -f /usr/bin/wget ]
  then
    true
  else
    echo
    echo "没有找到/usr/bin/wget，你装了wget吗？"
    echo "脚本我不管你有没有装，反正就是要装，装到别的地方链接过去也要链接过去！"
    echo "不管你是从源里装，还是自己编译。"
    echo "反正脚本我只认/usr/bin/wget，"
    echo "别的都不管，不管，不管，不管，不管……"
    exit 1
  fi
  
  #检查winetricks及其依赖是否安装
  if [ -f /usr/bin/cabextract ]
  then
    true
  else
    echo
    echo "没有找到/usr/bin/cabextract，你装了cabexteact吗？"
    echo "脚本我不管你有没有装，反正就是要装，装到别的地方链接过去也要链接过去！"
    echo "不管你是从源里装，还是自己编译。"
    echo "反正脚本我只认/usr/bin/cabextract，"
    echo "别的都不管，不管，不管，不管，不管……"
    exit 1
  fi

  if [ -f /usr/bin/7z ]
  then
    true
  else
    echo
    echo "没有找到/usr/bin/7z，你装了p7zip吗？"
    echo "脚本我不管你有没有装，反正就是要装，装到别的地方链接过去也要链接过去！"
    echo "不管你是从源里装，还是自己编译。"
    echo "反正脚本我只认/usr/bin/7z，"
    echo "别的都不管，不管，不管，不管，不管……"
    exit 1
  fi
  
}

check_wine()
{



get_wine_staging()
{
  #下载Wine 1.7.45， 不可以中途逃跑哦
  echo
  echo "从Play on Linux网站拿东西，做好心理准备，速度可能不理想哦。"
  echo "如果你觉得速度太慢，也可以手动下载，比如用浏览器，或者用其他工具下载"
  echo "完成后，放在你的主目录下的WineQQ-temp文件夹（$WINETMP）下"
  echo "下载地址：http://wine.playonlinux.com/binaries/linux-x86/PlayOnLinux-wine-1.7.48-staging-linux-x86.pol"
  if [ -f $WINETMP/PlayOnLinux-wine-1.7.48-staging-linux-x86.pol ]
  then true
  else
    read -p "按回车键继续"
    if wget http://wine.playonlinux.com/binaries/linux-x86/PlayOnLinux-wine-1.7.48-staging-linux-x86.pol -P $WINETMP -c
    then 
      true
    else
      echo
      read -p "下载失败，是否重试（支持断点续传）？(y/n)" ch1
      if [ $ch1 = "y" ]
 then 
   get_wine_staging
 else
   echo
   echo "那算了。等你心情好的时候，或者手动下载好的时候重新运行这脚本吧。"
   exit 1
      fi
    fi
  fi
  
  #gecko和mono也是关键，如果你不想要，来砍我呀！
  echo
  echo "现在开始下载Wine的Gecko模块"
  echo "如果你觉得速度太慢，也可以手动下载，比如用浏览器，或者用其他工具下载"
  echo "完成后，放在你的主目录下的WineQQ-temp文件夹（$WINETMP）下"
  echo "下载地址：http://wine.playonlinux.com/gecko/x86/wine_gecko-2.36-x86.msi"
  if [ -f $WINETMP/wine_gecko-2.36-x86.msi ]
   then true
   else
    read -p "按回车键继续"
    if wget http://wine.playonlinux.com/gecko/x86/wine_gecko-2.36-x86.msi -P $WINETMP -c
   then 
      true
   else
    echo
    read -p "下载失败，是否重试（支持断点续传）？(y/n)" ch1
    if [ $ch1 = "y" ]
    then 
      get_wine_staging
    else
      echo
      echo "那算了。等你心情好的时候，或者手动下载好的时候重新运行这脚本吧。"
      exit 1
    fi
   fi
  fi
  
  echo
  echo "现在开始下载Wine的Mono模块"
  echo "如果你觉得速度太慢，也可以手动下载，比如用浏览器，或者用其他工具下载"
  echo "完成后，放在你的主目录下的WineQQ-temp文件夹（$WINETMP）下"
  echo "下载地址：http://jaist.dl.sourceforge.net/project/wine/Wine Mono/4.5.6/wine-mono-4.5.6.msi"
  if [ -f $WINETMP/wine-mono-4.5.6.msi ]
   then
    true
   else
    read -p "按回车键继续"
    if wget http://jaist.dl.sourceforge.net/project/wine/Wine Mono/4.5.6/wine-mono-4.5.6.msi -P $WINETMP -c
     then 
      true
     else
      echo
      read -p "下载失败，是否重试（支持断点续传）？(y/n)" ch1
 if [ $ch1 = "y" ]
 then 
   get_wine_staging
 else
   echo
   echo "那算了。等你心情好的时候，或者手动下载好的时候重新运行这脚本吧。"
   exit 1
 fi
   fi
  fi
  
  echo
  clear
  echo "很好，都下载完了。现在开始施法～"
  tar xf $WINETMP/PlayOnLinux-wine-1.7.48-staging-linux-x86.pol -C $WINETMP
  mv $WINETMP/wineversion $HOME/.wineversion
  #如果你不想要的话，砍了它
  mkdir $HOME/.wineversion/1.7.48-staging/share/wine/mono
  mkdir $HOME/.wineversion/1.7.48-staging/share/wine/gecko
  cp $WINETMP/wine-mono-4.5.6.msi $HOME/.wineversion/1.7.48-staging/share/wine/mono
  cp $WINETMP/wine_gecko-2.36-x86.msi $HOME/.wineversion/1.7.48-staging/share/wine/gecko
  export WINE_EXEC=$HOME/.wineversion/1.7.48-staging/bin
}

#检查wine是否安装
if [ -f /usr/bin/wine ]
then
  echo
  echo "原来你系统安装了Wine啊。那你的Wine版本够新吗，有1.7.35以上吗？"
  echo "Play on Linux提供了Wine 1.7.48 staging的包，要不要试一下？（放心，不会替换系统原有版本的。）"
  echo "如果你的Wine版本低于1.7.35，又不装1.7.48 staging的话，奉劝你还是别装Wine QQ了。"
  read -p "y - 要！，n - 坚持用现有的Wine版本  " install_staging
    if [ $install_staging = "y" ]
      then
 echo
 echo "嗯，果然你还是想尝尝Wine 1.7.45 staging的嘛～"
 echo "不要谢我，这是Play on Linux编译的版本"
 echo
 get_wine_staging
      else
 echo 
 echo "那你是坚持用自己的Wine咯…… 如果版本不达标，可别怪我啊"
 echo
 export WINE_EXEC=/usr/bin
      fi
else
  echo
  echo "不知道是此脚本无能，还是你没装Wine…… 总之就是没有找到你的Wine。"
  echo "要不要试一下Wine 1.7.45 staging。这是Play on Linux提供的。"
  read -p "按回车键继安装，如果不想安装按Ctrl-C退出。"
  get_wine_staging
  
fi
}

check_winetricks()
{


if [ -f /usr/bin/winetricks ]
then
  export WINETRICKS_EXEC=/usr/bin
elif [ $HOME/.local/share/winetricks ]
    then 
      export WINETRICKS_EXEC=$HOME/.local/share
else    
  echo
  read -p "没有找到winetricks，现在安装。若现在无法安装，请按Ctrl-C退出。"
  wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks -p $HOME/.local/share -c
  export WINETRICKS_EXEC=$HOME/.local/share
  check_winetricks
fi
}

#为后面的检查做准备
app_folder_ready=0
icon_folder_ready=0

check_folders()
{
  making_app_folder()
  {
    if [ -d $HOME/.local/share/applications ]
    then 
       app_folder_ready=1
    elif [ -d $HOME/.local/share ]
    then
      mkdir $HOME/.local/share/applications
    elif [ -d $HOME/.local ]
    then
      mkdir $HOME/.local/share
    else 
      mkdir $HOME/.local/ 
    fi
  }

  making_icon_folder()
  {
  if [ -d $HOME/.local/share/icons ]
    then 
       icon_folder_ready=1
    else
      mkdir $HOME/.local/share/icons
    fi
  }
  
  if [ $app_folder_ready = 1 ]
    then 
      true
    else
      making_app_folder
      check_folders
  fi
  
  if [ $icon_folder_ready = 1 ]
  then
    true
  else
    making_icon_folder
    check_folders
  fi
}

create_bottle()
{
#判断是否已经存在$HOME/wineqq-bottle
#若已存在，提示用户是否重来
if [ -d $HOME/wineqq-bottle ]
  then
    echo
    read -p " $HOME/wineqq-bottle 容器已存在，是否删除并重新创建？(y/n) " bottle_exist
    if [ $bottle_exist = "y" ]
      then
        echo
 echo "删除容器"
 rm -fr $HOME/wineqq-bottle
 echo "正在创建Wine QQ的容器"
 env WINEPREFIX=$WINEPREFIX LANG=$LANG  TZ=$TZ WINEARCH=$WINEARCH $WINE_EXEC/wineboot >/dev/null 2>&1
      else
 true
    fi
  else
    echo
    echo "正在创建Wine QQ的容器"
    env WINEPREFIX=$WINEPREFIX LANG=$LANG TZ=$TZ WINEARCH=$WINEARCH $WINE_EXEC/wineboot >/dev/null 2>&1
 fi
}

basedlls()
{
echo
echo "即将安装一些基本组件"
env WINEPREFIX=$WINEPREFIX LANG=$LANG  TZ=$TZ WINEARCH=$WINEARCH $WINETRICKS_EXEC/winetricks riched30  msls31  msxml6 vcrun2005
}

get_wenq_font()
{
set_microhei()
{
echo
echo "你可以自己下载字体然后放到$WINETMP下面"
echo "下载地址：http://jaist.dl.sourceforge.net/project/wqy/wqy-microhei/0.2.0-beta/wqy-microhei-0.2.0-beta.tar.gz"
if [ -f $WINETMP/wqy-microhei-0.2.0-beta.tar.gz ]
then true
else
read -p "或者按回车键让脚本来下载"
if wget http://jaist.dl.sourceforge.net/project/wqy/wqy-microhei/0.2.0-beta/wqy-microhei-0.2.0-beta.tar.gz -P $WINETMP -c
then 
  true
else
  echo
  echo "下载失败啦！按回车键重试，或者按Ctrl-C退出然后重来" 
  read -p "实在下载不下来也不必勉强，运行脚本时跳过字体安装或者自己手动下载吧"
  set_microhei
fi
fi
cat > $WINETMP/wenq_microhei.reg<<EOF
REGEDIT4

[HKEY_CURRENT_USER\Software\Wine\Fonts\Replacements]
"Arial"="WenQuanYi Micro Hei"
"Arial Unicode MS"="WenQuanYi Micro Hei"
"Batang"="WenQuanYi Micro Hei"
"BatangChe"="WenQuanYi Micro Hei"
"Courier New"="WenQuanYi Micro Hei"
"DFKai-SB"="WenQuanYi Micro Hei"
"Dotum"="WenQuanYi Micro Hei"
"DotumChe"="WenQuanYi Micro Hei"
"FangSong"="WenQuanYi Micro Hei"
"Gulim"="WenQuanYi Micro Hei"
"GulimChe"="WenQuanYi Micro Hei"
"KaiTi"="WenQuanYi Micro Hei"
"Lucida Console"="WenQuanYi Micro Hei"
"Microsoft JhengHei"="WenQuanYi Micro Hei"
"Microsoft Sans Serif"="WenQuanYi Micro Hei"
"Microsoft YaHei"="WenQuanYi Micro Hei"
"MingLiU"="WenQuanYi Micro Hei"
"MS Gothic"="WenQuanYi Micro Hei"
"MS Mincho"="WenQuanYi Micro Hei"
"MS PGothic"="WenQuanYi Micro Hei"
"MS PMincho"="WenQuanYi Micro Hei"
"MS Sans Serif"="WenQuanYi Micro Hei"
"MS UI Gothic"="WenQuanYi Micro Hei"
"NSimSun"="WenQuanYi Micro Hei"
"PMingLiU"="WenQuanYi Micro Hei"
"SimFang"="WenQuanYi Micro Hei"
"SimHei"="WenQuanYi Micro Hei"
"SimKai"="WenQuanYi Micro Hei"
"SimSun"="WenQuanYi Micro Hei"
"Tahoma"="WenQuanYi Micro Hei"
"Times New Roman"="WenQuanYi Micro Hei"
"YaHei"="WenQuanYi Micro Hei"
"YaHei UI"="WenQuanYi Micro Hei"
"宋体"="WenQuanYi Micro Hei"
"新細明體"="WenQuanYi Micro Hei"
"ＭＳＰゴシック"="WenQuanYi Micro Hei"

EOF
iconv -f utf8 -t gbk $WINETMP/wenq_microhei.reg -o $WINETMP/wenq_microhei.reg
env WINEPREFIX=$WINEPREFIX LANG=$LANG WINEARCH=$WINEARCH TZ=$TZ $WINE_EXEC/wine regedit $WINETMP/wenq_microhei.reg >/dev/null 2>&1
env WINEPREFIX=$WINEPREFIX LANG=$LANG WINEARCH=$WINEARCH TZ=$TZ $WINE_EXEC/wineserver -k

echo "现在干掉Wine的Tahoma字体，如果你选的是使用系统的Wine，可能sudo会问你要密码"
if [ $WINE_EXEC = "/usr/bin" ] 
then
  sudo rm /usr/share/wine/fonts/tahoma.ttf
  sudo rm /usr/share/wine/fonts/tahomabd.ttf
else
  rm $HOME/.wineversion/1.7.45-staging/share/wine/fonts/tahoma.ttf
  rm $HOME/.wineversion/1.7.45-staging/share/wine/fonts/tahomabd.ttf
fi

}

set_zenhei()
{
echo
echo "你可以自己下载字体然后放到$WINETMP下面"
echo "下载地址：http://jaist.dl.sourceforge.net/project/wqy/wqy-zenhei/0.9.45 (Fighting-state RC1)/wqy-zenhei-0.9.45.tar.gz"
if [ -f $WINETMP/wqy-zenhei-0.9.45.tar.gz ]
then true
else
read -p "或者按回车键让脚本来下载"
if wget "http://jaist.dl.sourceforge.net/project/wqy/wqy-zenhei/0.9.45 (Fighting-state RC1)/wqy-zenhei-0.9.45.tar.gz" -P $WINETMP -c
then 
  true
else
  echo
  echo "下载失败啦！按回车键重试，或者按Ctrl-C退出然后重来" 
  read -p "实在下载不下来也不必勉强，运行脚本时跳过这个字体的安装或者手动下载吧"
  set_zenhei
fi
fi

cat > $WINETMP/wenq_zenhei.reg<<EOF
REGEDIT4

[HKEY_CURRENT_USER\Software\Wine\Fonts\Replacements]
"Arial"="WenQuanYi Zen Hei"
"Arial Unicode MS"="WenQuanYi Zen Hei"
"Batang"="WenQuanYi Zen Hei"
"BatangChe"="WenQuanYi Zen Hei"
"Courier New"="WenQuanYi Zen Hei"
"DFKai-SB"="WenQuanYi Zen Hei"
"Dotum"="WenQuanYi Zen Hei"
"DotumChe"="WenQuanYi Zen Hei"
"FangSong"="WenQuanYi Zen Hei"
"Gulim"="WenQuanYi Zen Hei"
"GulimChe"="WenQuanYi Zen Hei"
"KaiTi"="WenQuanYi Zen Hei"
"Lucida Console"="WenQuanYi Zen Hei"
"Microsoft JhengHei"="WenQuanYi Zen Hei"
"Microsoft Sans Serif"="WenQuanYi Zen Hei"
"Microsoft YaHei"="WenQuanYi Zen Hei"
"MingLiU"="WenQuanYi Zen Hei"
"MS Gothic"="WenQuanYi Zen Hei"
"MS Mincho"="WenQuanYi Zen Hei"
"MS PGothic"="WenQuanYi Zen Hei"
"MS PMincho"="WenQuanYi Zen Hei"
"MS Sans Serif"="WenQuanYi Zen Hei"
"MS UI Gothic"="WenQuanYi Zen Hei"
"NSimSun"="WenQuanYi Zen Hei"
"PMingLiU"="WenQuanYi Zen Hei"
"SimFang"="WenQuanYi Zen Hei"
"SimHei"="WenQuanYi Zen Hei"
"SimKai"="WenQuanYi Zen Hei"
"SimSun"="WenQuanYi Zen Hei"
"Tahoma"="WenQuanYi Zen Hei"
"Times New Roman"="WenQuanYi Zen Hei"
"YaHei"="WenQuanYi Zen Hei"
"YaHei UI"="WenQuanYi Zen Hei"
"宋体"="WenQuanYi Zen Hei"
"新細明體"="WenQuanYi Zen Hei"
"ＭＳＰゴシック"="WenQuanYi Zen Hei"

EOF

iconv -f utf8 -t gbk  $WINETMP/wenq_zenhei.reg -o $WINETMP/wenq_zenhei.reg
env WINEPREFIX=$WINEPREFIX LANG=$LANG WINEARCH=$WINEARCH TZ=$TZ $WINE_EXEC/wine regedit $WINETMP/wenq_zenhei.reg >/dev/null 2>&1
env WINEPREFIX=$WINEPREFIX LANG=$LANG WINEARCH=$WINEARCH TZ=$TZ $WINE_EXEC/wineserver -k

echo "现在干掉Wine的Tahoma字体，如果你选的是使用系统的Wine，可能sudo会问你要密码"
if [ $WINE_EXEC = "/usr/bin" ] 
then
  sudo rm /usr/share/wine/fonts/tahoma.ttf
  sudo rm /usr/share/wine/fonts/tahomabd.ttf
else
  rm $HOME/.wineversion/1.7.48-staging/share/wine/fonts/tahoma.ttf
  rm $HOME/.wineversion/1.7.48-staging/share/wine/fonts/tahomabd.ttf
fi

}
echo
echo "你要安装文泉驿字体吗？如果你没有字体hack，还是安装吧，免得吃tofu"
echo "1 - 安装文泉驿微米黑"
echo "2 - 安装文泉驿正黑"
echo "3 - 都要！设置为微米黑"
echo "4 - 都要！设置为正黑"
echo "5 - 免啦，我自己有字体！"
read -p "选择：" font_choice

case $font_choice in
  1)
  set_microhei
  ;;
  2)
  set_zenhei
  ;;
  3)
  set_zenhei
  set_microhei
  ;;
  4)
  set_microhei
  set_zenhei
  ;;
  5)
  true
  ;;
  *)
  echo
  echo "你不会以为我像刚才几个选择题一样能随便糊弄吧…… 快给我重选！"
  echo "我再啰嗦一遍："
  get_wenq_font
  ;;
esac

}

get_qq()
{
echo
echo "即将下载QQ轻聊版，也可以手动下载，放到$WINETMP下面，然后重新运行脚本"
echo "下载地址：http://dldir1.qq.com/qqfile/qq/QQ7.3Light/14258/QQ7.3Light.exe"
#判断是否下载成功，若没有，提示重新下载
if [ -f $WINETMP/QQ6.7Light.exe ]
then
  true
else
echo "正在下载QQ 7.3 轻聊版"
if
  wget http://dldir1.qq.com/qqfile/qq/QQ7.3Light/14258/QQ7.3Light.exe -P $WINETMP -c
then 
  true
else
  read -p "没有成功下载，是否重试？（y/n）：" get_qq_again
  
   if [ $get_qq_again = "y" ]
   then 
      get_qq
   else
      echo "没完成下载怎么继续安装……"
      exit 1
   fi
fi
fi
}

install_qq()
{

cat >$WINETMP/iehack.reg << EOF
REGEDIT4

[HKEY_LOCAL_MACHINE\Software\Microsoft\Internet Explorer]
"Version"="6.0"
EOF

env WINEPREFIX=$WINEPREFIX LANG=$LANG WINEARCH=$WINEARCH TZ=$TZ $WINE_EXEC/wine regedit $WINETMP/iehack.reg >/dev/null 2>&1
env WINEPREFIX=$WINEPREFIX LANG=$LANG WINEARCH=$WINEARCH TZ=$TZ $WINE_EXEC/wine $WINETMP/QQ7.3Light.exe >/dev/null 2>&1
env WINEPREFIX=$WINEPREFIX LANG=$LANG WINEARCH=$WINEARCH TZ=$TZ $WINE_EXEC/wineserver -k
#询问是否成功安装了
echo
read -p "刚才点击了QQ安装程序的“安装完成”按钮吗？(y/n) " qq_setup_finished
if [ $qq_setup_finished = "y" ]
then true
elif [ -f $WINEPREFIX/drive_c/Program\ Files/Tencent/QQ/Bin/QQ.exe ]
  then echo "应该是安装时卡在“注册组件”，然后你自己关闭的吧。"
else
  echo "看起来没有安装成功，建议重新运行此脚本。"
  env WINEPREFIX=$WINEPREFIX LANG=$LANG WINEARCH=$WINEARCH TZ=$TZ $WINE_EXEC/wineserver -k
  exit 1 
fi
}

echo "善后善后～"
hack_reg()
{
#导入注册表
echo "继续黑注册表～"
cat >$WINETMP/txhack.reg <<EOF
REGEDIT4

[HKEY_CURRENT_USER\Software\Wine\DllOverrides]
"*riched20"="native,builtin"
"riched20.dll"="native,builtin"
"txplatform.exe"=""
"txupd.exe"=""
EOF
env WINEPREFIX=$WINEPREFIX LANG=$LANG WINEARCH=$WINEARCH TZ=$TZ $WINE_EXEC/wine regedit $WINETMP/txhack.reg >/dev/null 2>&1
}


get_icon()
{
echo "从QQ.exe中扣图标，这下不算侵权了吧。。。"
7z -y e $WINEPREFIX/drive_c/Program\ Files/Tencent/QQ/Bin/QQ.exe -o$WINETMP/qqicon >/dev/null
cp $WINETMP/qqicon/4  $HOME/.local/share/icons/wineqq_icon.png
}

create_launcher()
{
echo "创建启动脚本"
cat > $WINETMP/qq_launcher.sh <<EOF
#!/bin/sh
runqq()
 {
env  LC_ALL=zh_CN.UTF-8   TZ="Asia/Shanghai" WINEARCH=win32 WINEPREFIX=\$HOME/wineqq-bottle $WINE_EXEC/wine "C:\Program Files\Tencent\QQ\Bin\QQ.exe" >/dev/null 2>&1
}

wineqq_verbose()
{
env  LC_ALL=zh_CN.UTF-8   TZ="Asia/Shanghai" WINEARCH=win32 WINEPREFIX=\$HOME/wineqq-bottle $WINE_EXEC/wine "C:\Program Files\Tencent\QQ\Bin\QQ.exe"
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
 env  LC_ALL=zh_CN.UTF-8  TZ="Asia/Shanghai" WINEARCH=win32 WINEPREFIX=\$HOME/wineqq-bottle $WINE_EXEC/wine regedit
  ;;
  "-c"|"--winecfg")
  env LC_ALL=zh_CN.UTF-8  TZ="Asia/Shanghai" WINEARCH=win32 WINEPREFIX=\$HOME/wineqq-bottle $WINE_EXEC/wine winecfg
  ;;
  "-t"|"--taskmgr")
   env LC_ALL=zh_CN.UTF-8  TZ="Asia/Shanghai" WINEARCH=win32 WINEPREFIX=\$HOME/wineqq-bottle $WINE_EXEC/wine taskmgr
  ;;
  "-e"|"--explorer")
  env LC_ALL=zh_CN.UTF-8  TZ="Asia/Shanghai" WINEARCH=win32 WINEPREFIX=\$HOME/wineqq-bottle $WINE_EXEC/wine explorer
  ;;
    "-w"|"--winetricks")
  env LC_ALL=zh_CN.UTF-8 TZ="Asia/Shanghai" WINEARCH=win32 WINEPREFIX=\$HOME/wineqq-bottle $WINETRICKS_EXEC/winetricks
  ;;
  "-k"|"--kill")
  env LC_ALL=zh_CN.UTF-8  TZ="Asia/Shanghai" WINEARCH=win32 WINEPREFIX=\$HOME/wineqq-bottle $WINE_EXEC/wineserver -k
  ;;
  "-u"|"-uninstall")
  rm -rf \$HOME/wineqq-bottle
  rm \$HOME/.local/share/applications/wineqq.desktop
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
chmod +x $WINETMP/qq_launcher.sh
cp $WINETMP/qq_launcher.sh $WINEPREFIX/
}

create_item()
{
echo "创建菜单项"
cat >$WINETMP/QQ.desktop <<EOF
[Desktop Entry]
Name=QQ 7.3 Lite
Comment=Tencent QQ Lite
Categories=Network;
Exec=\$HOME/wineqq-bottle/qq_launcher.sh
 Ic
Type=Application
EOF
cp $WINETMP/QQ.desktop $HOME/.local/share/applications/wineqq.desktop
}

check_dep
check_wine
check_winetricks
check_folders
create_bottle
basedlls
get_wenq_font
get_qq
install_qq
hack_reg
get_icon
create_launcher
create_item
env WINEPREFIX=$WINEPREFIX LANG=$LANG WINEARCH=$WINEARCH TZ=$TZ $WINE_EXEC/wineserver -k
#rm -rf $WINETMP
echo "看起来都完成了～好啦，玩(或被玩)得愉快"
exit 0
