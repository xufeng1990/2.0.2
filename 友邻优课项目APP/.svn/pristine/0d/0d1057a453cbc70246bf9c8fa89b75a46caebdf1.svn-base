package com.zhuomogroup.ylyk.bean;

import android.os.Parcel;
import android.os.Parcelable;

import java.util.ArrayList;

/**
 * Created by xyb on 2017/1/19.
 */

public class AudioDataBean implements Parcelable {
    private int courseId;
    private String command;
    private String authorization;
    private int userId;
    private boolean isVip;
    private ArrayList<DataListBean> dataLists;
    private boolean isDownload;


    public AudioDataBean() {
    }

    public int getCourseId() {
        return courseId;
    }

    public void setCourseId(int courseId) {
        this.courseId = courseId;
    }

    public String getCommand() {
        return command;
    }

    public void setCommand(String command) {
        this.command = command;
    }

    public String getAuthorization() {
        return authorization;
    }

    public void setAuthorization(String authorization) {
        this.authorization = authorization;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public boolean isVip() {
        return isVip;
    }

    public void setVip(boolean vip) {
        isVip = vip;
    }

    public ArrayList<DataListBean> getDataLists() {
        return dataLists;
    }

    public void setDataLists(ArrayList<DataListBean> dataLists) {
        this.dataLists = dataLists;
    }

    public boolean isDownload() {
        return isDownload;
    }

    public void setDownload(boolean download) {
        isDownload = download;
    }

    protected AudioDataBean(Parcel in) {
        courseId = in.readInt();
        command = in.readString();
        authorization = in.readString();
        userId = in.readInt();
        isVip = in.readByte() != 0;
        dataLists = in.createTypedArrayList(DataListBean.CREATOR);
        isDownload = in.readByte() != 0;
    }

    public static final Creator<AudioDataBean> CREATOR = new Creator<AudioDataBean>() {
        @Override
        public AudioDataBean createFromParcel(Parcel in) {
            return new AudioDataBean(in);
        }

        @Override
        public AudioDataBean[] newArray(int size) {
            return new AudioDataBean[size];
        }
    };

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeInt(courseId);
        dest.writeString(command);
        dest.writeString(authorization);
        dest.writeInt(userId);
        dest.writeByte((byte) (isVip ? 1 : 0));
        dest.writeTypedList(dataLists);
        dest.writeByte((byte) (isDownload ? 1 : 0));
    }
}
