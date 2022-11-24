

```sh
2 SecondActivity 里的button2 不用findviewbyid
app的build.grale 里 dependencies 下加 apply plugin: 'kotlin-android-extensions'

1 menuInflater 爆红用不了，要用到 kotlin语法糖
build.gradle 更新 androidx.appcompat:appcompat
```

