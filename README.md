##老版本打包方案，shell实现,linux和mac上测过.


    文件channels.txt　　　为所有渠道名称，添加和删除渠道只要修改该文件内容
    文件tools.sh  就是一个脚本文件，用来解压缩apk和放入渠道
    
    
    allchannels目录，运行后生成，所有生成的渠道包都在里面
    META-INF　　临时目录，没什么用，每次运行会自动更新，不用管
    
    赋予tools.sh可执行权限
    
    使用方法
    ./tools.sh 　xxxx.apk
    
    ＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
    查看是否渠道打成功，只要解压缩apk(其实就是zip文件)
    ，看看META-INF目录下　有个文件channel_xxx,比如channel_360,channel_xiaomi,文件内容不用管
    
    
    打包注意：
    ./tools.sh 　xxxx.apk　　
    
    其中xxxx.apk里面META-INF下面不能有　channel_xxx文件，如果有双击打开压缩文件删除就好。
    不然的话，META-INF 目录会有２个channel_xxx文件，就错了



代码配置:
1.
        
    signingConfigs {
        releaseConfig {
         .....
            v2SigningEnabled false
        }
    }




2.从代码中读取渠道：

        
        
       /**
     * 从apk中获取渠道信息
     * @param context
     * @param channelKey
     * @return
     */
    public static String getChannelFromApk(Context context, String channelKey) {
        //从apk包中获取
        ApplicationInfo appinfo = context.getApplicationInfo();
        String sourceDir = appinfo.sourceDir;
        //注意这里：默认放在meta-inf/里， 所以需要再拼接一下
        String key = "META-INF/" + channelKey;
        String ret = "";
        ZipFile zipfile = null;
        try {
            zipfile = new ZipFile(sourceDir);
            Enumeration<?> entries = zipfile.entries();
            while (entries.hasMoreElements()) {
                ZipEntry entry = ((ZipEntry) entries.nextElement());
                String entryName = entry.getName();
                if (entryName.startsWith(key)) {
                    ret = entryName;
                    break;
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        } finally {
            if (zipfile != null) {
                try {
                    zipfile.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
        String[] split = ret.split("_");
        String channel = "";
        if (split != null && split.length >= 2) {
            channel = ret.substring(split[0].length() + 1);
        }
        return channel;
    } 
        
   

