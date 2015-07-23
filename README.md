# Cordova MediaChooser Plugin

By Using open source <[learnNcode/MediaChooser](https://github.com/learnNcode/MediaChooser)> on Android

By Using open source <[uzysjung/UzysAssetsPickerController](https://github.com/uzysjung/UzysAssetsPickerController)> on iOS


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
    
