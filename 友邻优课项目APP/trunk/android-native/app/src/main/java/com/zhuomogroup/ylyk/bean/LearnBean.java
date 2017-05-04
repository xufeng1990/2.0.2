package com.zhuomogroup.ylyk.bean;

/**
 * Created by xyb on 2017/3/18.
 */

public class LearnBean {

    /**
     * id : 18937
     * course : {"id":85720,"name":"21天精通Javascript"}
     * listened_time : 1447
     * in_time : 1489581888
     */

    private int id;
    private CourseBean course;
    private int listened_time;
    private int in_time;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public CourseBean getCourse() {
        return course;
    }

    public void setCourse(CourseBean course) {
        this.course = course;
    }

    public int getListened_time() {
        return listened_time;
    }

    public void setListened_time(int listened_time) {
        this.listened_time = listened_time;
    }

    public int getIn_time() {
        return in_time;
    }

    public void setIn_time(int in_time) {
        this.in_time = in_time;
    }

    public static class CourseBean {
        /**
         * id : 85720
         * name : 21天精通Javascript
         */

        private int id;
        private String name;

        public int getId() {
            return id;
        }

        public void setId(int id) {
            this.id = id;
        }

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }
    }
}
