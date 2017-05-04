package com.zhuomogroup.ylyk.controinterface;

import java.util.ArrayList;

/**
 * 发布心得控制器接口
 * Created by xyb on 2017/3/12.
 */

public interface PushTipsInterface {
    void pushInterFace(String tips, int courseId, ArrayList<String> imgPaths);
}
