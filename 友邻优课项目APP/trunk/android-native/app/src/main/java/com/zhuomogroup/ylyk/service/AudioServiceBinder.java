package com.zhuomogroup.ylyk.service;

import android.os.Binder;

import com.zhuomogroup.ylyk.bean.DataListBean;

import org.videolan.libvlc.MediaPlayer;

import java.util.ArrayList;

/**
 * Created by xyb on 2017/1/17.
 */

public class AudioServiceBinder extends Binder implements AudioControl {

    private AudioPlaybackService playbackService;

    public AudioServiceBinder(AudioPlaybackService playbackService) {
        this.playbackService = playbackService;
    }

    @Override
    public void pause() {
        playbackService.pause();
    }

    @Override
    public void stop() {
        playbackService.stop();
    }

    @Override
    public void setRate(float rate) {
        playbackService.setRate(rate);
    }

    @Override
    public float getRate() {
        return playbackService.getRate();
    }

    @Override
    public void seekTo(int progress) {
        playbackService.seekTo(progress);
    }

    @Override
    public long getDuration() {
        return playbackService.getDuration();
    }

    @Override
    public long getDurationIntenet() {
        return playbackService.getDurationIntenet();
    }

    @Override
    public long getProgress() {
        return playbackService.getProgress();
    }

    @Override
    public float getPosition() {
        return playbackService.getPosition();
    }

    @Override
    public boolean isPlaying() {
        return playbackService.isPlaying();
    }

    @Override
    public void setDataSource(String path, int courseId,  String name, int userId, int duration) {
        playbackService.setDataSource(path, courseId,  name, userId,duration);
    }

    @Override
    public void play() {
        playbackService.play();
    }

    @Override
    public void clear() {
        playbackService.clear();
    }

    @Override
    public String getAudio_url() {
        return playbackService.getAudio_url();
    }

    @Override
    public void setPlayType(int playType) {
        playbackService.setPlayType(playType);
    }

    @Override
    public void setEventListener(MediaPlayer.EventListener eventListener) {
        playbackService.setEventListener(eventListener);
    }

    @Override
    public void setOnListener(AudioPlaybackService.OnListener onListener) {
        playbackService.setOnListener(onListener);
    }

    @Override
    public void setOnListenerTwo(AudioPlaybackService.OnListenerTwo onListener) {
        playbackService.setOnListenerTwo(onListener);
    }

    @Override
    public void setDataList(int albumId, ArrayList<DataListBean> dataLists) {
        playbackService.setDataList(albumId, dataLists);
    }

    @Override
    public int getAlbumId() {
        return playbackService.getAlbumId();
    }

    @Override
    public void clearSetOnListener() {
        playbackService.clearSetOnListener();
    }

    @Override
    public void clearSetOnListenerTwo() {
        playbackService.clearSetOnListenerTwo();
    }

    @Override
    public String getName() {
        return playbackService.getName();
    }

    @Override
    public int getCourseId() {
        return playbackService.getCourseId();
    }

    @Override
    public void playByCourseId(int courseId) {
        playbackService.playByCourseId(courseId);
    }


}
