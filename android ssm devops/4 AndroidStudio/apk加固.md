dx

```sh

cmd.exe /C dx --dex --output=F:\AndroidProject\cProtectApp\source\aar\temp\classes.dex F:\AndroidProject\cProtectApp\source\aar\temp\classes.jar
Error: keywords 'java version' not found in 'openjdk version "11.0.14.1" 2022'



```



d8

```sh
原版dx的
cmd.exe /C dx --dex --output=G:\AndroidProject\mProtectApp\JavaProtect\source\aar\temp\classes.dex G:\AndroidProject\mProtectApp\JavaProtect\source\aar\temp\classes.jar

d8的
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



