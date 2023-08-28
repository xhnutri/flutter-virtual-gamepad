package com.example.gamepad

import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    // private val CHANNEL = "flutter.native/helper"
    // // private lateinit var sensorManager: SensorManager

    // override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    //     GeneratedPluginRegistrant.registerWith(flutterEngine);
    //     MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            
    //         if (call.method == "getRotate") {
                
    //             // Rotation matrix based on current readings from accelerometer and magnetometer.
    //             val rotationMatrix = FloatArray(9)
    //             SensorManager.getRotationMatrix(rotationMatrix, null, accelerometerReading, magnetometerReading)
    //             // Express the updated rotation matrix as three orientation angles.
    //             val orientationAngles = FloatArray(3)
    //             SensorManager.getOrientation(rotationMatrix, orientationAngles)
    //             float orientationData[] = new float[3];

    //             // SensorManager.getOrientation(R, orientationData);
    //             val azimuth = orientationData[0];
    //             val pitch = orientationData[1];
    //             val roll = orientationData[2];
    //             result.success(roll);
    //         } else {
    //             result.notImplemented()
    //         }
    //     }
    // }
}
