



mLsn11

```sh
1 app, build.gradle, dependencies, 加上 implementation project(':AndroidDecrypt')
 Menifest 改 Application name， 加meta-data
2 gradle, app, build, build  ， 把chaosKey.jks 复制到JavaEncrypt
3 gradle, AndroidDecrypt, build, build
4 JavaEncrypt, Main, Run Main.main() 
会报错，Terminal 执行 zipalignCmd
cmd /c zipalign -v -p 4 F:\AndroidProject\Yi\app\build\outputs\apk\debug\app-unsigned.apk F:\AndroidProject\Yi\app\build\outputs\apk\debug\app-unsigned-aligned.apk
再次执行 Run Main.main()
```







Jett的 apksigner

```sh
cmd /c apksigner sign --ks F:\AndroidProject\mLsn11\JavaEncrypt\chaosKey.jks --ks-key-alias chao --ks-pass pass:123qwe --key-pass pass:123qwe --out F:\AndroidProject\mLsn11\app\build\outputs\apk\debug\app-signed-aligned.apk F:\AndroidProject\mLsn11\app\build\outputs\apk\debug\app-unsigned-aligned.apk
```





zipAlign

```sh
cmd /c zipalign -v -p -f 4 F:\AndroidProject\mLsn11\app\build\outputs\apk\debug\app-unsigned.apk F:\AndroidProject\mLsn11\app\build\outputs\apk\debug\app-unsigned-aligned.apk

cmd /c zipalign -v -p 4 F:\AndroidProject\mLsn11\app\build\outputs\apk\debug\app-unsigned.apk F:\AndroidProject\mLsn11\app\build\outputs\apk\debug\app-unsigned-aligned.apk
```









dx

```sh

cmd.exe /C dx --dex --output=F:\AndroidProject\cProtectApp\source\aar\temp\classes.dex F:\AndroidProject\cProtectApp\source\aar\temp\classes.jar
Error: keywords 'java version' not found in 'openjdk version "11.0.14.1" 2022'



```



d8

```sh
原版dx的
cmd.exe /C dx --dex --output=G:\AndroidProject\mProtectApp\JavaProtect\source\aar\temp\classes.dex G:\AndroidProject\mProtectApp\JavaProtect\source\aar\temp\classes.jar

我在 Terminal测试的d8的是
cmd.exe /C d8 --output G:\AndroidProject\mProtectApp\JavaProtect\source\aar\temp G:\AndroidProject\mProtectApp\JavaProtect\source\aar\temp\classes.jar
```



[how-to-create-a-dex-with-d8-bat](https://stackoverflow.com/questions/73859718/how-to-create-a-dex-with-d8-bat)

```sh
I used to create dex file with dx.bat like this :
dx --dex --output=C:\Dev\MagicFoundation\Alcinoe\Tools\AddRJavaToClassesDex\tmp\classes.dex C:\Dev\MagicFoundation\Alcinoe\Tools\AddRJavaToClassesDex\tmp\obj.zip

d8 --output <output-folder> <input-files>
In your case, the following is an equivalent:
d8 --output C:\Dev\MagicFoundation\Alcinoe\Tools\AddRJavaToClassesDex\tmp C:\Dev\MagicFoundation\Alcinoe\Tools\AddRJavaToClassesDex\tmp\obj.zip
```



[how-to-sign-an-already-compiled-apk](https://stackoverflow.com/questions/10930331/how-to-sign-an-already-compiled-apk)

```sh
create a key using
keytool -genkey -v -keystore my-release-key.keystore -alias alias_name -keyalg RSA -keysize 2048 -validity 10000

then sign the apk using :
jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore my-release-key.keystore my_application.apk alias_name
```



Jett老师

```sh
cmd /c apksigner sign --ks proxy_tools/proxy2.jks --ks-key-alias jett --ks-pass pass:123456 --key-pass pass:123456 --out app/build/outputs/apk/debug/app-signed-aligned.apk app/build/outputs/apk/debug/app-unsigned-aligned.apk

我的写进代码的应该是
String cmd = "cmd /c apksigner sign --ks " + jks.getAbsolutePath() + " --ks-key-alias chao --ks-pass pass:123qwe --key-pass pass:123qwe --min-sdk-version 33 --out " + signedApk.getAbsolutePath() + " " + unsignedApk.getAbsolutePath();

在 Terminal就是
cmd /c apksigner sign --ks F:\AndroidProject\mProtectApp\JavaProtect\chaosKey.jks --ks-key-alias chao --ks-pass pass:123qwe --key-pass pass:123qwe --min-sdk-version 33 --out F:\AndroidProject\mProtectApp\JavaProtect\result\apk-signed.apk F:\AndroidProject\mProtectApp\JavaProtect\result\apk-unsigned.apk
```









d8 不是内部命令

```sh
环境变量Path里加上 %ANDROID_HOME%\build-tools\33.0.1
```



[-Djava.ext.dirs=D:\androidSDK\build-tools\33.0.1\lib is not supported.  Use -classpath instead.](https://stackoverflow.com/questions/59896708/error-while-running-dx-or-d8-tool-for-android)

```sh
把 D:\androidSDK\build-tools\33.0.1\d8.bat 里最后的
call "%java_exe%" %javaOpts% -Djava.ext.dirs="%frameworkdir%" -cp "%jarpath%" com.android.tools.r8.D8 %params%
改成
call "%java_exe%" %javaOpts% -classpath "%frameworkdir%" -cp "%jarpath%" com.android.tools.r8.D8 %params%
```



