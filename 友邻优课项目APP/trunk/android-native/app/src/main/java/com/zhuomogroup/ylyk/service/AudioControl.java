package com.zhuomogroup.ylyk.service;

import com.zhuomogroup.ylyk.bean.DataListBean;

import org.videolan.libvlc.MediaPlayer;

import java.util.ArrayList;

/**
 * Created by xyb on 2017/1/17.
 */

public interface AudioControl {
    void pause(); // 暂停

    void stop();

    void setRate(float rate);

    float getRate();

    void seekTo(int progress);

    long getDuration();

    long getDurationIntenet();

    long getProgress();

    float getPosition();

    boolean isPlaying();

    void setDataSource(String path, int courseId, String name, int userId, int duration);

    void play();


    void clear();

    String getAudio_url();

    void setPlayType(int playType);


    void setEventListener(MediaPlayer.EventListener eventListener);


    void setOnListener(AudioPlaybackService.OnListener onListener);

    void setOnListenerTwo(AudioPlaybackService.OnListenerTwo onListener);

    void setDataList(int albumId, ArrayList<DataListBean> dataLists);

    int getAlbumId();

    void clearSetOnListener();

    void clearSetOnListenerTwo();

    String getName();

    int getCourseId();

    void playByCourseId(int courseId);
}
