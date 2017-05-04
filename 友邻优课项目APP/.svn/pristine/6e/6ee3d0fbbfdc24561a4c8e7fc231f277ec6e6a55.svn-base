package com.zhuomogroup.ylyk.adapter;

import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;

import com.zhuomogroup.ylyk.base.YLYKBaseReactFragment;

import java.util.ArrayList;

/**
 * Created by xyb on 2017/2/17.
 */

public class YLMainPagerAdapter extends FragmentPagerAdapter {
    private static final int MAIN_COUNT = 4;

    private ArrayList<YLYKBaseReactFragment> ylykBaseReactFragments;

    public YLMainPagerAdapter(FragmentManager fm, ArrayList<YLYKBaseReactFragment> ylykBaseReactFragments) {
        super(fm);
        this.ylykBaseReactFragments = ylykBaseReactFragments;
    }

    @Override
    public Fragment getItem(int position) {

        return ylykBaseReactFragments.get(position);
    }

    @Override
    public int getCount() {
        return MAIN_COUNT;
    }
}
