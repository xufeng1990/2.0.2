package com.zhuomogroup.ylyk.activity;

import android.content.Context;
import android.content.Intent;
import android.view.View;
import android.widget.TextView;

import com.zhuomogroup.ylyk.R;
import com.zhuomogroup.ylyk.base.YLBaseActivity;
import com.zhuomogroup.ylyk.utils.SharedPreferencesUtil;

import butterknife.BindView;
import butterknife.ButterKnife;
import cn.bingoogolapple.bgabanner.BGABanner;

import static com.zhuomogroup.ylyk.consts.YLStorageKey.IS_FIRST_OPEN_APP;

/**
 * Created by xyb on 2017/3/22.
 */

public class YLUserHelperActivity extends YLBaseActivity {
    @BindView(R.id.banner_guide_foreground)
    BGABanner bannerGuideForeground;
    @BindView(R.id.tv_guide_skip)
    TextView tvGuideSkip;
    @BindView(R.id.btn_guide_enter)
    TextView btnGuideEnter;

    @Override
    public int bindLayout() {
        return R.layout.activity_helper;
    }

    @Override
    public void initView(View view) {

    }

    @Override
    public void doBusiness(Context mContext) {
        ButterKnife.bind(this);
        setListener();
        processLogic();
    }

    @Override
    public void resume() {

    }

    @Override
    public void destroy() {
    }

    public void myButton(View view) {
        SharedPreferencesUtil.put(this, IS_FIRST_OPEN_APP, false);
    }

    private void setListener() {
        /**
         * 设置进入按钮和跳过按钮控件资源 id 及其点击事件
         * 如果进入按钮和跳过按钮有一个不存在的话就传 0
         * 在 BGABanner 里已经帮开发者处理了防止重复点击事件
         * 在 BGABanner 里已经帮开发者处理了「跳过按钮」和「进入按钮」的显示与隐藏
         */
        bannerGuideForeground.setEnterSkipViewIdAndDelegate(R.id.btn_guide_enter, R.id.tv_guide_skip, new BGABanner.GuideDelegate() {
            @Override
            public void onClickEnterOrSkip() {
                SharedPreferencesUtil.put(YLUserHelperActivity.this, IS_FIRST_OPEN_APP, false);
                startActivity(new Intent(YLUserHelperActivity.this, YLLoginActivity.class));
                finish();
            }
        });
    }

    private void processLogic() {

        bannerGuideForeground.setData(R.drawable.baner_01, R.drawable.baner_02, R.drawable.baner_03,R.drawable.baner_04);
    }
}
