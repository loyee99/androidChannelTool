#!/bin/bash

#配置
srcApkPath=$1
channelFile="./channels.txt"
outDir="allchannels"

#创建outDir目录
mkdir -p $outDir
rm -f $outDir/*
chmod 777 -R $outDir
#创建目录META-INF，用来存放channel文件
mkdir -p META-INF
chmod 777 -R META-INF
#获取app名字，不包含.apk
prefix=${srcApkPath%.apk*}
prefix=${prefix##*/}

while read line
do
	echo $line
	rm -f META-INF/*
	channelName="channel_"$line
	touch META-INF/$channelName
	chmod 666 META-INF/$channelName
	newApkName=$prefix"_"$line".apk"
	echo $newApkName
        #copy一个新的apk出来
	cp $srcApkPath $outDir/$newApkName
	#插入渠道文件
	zip -r $outDir/$newApkName META-INF
done < $channelFile 


