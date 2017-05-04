package com.zhuomogroup.ylyk.adapter;

import android.content.Context;
import android.net.Uri;
import android.support.v4.view.PagerAdapter;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import com.bumptech.glide.Glide;
import com.zhuomogroup.ylyk.R;

import java.io.File;
import java.util.ArrayList;

import me.iwf.photopicker.utils.AndroidLifecycleUtils;

/**
 * Created by xyb on 2017/3/9.
 */

public class YLSelectPhotoAdapter extends PagerAdapter {

    private ArrayList<String> paths;

    private Context context;

    private int mChildCount = 0;


    public YLSelectPhotoAdapter(Context context) {
        this.context = context;
    }


    public ArrayList<String> getPaths() {
        return paths;
    }

    public void setPaths(ArrayList<String> paths) {
        this.paths = paths;
        notifyDataSetChanged();

    }

    @Override
    public int getCount() {
        return paths != null && paths.size() > 0 ? paths.size() : 1;
    }

    @Override
    public boolean isViewFromObject(View view, Object object) {
        return view == object;
    }

    @Override
    public Object instantiateItem(ViewGroup container, int position) {
        if (paths != null && paths.size() > 0) {
            ImageView inflate = (ImageView) View.inflate(context, R.layout.viewpager_img_show, null);

            final String path = paths.get(position);
            final Uri uri;
            if (path.startsWith("http")) {
                uri = Uri.parse(path);
            } else {
                uri = Uri.fromFile(new File(path));
            }

            boolean canLoadImage = AndroidLifecycleUtils.canLoadImage(context);
            if (canLoadImage) {
                Glide.with(context).load(uri)
                        .thumbnail(0.1f)
                        .dontAnimate()
                        .dontTransform()
                        .override(800, 800)
                        .placeholder(R.drawable.__picker_ic_photo_black_48dp)
                        .error(R.drawable.__picker_ic_broken_image_black_48dp)
                        .into(inflate);
            }
            container.addView(inflate);
            return inflate;
        } else {
            View inflate = View.inflate(context, R.layout.viewpager_img_empty, null);


            container.addView(inflate);
            return inflate;
        }


    }

    @Override
    public void destroyItem(ViewGroup container, int position, Object object) {
        container.removeView((View) object);
        Glide.clear((View) object);
    }


    @Override
    public void notifyDataSetChanged() {
        mChildCount = getCount();
        super.notifyDataSetChanged();
    }

    @Override
    public int getItemPosition(Object object) {

        if (mChildCount > 0) {
            mChildCount--;
            return POSITION_NONE;
        }
        return super.getItemPosition(object);
    }
}
