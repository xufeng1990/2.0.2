package com.reactutils.download;

import java.io.Serializable;

/**
 * 下载信息模型
 * Created by xyb on 2017/3/3 at 友邻优课 2017
 */

public class CourseBean implements Serializable {
    private AlbumBean album;
    private String duration;
    private int id;
    private String name;
    private String teachers;
    private String url;

    public AlbumBean getAlbum() {
        return this.album;
    }

    public String getDuration() {
        return this.duration;
    }

    public int getId() {
        return this.id;
    }

    public String getName() {
        return this.name;
    }

    public String getTeachers() {
        return this.teachers;
    }

    public String getUrl() {
        return this.url;
    }

    public void setAlbum(AlbumBean paramAlbumBean) {
        this.album = paramAlbumBean;
    }

    public void setDuration(String paramString) {
        this.duration = paramString;
    }

    public void setId(int paramInt) {
        this.id = paramInt;
    }

    public void setName(String paramString) {
        this.name = paramString;
    }

    public void setTeachers(String paramString) {
        this.teachers = paramString;
    }

    public void setUrl(String paramString) {
        this.url = paramString;
    }
}
