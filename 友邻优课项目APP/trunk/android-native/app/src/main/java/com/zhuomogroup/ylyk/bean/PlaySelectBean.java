package com.zhuomogroup.ylyk.bean;

/**
 * Created by xyb on 2017/3/11.
 */

public class PlaySelectBean {
    private String type;
    private int courseId;
    private boolean isPlay;

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public int getCourseId() {
        return courseId;
    }

    public void setCourseId(int courseId) {
        this.courseId = courseId;
    }

    public boolean isPlay() {
        return isPlay;
    }

    public void setPlay(boolean play) {
        isPlay = play;
    }
}
