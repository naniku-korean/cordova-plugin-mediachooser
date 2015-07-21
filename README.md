# Cordova MediaChooser Plugin

By Using open source(https://github.com/learnNcode/MediaChooser) cordova plugin.

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
            imageSize:  10,
            videoSize: 10,
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
    

## More Info

For more information on setting up Cordova see [the documentation](http://cordova.apache.org/docs/en/4.0.0/guide_cli_index.md.html#The%20Command-Line%20Interface)

For more info on plugins see the [Plugin Development Guide](http://cordova.apache.org/docs/en/4.0.0/guide_hybrid_plugins_index.md.html#Plugin%20Development%20Guide)
