# Cordova MediaChooser Plugin

By Using open source <[learnNcode/MediaChooser](https://github.com/learnNcode/MediaChooser)>


## Using
Install the plugin

    $ cordova plugin add https://github.com/naniku-korean/cordova-plugin-mediachooser
    
Edit `www/js/index.js` and add the following code inside `onDeviceReady`

```js
    /* 
        callbackFunction parameter structure
        @ type Object
        @ usecase 
          1. success
            { value: true, cancelled: true, paths: ["filePath1", "filePath2", ...] }
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
        @ type Object
        @ usecase 
          {
            imageSize:  10,   <-- MB
            videoSize: 10,    <-- MB
            selectionLimit: 10
          }
    */
    var chooserOpt = {
        imageSize:  10,
        videoSize: 10,
        selectionLimit: 10
    };
    mediachooser.getPictures(chooserOpt, success, failure);
```
Run the code

    cordova run android
    
Uninstall the plugin

    cordova plugin remove com.media_chooser
    
