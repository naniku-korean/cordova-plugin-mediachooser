# Cordova MediaChooser Plugin

By Using open source <[learnNcode/MediaChooser](https://github.com/learnNcode/MediaChooser)> on Android

By Using open source <[uzysjung/UzysAssetsPickerController](https://github.com/uzysjung/UzysAssetsPickerController)> on iOS

## CheckPoint
안드로이드에서 플러그인 추가 후 빌드 할 경우 R.java 의 경로 오류가 발생한다.

경로 수정이 필요하다. cordova package name으로 변경이 필요하다.
'import com.naniku.mediachooser.R; -> 현재 프로젝트 package name'

오류 나는 파일
    'GalleryCache.java'
    'MediaChooserConstants.java'
    'BucketHomeFragmentActivity.java'
    'HomeFragmentActivity.java'
    'BucketGridAdapter.java'
    'GridViewAdapter.java'
    'ImageLoadAsync.java'
    'BucketImageFragment.java'
    'BucketVideoFragment.java'
    'ImageFragment.java'
    'VideoFragment.java'
    'MainActivity.java'
    'MediaGridViewAdapter.java'

## Using - Android, iOS
Install the plugin

    $ cordova plugin add https://github.com/naniku-korean/cordova-plugin-mediachooser
    
Edit `www/js/index.js` and add the following code inside `onDeviceReady`

```js
    /* 
        callbackFunction parameter structure
        @ type Object<android> or String<iOS>
        @ usecase
          1. success
            { value: true, cancelled: false, paths: ["filePath1", "filePath2", ...] }
          2. success (user cancel)
            { value: true, cancelled: true }
          3. error
            { value: false }
    */
    var success = function(data) {
        alert("success = " + data.value);
    }

    var failure = function(data) {
        alert("error = " + data.value);
    }
    /*
        getPictures options
        @ os Android
        @ type Object
        @ usecase 
          {
            imageSize:  10,   <-- MB
            videoSize: 10,    <-- MB
            selectionLimit: 10
          }

        getPictures options
        @ os iOS
        @ type integer
        @ usecase
          var selectionLimit: 10
    */
    // Android
    var chooserOpt = {
        imageSize:  10,
        videoSize: 10,
        selectionLimit: 10
    };
    mediachooser.getPictures(chooserOpt, success, failure);

    //iOS
    var selectionLimit = 10;
    mediachooser.getPictures(selectionLimit, success, failure);
```
Run the code

    // android
    cordova run android

    // iOS
    cordova run ios
    
Uninstall the plugin

    cordova plugin remove com.media_chooser
    
