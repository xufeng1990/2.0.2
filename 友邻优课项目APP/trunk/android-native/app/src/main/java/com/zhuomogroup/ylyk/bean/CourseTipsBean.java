package com.zhuomogroup.ylyk.bean;

import java.util.List;

/**
 * Created by xyb on 2017/3/18.
 */

public class CourseTipsBean {

    /**
     * id : 2333
     * course : {"id":85720,"name":"21天精通Javascript"}
     * user : {"id":167285,"realname":"张三","nickname":"大张"}
     * content : 大开眼界，这车飙的飞快。
     * position : New York City
     * images : ["http://xxx.bkt.clouddn.com/note-01.jpg","http://xxx.bkt.clouddn.com/note-02.jpg"]
     * like_count : 18
     * is_liked : false
     * in_time : 1471361724
     */

    private int id;
    private CourseBean course;
    private UserBean user;
    private String content;
    private String position;
    private int like_count;
    private boolean is_liked;
    private int in_time;
    private List<String> images;

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

    public UserBean getUser() {
        return user;
    }

    public void setUser(UserBean user) {
        this.user = user;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getPosition() {
        return position;
    }

    public void setPosition(String position) {
        this.position = position;
    }

    public int getLike_count() {
        return like_count;
    }

    public void setLike_count(int like_count) {
        this.like_count = like_count;
    }

    public boolean isIs_liked() {
        return is_liked;
    }

    public void setIs_liked(boolean is_liked) {
        this.is_liked = is_liked;
    }

    public int getIn_time() {
        return in_time;
    }

    public void setIn_time(int in_time) {
        this.in_time = in_time;
    }

    public List<String> getImages() {
        return images;
    }

    public void setImages(List<String> images) {
        this.images = images;
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

    public static class UserBean {
        /**
         * id : 167285
         * realname : 张三
         * nickname : 大张
         */

        private int id;
        private String realname;
        private String nickname;

        public int getId() {
            return id;
        }

        public void setId(int id) {
            this.id = id;
        }

        public String getRealname() {
            return realname;
        }

        public void setRealname(String realname) {
            this.realname = realname;
        }

        public String getNickname() {
            return nickname;
        }

        public void setNickname(String nickname) {
            this.nickname = nickname;
        }
    }
}
