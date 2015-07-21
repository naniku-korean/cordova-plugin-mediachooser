/*global cordova, module*/

module.exports = {
    getPictures: function (arg, successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "MediaSelector", "getPictures", [arg]);
    }
};
