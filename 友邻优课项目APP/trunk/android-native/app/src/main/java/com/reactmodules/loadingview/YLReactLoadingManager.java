package com.reactmodules.loadingview;

import android.view.View;

import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.annotations.ReactProp;

import javax.annotation.Nullable;

/**
 * loading 图 rn 管理工具
 * Created by xyb on 2017/3/20.
 */

public class YLReactLoadingManager extends SimpleViewManager<LoadingFrameLayout> {
    private static final String REACT_CLASS = "RCTYLLoading";

    @Override
    public String getName() {
        return REACT_CLASS;
    }

    @Override
    protected LoadingFrameLayout createViewInstance(ThemedReactContext reactContext) {
        return new LoadingFrameLayout(reactContext);
    }

    @ReactProp(name = "isShow",defaultBoolean = true)
    public void setIsShow(LoadingFrameLayout view, @Nullable Boolean isShow) {
        if (isShow) {
            view.setVisibility(View.VISIBLE);
        } else {
            view.setVisibility(View.GONE);
        }
    }


}
