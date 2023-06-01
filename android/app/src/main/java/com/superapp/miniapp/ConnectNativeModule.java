package com.superapp.miniapp;

import android.content.Intent;
import android.os.Bundle;

import androidx.annotation.Nullable;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

public class ConnectNativeModule extends ReactContextBaseJavaModule {
    private ReactApplicationContext reactContext;
    private static final Map<String, ReactContext> _reactContexts = new HashMap<>();
    private static Callback _closeCallback = null;



    public ConnectNativeModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
    }


    @ReactMethod
    public void openApp(String bundleName, String appPath, ReadableMap initProps,
                        boolean devLoad, Callback callback) {
        Intent intent = new Intent(reactContext, MiniAppActivity.class);
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        Bundle bundle = new Bundle();
        bundle.putString("bundleName", bundleName);
        bundle.putString("appPath", appPath);
        bundle.putBoolean("devLoad", devLoad);
        bundle.putBundle("initProps", Arguments.toBundle(initProps));
        intent.putExtras(bundle);
        reactContext.startActivity(intent);
        addBridge(bundleName);
        _closeCallback = callback;
    }

    @ReactMethod
    public void sendMessage(String bundleName, ReadableMap msg, Callback callback) {
        ReactContext reactContext = _reactContexts.get(bundleName);
        WritableMap result = Arguments.createMap();
        if (reactContext != null) {
            WritableMap map = Arguments.createMap();
            map.merge(msg);
            pushEvent(reactContext, "EventMessage", map);
            result.putString("msg", "Send message ok!");
        } else {
            result.putString("msg", "Cannot find this bundle name " + bundleName);
        }
        callback.invoke(result);
    }


    @ReactMethod
    public void addBridge(String bundleName) {
        _reactContexts.put(bundleName, reactContext);
    }



    @ReactMethod
    public void closeApp(String bundleName) {
        if(_closeCallback == null) {
            return;
        }
        MiniAppActivity.close();
        _closeCallback = null;
        _reactContexts.remove(bundleName);
    }

    @ReactMethod
    public void getBundleNames(Promise promise) {
        if (_reactContexts.keySet().toArray() != null) {
            String[] bundleNames = Objects.requireNonNull(_reactContexts.keySet().toArray(new String[0]));
            WritableArray arrays = Arguments.fromArray(bundleNames);
            promise.resolve(arrays);
        } else {
            promise.reject(new Throwable("No listeners"));
        }
    }

    private void pushEvent(ReactContext reactContext, String eventName, @Nullable WritableMap params) {
        reactContext
                .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                .emit(eventName, params);
    }

    @Override
    public String getName() {
        return "ConnectNativeModule";
    }
}