package com.zhuomogroup.ylyk;

import android.support.v4.view.ViewPager.PageTransformer;
import android.view.View;

/**
 * Created by xyb on 2017/3/6.
 */

public class ScaleTransformer implements PageTransformer {
    private static final float MIN_SCALE = 0.90f;
    private static final float MIN_ALPHA = 0.5f;

    @Override
    public void transformPage(View page, float position) {
        if (position < -1 || position > 1) {
            page.setScaleX(MIN_SCALE);
            page.setScaleY(MIN_SCALE);
        } else if (position <= 1) { // [-1,1]
            if (position < 0) {
                float scaleX = 1 + 0.1f * position;
                page.setScaleX(scaleX);
                page.setScaleY(scaleX);
            } else {
                float scaleX = 1 - 0.1f * position;
                page.setScaleX(scaleX);
                page.setScaleY(scaleX);
            }
        }
    }
}
