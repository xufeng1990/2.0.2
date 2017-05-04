package com.zhuomogroup.ylyk.base;

import android.annotation.TargetApi;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DefaultHardwareBackBtnHandler;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.facebook.react.modules.core.PermissionAwareActivity;
import com.facebook.react.modules.core.PermissionListener;
import com.zhuomogroup.ylyk.delegate.YLReactDelegate;

import javax.annotation.Nullable;

/**
 * Created by xyb on 2017/2/17.
 */

public class YLYKBaseReactFragment extends Fragment implements PermissionAwareActivity, DefaultHardwareBackBtnHandler {


    protected static final String ARG_COMPONENT_NAME = "arg_component_name";
    protected static final String ARG_LAUNCH_OPTIONS = "arg_launch_options";

    private YLReactDelegate mReactDelegate;

    @Nullable
    private PermissionListener mPermissionListener;



    public YLYKBaseReactFragment() {
        // Required empty public constructor
    }

    /**
     * @param componentName The name of the react native component
     * @return A new instance of fragment ReactFragment.
     */
    private static YLYKBaseReactFragment newInstance(String componentName, Bundle launchOptions) {
        YLYKBaseReactFragment fragment = new YLYKBaseReactFragment();
        Bundle args = new Bundle();
        args.putString(ARG_COMPONENT_NAME, componentName);
        args.putBundle(ARG_LAUNCH_OPTIONS, launchOptions);
        fragment.setArguments(args);
        return fragment;
    }

    // region Lifecycle
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        String mainComponentName = null;
        Bundle launchOptions = null;
        if (getArguments() != null) {
            mainComponentName = getArguments().getString(ARG_COMPONENT_NAME);
            launchOptions = getArguments().getBundle(ARG_LAUNCH_OPTIONS);
        }
        if (mainComponentName == null) {
            throw new IllegalStateException("Cannot loadApp if component name is null");
        }
        mReactDelegate = new YLReactDelegate(getActivity(), mainComponentName, launchOptions);

    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        boolean needToEnableRedboxPermission = mReactDelegate.askForRedboxPermission();

        if (!needToEnableRedboxPermission) {
            mReactDelegate.loadApp();
        }
        return mReactDelegate.getReactRootView();
    }





    /**
     * @param reactContext
     * @param eventName    事件名
     * @param params       传惨
     */
    public void sendTransMisson(ReactContext reactContext, String eventName, @Nullable WritableMap params) {
        reactContext
                .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)

                .emit(eventName, params);

    }

    @Override
    public void onResume() {
        super.onResume();
        if (getActivity() != null) {
            mReactDelegate.onHostResume();
        }
    }

    @Override
    public void onPause() {
        super.onPause();
        if (getActivity() != null) {
            mReactDelegate.onHostPause();
        }
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        mReactDelegate.onHostDestroy();
    }
    // endregion

    /**
     * This currently only checks to see if we've enabled the permission to draw over other apps.
     * This is only used in debug/developer mode and is otherwise not used.
     *
     * @param requestCode Code that requested the activity
     * @param resultCode  Code which describes the result
     * @param data        Any data passed from the activity
     */
    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        mReactDelegate.onActivityResult(requestCode, resultCode, data, false);
    }

    /**
     * Helper to forward hardware back presses to our React Native Host
     * <p>
     * This must be called via a forward from your host Activity
     */
    public boolean onBackPressed() {
        return mReactDelegate.onBackPressed();
    }

    /**
     * Helper to forward onKeyUp commands from our host Activity.
     * This allows ReactFragment to handle double tap reloads and dev menus
     * <p>
     * This must be called via a forward from your host Activity
     *
     * @param keyCode keyCode
     * @param event   event
     * @return true if we handled onKeyUp
     */
    public boolean onKeyUp(int keyCode, KeyEvent event) {

        return mReactDelegate.shouldShowDevMenuOrReload(keyCode, event);
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (mPermissionListener != null &&
                mPermissionListener.onRequestPermissionsResult(requestCode, permissions, grantResults)) {
            mPermissionListener = null;
        }
    }

    @Override
    public int checkPermission(String permission, int pid, int uid) {
        return getActivity().checkPermission(permission, pid, uid);
    }

    @TargetApi(Build.VERSION_CODES.M)
    @Override
    public int checkSelfPermission(String permission) {
        return getActivity().checkSelfPermission(permission);
    }

    @TargetApi(Build.VERSION_CODES.M)
    @Override
    public void requestPermissions(String[] permissions, int requestCode, PermissionListener listener) {
        mPermissionListener = listener;
        requestPermissions(permissions, requestCode);
    }


    @Override
    public void invokeDefaultOnBackPressed() {
        getActivity().onBackPressed();
    }

    /**
     * Builder class to help instantiate a ReactFragment
     */
    public static class Builder {

        String mComponentName;
        Bundle mLaunchOptions;

        public Builder() {
            mComponentName = null;
            mLaunchOptions = null;
        }

        /**
         * Set the Component name for our React Native instance.
         *
         * @param componentName The name of the component
         * @return Builder
         */
        public Builder setComponentName(String componentName) {
            mComponentName = componentName;
            return this;
        }

        /**
         * Set the Launch Options for our React Native instance.
         *
         * @param launchOptions launchOptions
         * @return Builder
         */
        public Builder setLaunchOptions(Bundle launchOptions) {
            mLaunchOptions = launchOptions;
            return this;
        }

        public YLYKBaseReactFragment build() {
            return YLYKBaseReactFragment.newInstance(mComponentName, mLaunchOptions);
        }

    }
}
