package com.zhuomogroup.ylyk.bean;

import android.os.Parcel;
import android.os.Parcelable;

/**
 * Created by xyb on 2017/1/21.
 */

public class DataListBean implements Parcelable {
    private int courseId;
    private String name;
    private String teacherName;
    private long in_time;
    private int duration;

    public DataListBean() {
    }

    protected DataListBean(Parcel in) {
        courseId = in.readInt();
        name = in.readString();
        teacherName = in.readString();
        in_time = in.readLong();
        duration = in.readInt();
    }

    public static final Creator<DataListBean> CREATOR = new Creator<DataListBean>() {
        @Override
        public DataListBean createFromParcel(Parcel in) {
            return new DataListBean(in);
        }

        @Override
        public DataListBean[] newArray(int size) {
            return new DataListBean[size];
        }
    };

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeInt(courseId);
        dest.writeString(name);
        dest.writeString(teacherName);
        dest.writeLong(in_time);
        dest.writeInt(duration);
    }


    public int getCourseId() {
        return courseId;
    }

    public void setCourseId(int courseId) {
        this.courseId = courseId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getTeacherName() {
        return teacherName;
    }

    public void setTeacherName(String teacherName) {
        this.teacherName = teacherName;
    }

    public long getIn_time() {
        return in_time;
    }

    public void setIn_time(long in_time) {
        this.in_time = in_time;
    }

    public int getDuration() {
        return duration;
    }

    public void setDuration(int duration) {
        this.duration = duration;
    }
}
