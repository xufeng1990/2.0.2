package com.zhuomogroup.ylyk.activity;

import android.content.Context;
import android.content.Intent;
import android.support.v4.view.ViewPager;
import android.view.View;
import android.widget.TextView;

import com.zhuomogroup.ylyk.R;
import com.zhuomogroup.ylyk.adapter.YLBigImageAdapter;
import com.zhuomogroup.ylyk.base.YLBaseActivity;

import java.util.ArrayList;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by xyb on 2017/3/19.
 */

public class YLBigImageActivity extends YLBaseActivity implements ViewPager.OnPageChangeListener {
    @BindView(R.id.center_text_img)
    TextView centerTextImg;
    @BindView(R.id.viewpager_bigimg)
    ViewPager viewPagerBigImg;

    private ArrayList<String> showImgList;
    private int position;

    @Override
    public int bindLayout() {
        return R.layout.viewpager_bigimg;
    }

    @Override
    public void initView(View view) {
        ButterKnife.bind(this);
    }

    @Override
    public void doBusiness(Context mContext) {
        Intent intent = getIntent();
        if (intent != null) {
            showImgList = intent.getStringArrayListExtra("imgs");
            position = intent.getIntExtra("position", 0);
        }
        centerTextImg.setText((position + 1) + "/" + showImgList.size());
        YLBigImageAdapter ylBigImgAdapter = new YLBigImageAdapter(this, this.showImgList);
        viewPagerBigImg.setAdapter(ylBigImgAdapter);
        viewPagerBigImg.addOnPageChangeListener(this);
        viewPagerBigImg.setCurrentItem(position);
    }

    @Override
    public void resume() {

    }

    @Override
    public void destroy() {

    }


    @Override
    public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {

    }

    @Override
    public void onPageSelected(int position) {
        centerTextImg.setText((position + 1) + "/" + showImgList.size());
    }

    @Override
    public void onPageScrollStateChanged(int state) {

    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
        // 添加返回过渡动画.
        overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
    }
}
