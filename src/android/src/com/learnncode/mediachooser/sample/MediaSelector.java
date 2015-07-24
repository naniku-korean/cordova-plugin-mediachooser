package com.learnncode.mediachooser.sample;

import java.util.ArrayList;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.LOG;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.content.Intent;

public class MediaSelector extends CordovaPlugin {
    
    public static String TAG = "MediaSelector";

    private CallbackContext callbackContext;
    private JSONObject params;

    public boolean execute(String action, final JSONArray args, final CallbackContext callbackContext) throws JSONException {
        this.callbackContext = callbackContext;
        this.params = args.getJSONObject(0);
        if (action.equals("getPictures")) {
            Intent intent = new Intent(cordova.getActivity(), MainActivity.class);

            int videoSize = this.params.getInt("videoSize");
            int imageSize = this.params.getInt("imageSize");
            int selectionLimit = this.params.getInt("selectionLimit");
            int requestCode=200;


            intent.putExtra("videoSize", videoSize);
            intent.putExtra("imageSize", imageSize);
            intent.putExtra("selectionLimit", selectionLimit);

            if (this.cordova != null) {
                this.cordova.startActivityForResult((CordovaPlugin) this, intent, requestCode);
            }
        }
        return true;
    }

    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        try {
            if (resultCode == Activity.RESULT_CANCELED) {
                JSONObject res = new JSONObject();
                res.put("value", true);
                res.put("cancelled", true);
                this.callbackContext.success(res);
            }else if (resultCode == Activity.RESULT_OK) {
                String[] fileNames = data.getStringArrayExtra("all_path");
                JSONArray p = new JSONArray();
                for(int i = 0;i < fileNames.length; i++) {
                    p.put(fileNames[i]);
                }
                JSONObject res = new JSONObject();
                res.put("value", true);
                res.put("cancelled", false);
                res.put("paths", p);
                this.callbackContext.success(res);
            } else {
                JSONObject res = new JSONObject();
                res.put("value", false);
                this.callbackContext.error("Error!");
            }
        } catch (JSONException e) {
        }
    }
}
