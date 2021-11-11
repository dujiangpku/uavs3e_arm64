package com.example.uavs3e_android;

import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;

import android.Manifest;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;
import android.util.Log;
import android.widget.TextView;

public class MainActivity extends AppCompatActivity {

    private static String[] PERMISSIONS_STORAGE = {
            Manifest.permission.READ_EXTERNAL_STORAGE,
            Manifest.permission.WRITE_EXTERNAL_STORAGE
    };
    private static int REQUEST_PERMISSION_CODE = 1;

    static {
        System.loadLibrary("uavs3e-lib");
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        String sdcard_path = Environment.getExternalStorageDirectory().getPath();

        if (Build.VERSION.SDK_INT > Build.VERSION_CODES.LOLLIPOP) {
            if (ActivityCompat.checkSelfPermission(this, Manifest.permission.WRITE_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
                ActivityCompat.requestPermissions(this, PERMISSIONS_STORAGE, REQUEST_PERMISSION_CODE);
            }
        }
        int stream_num = 145;
        //String[] streams = new String[18];
        String stream_path = "/avs3/"; //"/avs3/hpm3.3/";
        String[] streams = {
                //"Cactus_1920x1080_50.yuv",
                "akiyocif.yuv",
                "BasketballDrive_1920x1080_50_34.yuv"
        };
        for (int i = 0; i < stream_num; i++) {
            Log.i("uavs3e", streams[i]);
            uavs3e(sdcard_path + stream_path + streams[i], sdcard_path + stream_path + "output.yuv",sdcard_path + stream_path + "rec.yuv", 1920,1080,8,25,1);
        }
    }

    public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (requestCode == REQUEST_PERMISSION_CODE) {
            for (int i = 0; i < permissions.length; i++) {
                Log.i("MainActivity", "申请的权限为：" + permissions[i] + ",申请结果：" + grantResults[i]);
            }
        }
    }
    /**
     * A native method that is implemented by the 'native-lib' native library,
     * which is packaged with this application.
     */

    public native String uavs3e(String inputfile, String outputfile, String recfile, int width, int height, int bitdepth, int fps_num, int fps_den);
}