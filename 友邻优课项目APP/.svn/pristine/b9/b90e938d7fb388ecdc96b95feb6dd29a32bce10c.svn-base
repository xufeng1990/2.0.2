package com.zhuomogroup.ylyk.adapter;

import android.content.Context;
import android.support.v4.view.PagerAdapter;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import com.bumptech.glide.Glide;
import com.zhuomogroup.ylyk.R;
import com.zhuomogroup.ylyk.activity.YLBigImageActivity;

import java.util.ArrayList;

/**
 * Created by xyb on 2017/3/19.
 */

public class YLBigImageAdapter extends PagerAdapter {
    private Context mContext;
    private ArrayList<String> imgs;
    private LayoutInflater layoutInflater;


    public YLBigImageAdapter(Context mContext, ArrayList<String> imgs) {
        this.mContext = mContext;
        this.imgs = imgs;
        layoutInflater = LayoutInflater.from(mContext);
    }

    @Override
    public int getCount() {
        return imgs.size();
    }

    @Override
    public boolean isViewFromObject(View view, Object object) {
        return view == object;
    }

    @Override
    public void destroyItem(ViewGroup container, int position, Object object) {
        container.removeView((View) object);
    }

    @Override
    public Object instantiateItem(ViewGroup container, int position) {
        ImageView inflate = (ImageView) layoutInflater.inflate(R.layout.viewpager_img_show, null);
        Glide.with(mContext).load(imgs.get(position))
                .thumbnail(0.1f)
                .dontAnimate()
                .dontTransform()
                .placeholder(R.drawable.__picker_ic_photo_black_48dp)
                .error(R.drawable.__picker_ic_broken_image_black_48dp)
                .into(inflate);
        inflate.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                YLBigImageActivity mContext = (YLBigImageActivity) YLBigImageAdapter.this.mContext;
                mContext.onBackPressed();
            }
        });
        container.addView(inflate);
        return inflate;
    }
}
