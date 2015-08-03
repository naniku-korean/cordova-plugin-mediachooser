/*
 * Copyright 2013 - learnNcode (learnncode@gmail.com)
 * 
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy of
 * the License at
 * 
 * http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations under
 * the License.
 */

package com.learnncode.mediachooser.sample;

import java.util.List;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.Window;
import android.widget.Button;
import android.widget.GridView;
import android.widget.Toast;

import com.learnncode.mediachooser.MediaChooser;
import com.learnncode.mediachooser.activity.BucketHomeFragmentActivity;
import com.learnncode.mediachooser.activity.HomeFragmentActivity;
import kr.co.kbs.mnrc.R;

public class MainActivity extends Activity {

	Button doneViewButton;
	Button fileViewButton;
	GridView gridView;
	MediaGridViewAdapter adapter;
	Bundle extras = null;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		requestWindowFeature(Window.FEATURE_NO_TITLE); 
		setContentView(R.layout.activity_main);
		doneViewButton = (Button)findViewById(R.id.doneButton);
		fileViewButton = (Button)findViewById(R.id.fileButton);
		gridView = (GridView)findViewById(R.id.gridView);
		doneViewButton.setOnClickListener(clickListener);
		fileViewButton.setOnClickListener(clickListener);

		extras = getIntent().getExtras();

		IntentFilter videoIntentFilter = new IntentFilter(MediaChooser.VIDEO_SELECTED_ACTION_FROM_MEDIA_CHOOSER);
		registerReceiver(videoBroadcastReceiver, videoIntentFilter);

		IntentFilter imageIntentFilter = new IntentFilter(MediaChooser.IMAGE_SELECTED_ACTION_FROM_MEDIA_CHOOSER);
		registerReceiver(imageBroadcastReceiver, imageIntentFilter);

		if( adapter == null ){
		    doneViewButton.setEnabled(false);
		}
	}


	OnClickListener clickListener = new OnClickListener() {

		@Override
		public void onClick(View view) {
			if(view == doneViewButton){

			    String[] allPath = new String[adapter.getCount()];
                for (int i = 0; i < allPath.length; i++) {
                    allPath[i] = adapter.getItem(i);
                }

                //initialize
                MediaChooser.setSelectedMediaCount(0);
				adapter.clear();

                Intent data = new Intent().putExtra("all_path", allPath);
                try{
                    setResult(RESULT_OK, data);
                } catch (Exception e){
                    e.printStackTrace();
                }
                finish();

			}else {
			    MediaChooser.setVideoSize(extras.getInt("videoSize", -1));
			    MediaChooser.setImageSize(extras.getInt("imageSize", -1));
			    MediaChooser.setSelectionLimit(extras.getInt("selectionLimit", -1));

				Intent intent = new Intent(MainActivity.this, HomeFragmentActivity.class);
				startActivity(intent);
			}
		}
	};

	BroadcastReceiver videoBroadcastReceiver = new BroadcastReceiver() {

		@Override
		public void onReceive(Context context, Intent intent) {
		    doneViewButton.setEnabled(true);
			setAdapter(intent.getStringArrayListExtra("list"));
		}
	};


	BroadcastReceiver imageBroadcastReceiver = new BroadcastReceiver() {

		@Override
		public void onReceive(Context context, Intent intent) {
		    doneViewButton.setEnabled(true);
			setAdapter(intent.getStringArrayListExtra("list"));
		}
	};

	@Override
	protected void onDestroy() {
		unregisterReceiver(imageBroadcastReceiver);
		unregisterReceiver(videoBroadcastReceiver);
		super.onDestroy();
	}

	private void setAdapter( List<String> filePathList) {
		if(adapter == null){
			adapter = new MediaGridViewAdapter(MainActivity.this, 0, filePathList);
			gridView.setAdapter(adapter);
		}else{
			adapter.addAll(filePathList);
			adapter.notifyDataSetChanged();
		}
	}
}
