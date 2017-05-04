package com.reactmodules.download;

import java.io.Serializable;

/**
 * 专辑信息模型
 * Created by xyb on 2017/3/20.
 */

public class Album implements Serializable {
    private int id;
    private String name;

    public Album() {
    }

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