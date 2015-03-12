#!/bin/bash

#global variable
svn_trunk_prefix='svn://10.1.1.106/baturu/trunk/server'
svn_branch_prefix='svn://10.1.1.106/baturu/branch/server'

#program start
echo -e '\n请输入项目名：'
read projectname
echo -e '\n你输入的分支名为：'$projectname

echo -e '\n请输入要创建的分支名：'
read branchname
echo -e '\n你输入的分支名为：'$branchname' ， 正在创建分支，请稍后...'
svn mkdir $svn_branch_prefix/$projectname/$branchname
#通过 $? 获取上一次命令执行的结果，0表示成功，非0表示失败。
if [ $? -eq 0 ]; then #1
	echo -e '\n准备创建分支：'$branchname'，请输入备注：'
	read memo
	svn cp -m "$memo" $svn_trunk_prefix/$projectname $svn_branch_prefix/$projectname/$branchname/$projectname
	if [ $? -eq 0 ]; then #2
		echo -e '\n创建分支成功，是否需要checkout【yes(y)/no(n)】?'
		read co
		case $co in
			yes|y)
				echo -e '\n请输入checkout路径：'
				read dir
				if [ ! -d "$dir" ]; then #判断文件夹是否存在
					mkdir "$dir"
				fi
				#切换到目录，并checkout文件
				cd $dir && svn co $svn_branch_prefix/$projectname/$branchname/$projectname
				if [ $? -eq 0 ]; then #3
					echo -e '\ncheckout完毕！'
					echo -e '\n任务执行完毕！'
				else #3
					echo -e '\ncheckout分支失败。'
				fi #3
			 ;;
	 		no|n)
				echo -e '\n放弃checkout。'
			 ;;
			*)
 			 ;;
    esac
	else #2
		echo -e '\n创建分支失败，原因为：创建分支时出错。'
	fi #2
else #1
	echo -e '\n创建分支失败，原因为：创建分支文件夹时出错。'
fi #1
#program end