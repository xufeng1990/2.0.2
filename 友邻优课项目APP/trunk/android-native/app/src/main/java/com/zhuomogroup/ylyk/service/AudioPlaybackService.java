package com.zhuomogroup.ylyk.service;

import android.annotation.SuppressLint;
import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.BroadcastReceiver;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.graphics.Bitmap;
import android.graphics.BitmapShader;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.media.AudioManager;
import android.net.Uri;
import android.os.Environment;
import android.os.Handler;
import android.os.IBinder;
import android.os.Message;
import android.support.annotation.Nullable;
import android.support.v4.app.NotificationCompat;
import android.telephony.PhoneStateListener;
import android.telephony.TelephonyManager;
import android.util.Log;
import android.view.View;
import android.widget.RemoteViews;
import android.widget.Toast;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.engine.bitmap_recycle.BitmapPool;
import com.bumptech.glide.load.resource.bitmap.BitmapTransformation;
import com.bumptech.glide.request.animation.GlideAnimation;
import com.bumptech.glide.request.target.SimpleTarget;
import com.danikula.videocache.CacheListener;
import com.danikula.videocache.HttpProxyCacheServer;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.WritableNativeMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.google.gson.Gson;
import com.reactmodules.callback.BaseStringCallback;
import com.zhuomogroup.ylyk.MainApplication;
import com.zhuomogroup.ylyk.R;
import com.zhuomogroup.ylyk.activity.YLAudioActivity;
import com.zhuomogroup.ylyk.consts.YLBaseUrl;
import com.zhuomogroup.ylyk.bean.DataListBean;
import com.zhuomogroup.ylyk.bean.RequestBean;
import com.zhuomogroup.ylyk.bean.TimeBean;
import com.zhuomogroup.ylyk.network.Signature;
import com.zhuomogroup.ylyk.utils.HeadsetUtil;
import com.zhuomogroup.ylyk.utils.JsonToMapUtil;
import com.zhuomogroup.ylyk.utils.SharedPreferencesUtil;
import com.zhy.http.okhttp.OkHttpUtils;
import com.zhy.http.okhttp.callback.StringCallback;

import org.greenrobot.eventbus.EventBus;
import org.greenrobot.eventbus.Subscribe;
import org.greenrobot.eventbus.ThreadMode;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.videolan.libvlc.LibVLC;
import org.videolan.libvlc.Media;
import org.videolan.libvlc.MediaPlayer;

import java.io.File;
import java.net.SocketException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Locale;
import java.util.TimeZone;
import java.util.concurrent.TimeoutException;

import okhttp3.Call;

import static com.zhuomogroup.ylyk.consts.YLPlayCode.PLAY_LIST_TYPE;
import static com.zhuomogroup.ylyk.utils.EncryptionUtil.MD5;
import static com.zhuomogroup.ylyk.consts.YLPlayCode.THIS_BIGIN_PLAY_TYPE;
import static com.zhuomogroup.ylyk.consts.YLStorageKey.IS_LOGIN;
import static com.zhuomogroup.ylyk.consts.YLStorageKey.LAST_AUDIO_ID;
import static com.zhuomogroup.ylyk.consts.YLStorageKey.LOCAL_LISTEN;
import static com.zhuomogroup.ylyk.consts.YLUrlSetting.JSON_MEDIA_TYPE;
import static com.zhuomogroup.ylyk.network.Signature.UrlSignature;
import static com.zhuomogroup.ylyk.utils.SharedPreferencesUtil.get;
import static com.zhuomogroup.ylyk.utils.SharedPreferencesUtil.put;
import static me.iwf.photopicker.utils.FileUtils.fileIsExists;

/**
 * Created by xyb on 2017/1/17.
 */

public class AudioPlaybackService extends Service {


    private final static String TAG = "AudioPlaybackService";
    private static final String ANDROID_INTENT_ACTION_NEW_OUTGOING_CALL = "android.intent.action.NEW_OUTGOING_CALL";

    private MediaPlayer mediaPlayer;
    private LibVLC mLibVLC;
    private OnListener onListener;
    private OnListenerTwo onListenerTwo;
    private String audio_url;
    private HttpProxyCacheServer proxy;
    private static final int PLAY_BY_ONE = 0;
    private static final int PLAY_BY_NEXT = 1;
    private static final int PLAY_TYPE_ONLY = 2;
    private int play_type = 1;
    private int albumId;
    private ArrayList<DataListBean> dataLists;
    private int courseId;
    private int position;

    private int timeAdd = 0;
    /**
     * 收听时长
     */
    private int listenTime = 0;
    private HashMap<String, HashMap<String, Boolean>> hashMapHashMap; // 当天当前节目收听情况 集合
    /**
     * 学习时长
     */
    private int learnTime = 0;


    private Notification notify;

    private PhoneStateListener listener;
    /**
     * 是否手动关闭 Notification 标记
     */
    private boolean isCloseNotify = false;

    /**
     * 通知栏按钮点击事件对应的ACTION
     */
    private final static String ACTION_BUTTON = "com.zhuomogroup.ylyk.ButtonClick";

    private String format; // 当天的时间 sp 标签

    private HashMap<String, Boolean> integerBooleanHashMap; // 当前节目每分钟收听情况 集合
    private String name;
    private int userId;
    private NotificationManager mNotificationManager;
    private PhoneReceiver phoneReceiver;
    private boolean callIsPlay = false;


    private IntentFilter filter = new IntentFilter();
    private int duration;


    private final static String INTENT_BUTTONID_TAG = "ButtonIdYLYK";


    /**
     * 上一首 按钮点击 ID
     */
    private final static int BUTTON_PREV_ID = 1;
    /**
     * 播放/暂停 按钮点击 ID
     */
    private final static int BUTTON_PALY_ID = 2;
    /**
     * 下一首 按钮点击 ID
     */
    private final static int BUTTON_NEXT_ID = 3;

    /**
     * 下一首 按钮点击 ID
     */
    private final static int BUTTON_CLOSE = 4;


    /**
     * 通知栏按钮广播
     */
    public ButtonBroadcastReceiver bReceiver;

    /**
     * 广播监听按钮点击时间
     */
    public class ButtonBroadcastReceiver extends BroadcastReceiver {

        @Override
        public void onReceive(Context context, Intent intent) {
            String action = intent.getAction();
            if (action.equals(ACTION_BUTTON)) {
                //通过传递过来的ID判断按钮点击属性或者通过getResultCode()获得相应点击事件
                int buttonId = intent.getIntExtra(INTENT_BUTTONID_TAG, 0);
                switch (buttonId) {
                    case BUTTON_PREV_ID:
                        break;
                    case BUTTON_PALY_ID:
                        if (!mediaPlayer.isPlaying()) {
                            play();
                        } else {
                            pause();
                        }
                        break;
                    case BUTTON_NEXT_ID:
                        if (mediaPlayer.getMedia() != null) {
                            nextAudio();
                        }
                        break;
                    case BUTTON_CLOSE:
                        isCloseNotify = true;
                        if (isPlaying()) {
                            pause();
                        }
                        mNotificationManager.cancelAll();
                        stopForeground(true);
                        break;
                    default:
                        break;
                }
            }
        }
    }


    @Override
    public void onCreate() {
        super.onCreate();
        if (mLibVLC == null) {
            mLibVLC = new LibVLC(this);
            mediaPlayer = new MediaPlayer(mLibVLC);
        }
        if (proxy == null) {
            try {
                proxy = MainApplication.getProxy(getApplicationContext());
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        EventBus.getDefault().register(this);


        HeadsetUtil.getInstance().setOnHeadSetListener(headSetListener);
        HeadsetUtil.getInstance().open(this);

        play_type = (int) get(this, PLAY_LIST_TYPE, THIS_BIGIN_PLAY_TYPE);
        initButtonReceiver();
        mNotificationManager = (NotificationManager) getSystemService(android.content.Context.NOTIFICATION_SERVICE);

        showButtonNotify();

        listener = new PhoneStateListener() {

            @Override
            public void onCallStateChanged(int state, String incomingNumber) {
                //state 当前状态 incomingNumber,貌似没有去电的API
                super.onCallStateChanged(state, incomingNumber);
                switch (state) {
                    case TelephonyManager.CALL_STATE_IDLE:
                        if (!isPlaying()) {
                            if (callIsPlay) {
                                play();
                            }
                        }
                        break;

                    case TelephonyManager.CALL_STATE_RINGING:
                        //输出来电号码
                        if (isPlaying()) {
                            pause();
                            callIsPlay = true;
                        } else {
                            callIsPlay = false;
                        }
                        break;
                }
            }
        };
        filter.addAction(ANDROID_INTENT_ACTION_NEW_OUTGOING_CALL);
        filter.addAction(AudioManager.ACTION_AUDIO_BECOMING_NOISY);
        filter.setPriority(1000);
        phoneReceiver = new PhoneReceiver();
        registerReceiver(phoneReceiver, filter);
        TelephonyManager tm = (TelephonyManager) getSystemService(Service.TELEPHONY_SERVICE);
        tm.listen(listener, PhoneStateListener.LISTEN_CALL_STATE);
    }

    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return new AudioServiceBinder(this);
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        return super.onStartCommand(intent, flags, startId);
    }


    /**
     * 带按钮的通知栏点击广播接收
     */
    public void initButtonReceiver() {
        bReceiver = new ButtonBroadcastReceiver();
        IntentFilter intentFilter = new IntentFilter();
        intentFilter.addAction(ACTION_BUTTON);
        registerReceiver(bReceiver, intentFilter);
    }


    /**
     * 带按钮的通知栏
     */
    public void showButtonNotify() {

        NotificationCompat.Builder mBuilder = new NotificationCompat.Builder(this);
        RemoteViews mRemoteViews = new RemoteViews(getPackageName(), R.layout.view_custom_button);
        mRemoteViews.setImageViewResource(R.id.custom_song_icon, R.mipmap.ic_launcher);
        //API3.0 以上的时候显示按钮，否则消失
        mRemoteViews.setTextViewText(R.id.tv_custom_song_singer, "欢迎使用友邻优课！");
        //如果版本号低于（3。0），那么不显示按钮
        mRemoteViews.setViewVisibility(R.id.ll_custom_button, View.GONE);
        //
        if (isPlaying()) {
            mRemoteViews.setImageViewResource(R.id.btn_custom_play, R.mipmap.btn_pause);
        } else {
            mRemoteViews.setImageViewResource(R.id.btn_custom_play, R.mipmap.btn_play);
        }

        Intent intent = new Intent(Intent.ACTION_MAIN);
        intent.setAction(Intent.ACTION_MAIN);
        intent.addCategory(Intent.CATEGORY_LAUNCHER);
        intent.setComponent(new ComponentName(this,
                YLAudioActivity.class));


        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_RESET_TASK_IF_NEEDED);
        // 点击跳转到主界面
        PendingIntent intent_go = PendingIntent.getActivity(this, 5, intent,
                PendingIntent.FLAG_UPDATE_CURRENT);
        mRemoteViews.setOnClickPendingIntent(R.id.tv_custom_song_singer, intent_go);
        mRemoteViews.setOnClickPendingIntent(R.id.custom_song_icon, intent_go);

        //点击的事件处理
        Intent buttonIntent = new Intent(ACTION_BUTTON);
        /* 上一首按钮 */
        /* 播放/暂停  按钮 */
        buttonIntent.putExtra(INTENT_BUTTONID_TAG, BUTTON_PALY_ID);
        PendingIntent intent_paly = PendingIntent.getBroadcast(this, 2, buttonIntent, PendingIntent.FLAG_UPDATE_CURRENT);
        mRemoteViews.setOnClickPendingIntent(R.id.btn_custom_play, intent_paly);
        /* 下一首 按钮  */
        buttonIntent.putExtra(INTENT_BUTTONID_TAG, BUTTON_NEXT_ID);
        PendingIntent intent_next = PendingIntent.getBroadcast(this, 3, buttonIntent, PendingIntent.FLAG_UPDATE_CURRENT);
        mRemoteViews.setOnClickPendingIntent(R.id.btn_custom_next, intent_next);
        /* 关闭 按钮  */
        buttonIntent.putExtra(INTENT_BUTTONID_TAG, BUTTON_CLOSE);
        PendingIntent intent_close = PendingIntent.getBroadcast(this, 4, buttonIntent, PendingIntent.FLAG_UPDATE_CURRENT);
        mRemoteViews.setOnClickPendingIntent(R.id.close, intent_close);
        mBuilder
                .setContentIntent(getDefalutIntent(Notification.FLAG_ONGOING_EVENT))
                .setWhen(System.currentTimeMillis())// 通知产生的时间，会在通知信息里显示
                .setPriority(Notification.PRIORITY_DEFAULT)// 设置该通知优先级
                .setSmallIcon(R.mipmap.ic_launcher);
        notify = mBuilder.build();


        notify.flags = Notification.FLAG_ONGOING_EVENT;
        //会报错，还在找解决思路
        notify.contentView = mRemoteViews;
        startForeground(200, notify);
    }

    /**
     * @获取默认的pendingIntent,为了防止2.3及以下版本报错
     * @flags属性: 在顶部常驻:Notification.FLAG_ONGOING_EVENT
     * 点击去除： Notification.FLAG_AUTO_CANCEL
     */
    public PendingIntent getDefalutIntent(int flags) {
        return PendingIntent.getActivity(this, 1, new Intent(), flags);
    }


    public interface OnListener {
        void onTimeChange();

        void onPositionChange();

        void Stopped();

        void onEndReached();

        void onPlaying();

        void onPaused();

        void getCacheProgress(int i);

        void checkCachedState(String url);


        void setWebViewContent(String content, String name, JSONArray teachers, boolean is_liked, String like_count, int courseId, String response);
    }


    public interface OnListenerTwo {
        void onTimeChange();

        void onPositionChange();


        void Stopped();

        void onEndReached();

        void onPlaying();

        void onPaused();

        void getCacheProgress(int i);

        void checkCachedState(String url);

        void setWebViewContent(String content, String name);
    }


    public void pause() {
        if (mediaPlayer != null) {
            mediaPlayer.pause();
        }

    }

    public void stop() {
        if (mediaPlayer != null) {
            mediaPlayer.stop();
        }
    }

    public void setRate(float rate) {
        if (mediaPlayer != null) {
            mediaPlayer.setRate(rate);
        }
    }

    public float getRate() {
        if (mediaPlayer != null) {
            return mediaPlayer.getRate();
        }
        return 1;
    }

    public void seekTo(int progress) {
        if (mediaPlayer != null) {
            mediaPlayer.setTime(progress);
        }
    }

    public long getDuration() {
        if (mediaPlayer != null) {

            return mediaPlayer.getLength();
        }
        return 0;
    }

    public long getDurationIntenet() {

        return duration * 1000;
    }

    public long getProgress() {
        if (mediaPlayer != null) {
            return mediaPlayer.getTime();
        }
        return 0;
    }

    public float getPosition() {
        if (mediaPlayer != null) {
            return mediaPlayer.getPosition();
        }
        return 0;
    }


    public boolean isPlaying() {
        return mediaPlayer != null && mediaPlayer.isPlaying();
    }

    public String getAudio_url() {
        return audio_url;
    }

    public void setDataList(int albumId, ArrayList<DataListBean> dataLists) {
        this.albumId = albumId;
        this.dataLists = dataLists;

    }

    public int getAlbumId() {
        return albumId;
    }


    /**
     * Created by qly on 2016/6/22.
     * 将图片转化为圆形
     */
    public class GlideCircleTransform extends BitmapTransformation {
        public GlideCircleTransform(Context context) {
            super(context);
        }

        @Override
        protected Bitmap transform(BitmapPool pool, Bitmap toTransform, int outWidth, int outHeight) {
            return circleCrop(pool, toTransform);
        }

        private Bitmap circleCrop(BitmapPool pool, Bitmap source) {
            if (source == null) return null;

            int size = Math.min(source.getWidth(), source.getHeight());
            int x = (source.getWidth() - size) / 2;
            int y = (source.getHeight() - size) / 2;

            Bitmap squared = Bitmap.createBitmap(source, x, y, size, size);

            Bitmap result = pool.get(size, size, Bitmap.Config.ARGB_8888);
            if (result == null) {
                result = Bitmap.createBitmap(size, size, Bitmap.Config.ARGB_8888);
            }

            Canvas canvas = new Canvas(result);
            Paint paint = new Paint();
            paint.setShader(new BitmapShader(squared, BitmapShader.TileMode.CLAMP, BitmapShader.TileMode.CLAMP));
            paint.setAntiAlias(true);
            float r = size / 2f;
            canvas.drawCircle(r, r, r, paint);
            return result;
        }

        @Override
        public String getId() {
            return getClass().getName();
        }
    }


    public void setDataSource(String dataSource, int courseId, String name, int userId, int duration) {

        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");//设置日期格式
        format = df.format(new Date());
        String json = (String) get(this, format, "");
        if (!"".equals(json)) {
            initMap(json);
        }

        if (hashMapHashMap == null) {
            hashMapHashMap = new HashMap<>();
        }
        integerBooleanHashMap = hashMapHashMap.get(courseId + "");
        if (handler != null) {
            handler.removeMessages(0);
            handler.sendEmptyMessage(1);
        }
        timeAdd = 0;
        this.courseId = courseId;
        this.audio_url = dataSource;
        this.name = name;
        this.userId = userId;
        this.duration = duration;
        String proxyUrl;
        if (proxy != null) {
            proxy.registerCacheListener(cacheListener, dataSource);
            proxyUrl = proxy.getProxyUrl(dataSource);
        } else {
            proxyUrl = dataSource;
        }

        if (mLibVLC != null && mediaPlayer != null) {
            try {
                String sdCardRoot = Environment.getExternalStorageDirectory().getAbsolutePath();
                sdCardRoot = sdCardRoot + "/Android/data/com.zhuomogroup.ylyk/" + "downloads/62933a2951ef01f4eafd9bdf4d3cd2f0/";
                String md5 = MD5(userId + "." + courseId);
                String filePath = md5 + ".cache";
                sdCardRoot = sdCardRoot + filePath;
                boolean isDownload = fileIsExists(sdCardRoot);
                if (isDownload) {
                    proxyUrl = sdCardRoot;
                }
            } catch (Exception e) {
                Toast.makeText(this, "SD卡未加载 或 检查读写权限" + e.getMessage(), Toast.LENGTH_SHORT).show();
            }

            final RemoteViews contentView = notify.contentView;
            contentView.setTextViewText(R.id.tv_custom_song_singer, name);
            Glide.with(this)
                    .load(YLBaseUrl.BASE_URL_HEAD + "course/" + courseId + "/cover")
                    .asBitmap()
                    .fitCenter()
                    .transform(new GlideCircleTransform(this))
                    .into(new SimpleTarget<Bitmap>() {
                        @Override
                        public void onResourceReady(Bitmap resource, GlideAnimation<? super Bitmap> glideAnimation) {
                            contentView.setImageViewBitmap(R.id.custom_song_icon, resource);
                        }
                    });
            if (proxyUrl.contains("://")) {
                Media media = new Media(mLibVLC, Uri.parse(proxyUrl));
                mediaPlayer.setMedia(media);
                media.release();
                mediaPlayer.setEventListener(eventListener);
            } else {
                Media media = new Media(mLibVLC, proxyUrl);
                mediaPlayer.setMedia(media);
                media.release();
                mediaPlayer.setEventListener(eventListener);

            }
        }

    }

    private void initMap(String json) {
        hashMapHashMap = JsonToMapUtil.parseData(json);
    }

    private Handler handler = new Handler(new Handler.Callback() {
        @Override
        public boolean handleMessage(Message msg) {
            boolean is_login = (boolean) get(getApplicationContext(), IS_LOGIN, false);
            if (is_login) {
                switch (msg.what) {
                    case 0:
                        timeAdd++;
                        listenTime = timeAdd;
                        if (handler != null) {
                            handler.sendEmptyMessageDelayed(0, 1000);
                            if (listenTime >= 60) {
                                handler.sendEmptyMessage(1);
                                timeAdd = 0;
                            }
                        }
                        break;
                    case 1:
                        PushTime(learnTime, listenTime);

                        break;
                    case 2:
                        if (hashMapHashMap != null) {
                            hashMapHashMap.put(courseId + "", integerBooleanHashMap);
                            put(AudioPlaybackService.this, format, JsonToMapUtil.mapToJson(hashMapHashMap));
                        }
                        localTodayTime(learnTime, listenTime);
                        learnTime = 0;
                        listenTime = 0;
                        break;
                    case 3:
                        localTodayTime(learnTime, listenTime);
                        // 失败的时候 重置
                        learnTime = 0;
                        listenTime = 0;
                        break;
                    case 4:

                        pushLocalListen();

                        break;
                }
            }


            return true;
        }
    });

    private void pushLocalListen() {
        String s = (String) SharedPreferencesUtil.get(getApplicationContext(), LOCAL_LISTEN, "[]");
        try {
            final JSONArray array = new JSONArray(s);
            if (array.length() > 0) {
                JSONObject jsonObject = array.getJSONObject(0);
                int courseId = jsonObject.getInt("courseId");
                int learnTime = jsonObject.getInt("learnTime");
                int listenTime = jsonObject.getInt("listenTime");
                long upload_time = jsonObject.getLong("upload_time");
                OkHttpUtils.postString()
                        .url(YLBaseUrl.BASE_URL_HEAD + "course/" + courseId + "/stat" + UrlSignature())
                        .headers(Signature.UrlHeaders(this))
                        .content(new Gson().toJson(new TimeBean(listenTime, learnTime, upload_time)))
                        .mediaType(JSON_MEDIA_TYPE)
                        .build()
                        .execute(new BaseStringCallback() {
                            @Override
                            public void onError(Call call, Exception e, int id) {
                                e.printStackTrace();
                            }

                            @Override
                            public void onResponse(String response, int id) {
                                Gson gson = new Gson();
                                RequestBean requestBean = gson.fromJson(response, RequestBean.class);
                                if (requestBean.isResult()) {
                                    JSONArray jsonArray = new JSONArray();
                                    for (int i = 1; i < array.length(); i++) {
                                        try {
                                            JSONObject jsonObject1 = array.getJSONObject(i);
                                            jsonArray.put(jsonObject1);
                                        } catch (JSONException e) {
                                            e.printStackTrace();
                                        }
                                    }
                                    SharedPreferencesUtil.put(getApplicationContext(), LOCAL_LISTEN, jsonArray.toString());

                                    if (handler != null) {
                                        handler.sendEmptyMessageDelayed(4, 1000);
                                    }
                                } else {
                                    Toast.makeText(AudioPlaybackService.this, "requestBean.getCode():" + requestBean.getCode(), Toast.LENGTH_SHORT).show();
                                }
                            }
                        });
            }

            SharedPreferencesUtil.put(getApplicationContext(), LOCAL_LISTEN, array.toString());

        } catch (JSONException e) {
            e.printStackTrace();
        }


    }


    @Subscribe(threadMode = ThreadMode.MAIN) //在ui线程执行
    public void sendMsg(String msg) {
        if (msg.equals("logout")) {
            sendEvent(false);
            stopSelf();
        }
    }


    private void PushTime(int learnTime, int listenTime) {
        if (mediaPlayer != null) {
            try {
                float rate = mediaPlayer.getRate();
                listenTime = (int) (listenTime * rate);
                learnTime = (int) (learnTime * rate);

                final int finalLearnTime = learnTime;
                final int finalListenTime = listenTime;
                OkHttpUtils.postString()
                        .url(YLBaseUrl.BASE_URL_HEAD + "course/" + courseId + "/stat" + UrlSignature())
                        .headers(Signature.UrlHeaders(this))
                        .content(new Gson().toJson(new TimeBean(listenTime, learnTime, getTime())))
                        .mediaType(JSON_MEDIA_TYPE)
                        .build()
                        .execute(new StringCallback() {
                            @Override
                            public void onError(Call call, Exception e, int id) {
                                e.printStackTrace();
                                if (handler != null) {
                                    handler.sendEmptyMessage(3);
                                }
                                try {
                                    String s = (String) SharedPreferencesUtil.get(getApplicationContext(), LOCAL_LISTEN, "[]");
                                    JSONArray array = new JSONArray(s);
                                    JSONObject object = new JSONObject();
                                    object.put("courseId", courseId);
                                    object.put("learnTime", finalLearnTime);
                                    object.put("listenTime", finalListenTime);
                                    object.put("upload_time", getTime());
                                    array.put(object);
                                    SharedPreferencesUtil.put(getApplicationContext(), LOCAL_LISTEN, array.toString());
                                    if (handler != null) {
                                        handler.sendEmptyMessage(4);
                                    }
                                } catch (JSONException e1) {
                                    e1.printStackTrace();
                                }


                            }

                            @Override
                            public void onResponse(String response, int id) {
                                if (handler != null) {
                                    handler.sendEmptyMessage(2);
                                    handler.sendEmptyMessage(4);
                                }
                            }
                        });

            } catch (Exception e) {
                e.printStackTrace();
            }

        }


    }

    private long getTime() {

        TimeZone newZone = TimeZone.getTimeZone("GMT00:00");
        @SuppressLint("SimpleDateFormat") SimpleDateFormat formatter = new SimpleDateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'", Locale.US);
        formatter.setTimeZone(newZone);
        String dat = formatter.format(new Date());
        try {
            Date date = formatter.parse(dat);
            return date.getTime() / 1000L + (8 * 60 * 60L);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return new Date().getTime() / 1000L + (8 * 60 * 60L);

    }

    private void localTodayTime(int learnTime, int listenTime) {
        if (mediaPlayer == null) {
            return;
        }
        float rate = mediaPlayer.getRate();
        listenTime = (int) (listenTime * rate);
        learnTime = (int) (learnTime * rate);


        Gson gson = new Gson();
        // 查询本地是否有学习时间
        String formatTime = (String) get(this, format + "Time" + userId, "");
        if (!"".equals(formatTime)) {
            TimeBean timeBean = gson.fromJson(formatTime, TimeBean.class);
            int learned_time = timeBean.getLearned_time();
            int listened_time = timeBean.getListened_time();
            learned_time = learned_time + learnTime;
            listened_time = listened_time + listenTime;
            put(this, format + "Time" + userId, new Gson().toJson(new TimeBean(listened_time, learned_time, getTime())));
        } else {
            put(this, format + "Time" + userId, new Gson().toJson(new TimeBean(listenTime, learnTime, getTime())));
        }
    }

    private CacheListener cacheListener = new CacheListener() {
        @Override
        public void onCacheAvailable(File cacheFile, String url, int percentsAvailable) {
            if (onListener != null) {
                onListener.getCacheProgress(percentsAvailable);
            }
        }
    };


    private long firstTime;
    private long first;
    private MediaPlayer.EventListener eventListener = new MediaPlayer.EventListener() {
        @Override
        public void onEvent(MediaPlayer.Event event) {
            switch (event.type) {
                case MediaPlayer.Event.MediaChanged:
                    break;
                case MediaPlayer.Event.Paused:
                    sendEvent(false);
                    setIsPlay(false);
                    if (onListener != null) {
                        onListener.onPaused();
                    }
                    if (onListenerTwo != null) {
                        onListenerTwo.onPaused();
                    }
                    if (handler != null) {
                        handler.removeMessages(0);
                        handler.sendEmptyMessage(1);
                    }
                    timeAdd = 0;
                    lastTime(courseId);
                    if (notify != null) {
                        RemoteViews contentView = notify.contentView;
                        contentView.setViewVisibility(R.id.ll_custom_button, View.VISIBLE);
                        contentView.setImageViewResource(R.id.btn_custom_play, R.mipmap.btn_play);
                        if (!isCloseNotify) {
                            mNotificationManager.notify(200, notify);
                            isCloseNotify = false;
                        }
                    }

                    break;
                case MediaPlayer.Event.Playing:
                    sendEvent(true);
                    setIsPlay(true);
                    if (onListener != null) {
                        onListener.onPlaying();
                    }
                    if (onListenerTwo != null) {
                        onListenerTwo.onPlaying();
                    }
                    if (handler != null) {
                        handler.sendEmptyMessageDelayed(0, 1000);
                    }
                    if (notify != null) {
                        if (notify.contentView != null) {
                            notify.contentView.setViewVisibility(R.id.ll_custom_button, View.VISIBLE);
                            notify.contentView.setImageViewResource(R.id.btn_custom_play, R.mipmap.btn_pause);
                            mNotificationManager.notify(200, notify);
                        }
                    }
                    break;
                case MediaPlayer.Event.EncounteredError:
                    Toast.makeText(AudioPlaybackService.this, "播放出错,请检查网络与本地文件是否完全", Toast.LENGTH_SHORT).show();
                    sendEvent(false);
                    setIsPlay(false);
                    break;
                case MediaPlayer.Event.PausableChanged:
                    break;
                case MediaPlayer.Event.TimeChanged:

                    isCloseNotify = false;
                    // 两秒加入一次 上次听到哪里
                    long secondTime = System.currentTimeMillis();
                    if (secondTime - firstTime >= 2000) {
                        firstTime = secondTime;
                        lastTime(courseId);
                    }
                    int time = (int) (mediaPlayer.getTime() / 1000);
                    if (integerBooleanHashMap != null) {
                        if (integerBooleanHashMap.get(time + "") == null) {
                            integerBooleanHashMap.put(time + "", true);
                            learnTime++;
                            if (learnTime > 60) {

                            }
                        }
                    } else {
                        integerBooleanHashMap = new HashMap<>();
                        if (integerBooleanHashMap.get(time + "") == null) {
                            integerBooleanHashMap.put(time + "", true);
                            learnTime++;
                            if (learnTime > 60) {
                            }
                        }
                    }


                    if (onListener != null) {
                        onListener.onTimeChange();
                    }
                    if (onListenerTwo != null) {
                        onListenerTwo.onTimeChange();
                    }

                    break;
                case MediaPlayer.Event.Stopped:
                    if (onListener != null) {
                        onListener.Stopped();
                    }
                    if (onListenerTwo != null) {
                        onListenerTwo.Stopped();
                    }
                    sendEvent(false);
                    setIsPlay(false);
                    if (handler != null) {
                        handler.removeMessages(0);
                        handler.sendEmptyMessage(1);
                    }

                    timeAdd = 0;
                    if (notify != null) {
                        if (notify.contentView != null) {
                            notify.contentView.setViewVisibility(R.id.ll_custom_button, View.VISIBLE);
                            notify.contentView.setImageViewResource(R.id.btn_custom_play, R.mipmap.btn_play);
                            mNotificationManager.notify(200, notify);
                        }
                    }

                    break;
                case MediaPlayer.Event.PositionChanged:
                    if (onListener != null) {
                        onListener.onPositionChange();
                    }
                    if (onListenerTwo != null) {
                        onListenerTwo.onPositionChange();
                    }

                    long second = System.currentTimeMillis();
                    if (second - first >= 5000) {
                        first = second;
                        sendEvent(true);
                        setIsPlay(false);
                    }
                    break;
                case MediaPlayer.Event.SeekableChanged:

                    break;
                case MediaPlayer.Event.Buffering:

                    break;
                case MediaPlayer.Event.Vout:

                    break;
                case MediaPlayer.Event.EndReached:
                    if (onListener != null) {
                        onListener.onEndReached();

                    }
                    sendEvent(false);
                    setIsPlay(false);
                    if (onListenerTwo != null) {
                        onListenerTwo.onEndReached();
                    }

                    if (notify != null) {
                        if (notify.contentView != null) {
                            notify.contentView.setViewVisibility(R.id.ll_custom_button, View.VISIBLE);
                            notify.contentView.setImageViewResource(R.id.btn_custom_play, R.mipmap.btn_play);
                            mNotificationManager.notify(200, notify);
                        }
                    }
                    if (handler != null) {
                        handler.removeMessages(0);
                        handler.sendEmptyMessage(1);
                    }
                    timeAdd = 0;
                    nextAudio();
                    break;

            }

        }
    };

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getCourseId() {
        return courseId;
    }

    public void setCourseId(int courseId) {
        this.courseId = courseId;
    }

    private void nextAudio() {

        switch (play_type) {

            case PLAY_BY_NEXT:
                nextAudioList();
                break;
            case PLAY_TYPE_ONLY:
                Toast.makeText(this, "单节播放完毕", Toast.LENGTH_SHORT).show();
                setDataSource(audio_url, courseId, name, userId, duration);
                stop();
                break;
            case PLAY_BY_ONE:
                setDataSource(audio_url, courseId, name, userId, duration);
                play();
                break;
        }
    }

    private void nextAudioList() {
        if (dataLists != null && dataLists.size() > 0) {
            for (int i = 0; i < dataLists.size(); i++) {
                int courseId = dataLists.get(i).getCourseId();
                if (this.courseId == courseId) {
                    setListPosition(i);
                    //   获得当前曲目的下标
                }
            }


//            if (position == 0) {
////                Toast.makeText(this, "已是专辑最后节目", Toast.LENGTH_SHORT).show();
////                setDataSource(audio_url, courseId, name, userId, duration);
////                stop();
////                return;
//                // 设置最新一首 提示不跳转
//            } else {
//                position = position - 1;
//            }
            position++;

            position = position % dataLists.size();
            final int courseId = dataLists.get(position).getCourseId();


            playByCourseId(courseId);

        }
    }

    public void playByCourseId(final int courseId) {
        String content = (String) SharedPreferencesUtil.get(this, courseId + "", "");
        if (!"".equals(content)) {
            JSONObject jsonObject;
            try {
                jsonObject = new JSONObject(content);
                String media_url = jsonObject.getString("media_url");
                String webContent = jsonObject.getString("content");
                String name = jsonObject.getString("name");
                String replace = webContent.replace(name, "");
                JSONArray teachers = jsonObject.getJSONArray("teachers");
                boolean is_liked = jsonObject.getBoolean("is_liked");
                String like_count = jsonObject.getString("like_count");
                int duration = jsonObject.getInt("duration");
                if (onListener != null) {
                    onListener.checkCachedState(media_url);
                    onListener.setWebViewContent(replace, name, teachers, is_liked, like_count, courseId, content);
                }

                setDataSource(media_url, courseId, name, userId, duration);
                play();

            } catch (JSONException e) {
                e.printStackTrace();
            }
        }
        OkHttpUtils.get()
                .url(YLBaseUrl.BASE_URL_HEAD + "course/" + courseId + UrlSignature())
                .headers(Signature.UrlHeaders(this))
                .build()
                .execute(new BaseStringCallback() {
                             @Override
                             public void onError(Call call, Exception e, int id) {
                                 if (e instanceof TimeoutException) {
                                     Toast.makeText(AudioPlaybackService.this, "网络出错，请稍后再试", Toast.LENGTH_SHORT).show();
                                 } else if (e instanceof SocketException) {
                                     Toast.makeText(AudioPlaybackService.this, "网络出错，请稍后再试", Toast.LENGTH_SHORT).show();
                                 }
                             }

                             @Override
                             public void onResponse(String response, int id) {
                                 Gson gson = new Gson();
                                 RequestBean requestBean = gson.fromJson(response, RequestBean.class);
                                 if (requestBean.isResult()) {
                                     try {
                                         response = requestBean.getResponse();
                                         JSONObject jsonObject = new JSONObject(response);
                                         int courseId = jsonObject.getInt("id");
                                         String media_url = jsonObject.getString("media_url");
                                         String content = jsonObject.getString("content");
                                         String name = jsonObject.getString("name");
                                         String replace = content.replace(name, "");
                                         JSONArray teachers = jsonObject.getJSONArray("teachers");
                                         boolean is_liked = jsonObject.getBoolean("is_liked");
                                         String like_count = jsonObject.getString("like_count");
                                         int duration = jsonObject.getInt("duration");
                                         if (onListener != null) {
                                             onListener.checkCachedState(media_url);
                                             onListener.setWebViewContent(replace, name, teachers, is_liked, like_count, courseId, response);
                                         }
                                         // 缓冲webview内容到本地
                                         put(AudioPlaybackService.this, courseId + "", response);

                                         setDataSource(media_url, courseId, name, userId, duration);
                                         play();

                                     } catch (JSONException e) {
                                         e.printStackTrace();
                                     }
                                 } else {
                                     Toast.makeText(AudioPlaybackService.this, "requestBean.getCode():" + requestBean.getCode(), Toast.LENGTH_SHORT).show();
                                 }
                             }
                         }
                );
    }

    private void setListPosition(int position) {
        this.position = position;
    }


    public void setPlayType(int play_type) {
        this.play_type = play_type;
    }

    public void play() {
        if (mediaPlayer != null) {
            mediaPlayer.play();
        }
    }


    @Override
    public void onDestroy() {

        if (cacheListener != null) {
            proxy.unregisterCacheListener(cacheListener);
        }
        EventBus.getDefault().unregister(this);
        if (mediaPlayer.isPlaying()) {
            lastTime(courseId);
            mediaPlayer.stop();
        }
        clear();
        if (handler != null) {
            handler.removeMessages(0);
            handler.removeMessages(1);
            handler.removeMessages(2);
            handler = null;
        }
        if (mNotificationManager != null) {
            mNotificationManager.cancelAll();
        }
        stopForeground(true);// 停止前台服务--参数：表示是否移除之前的通知
        if (bReceiver != null) {
            unregisterReceiver(bReceiver);
        }
        if (phoneReceiver != null) {
            unregisterReceiver(phoneReceiver);
        }
        TelephonyManager tmgr = (TelephonyManager) getSystemService(Context.TELEPHONY_SERVICE);
        tmgr.listen(listener, 0);

        super.onDestroy();

    }

    /**
     * 上次听到哪里
     */
    private void lastTime(int courseId) {
        String json = "{\"name\":\"" + name + "\",\"time\":" + mediaPlayer.getTime() + ",\"courseId\":" + courseId + "}";
        put(this, courseId + "last_audio", json);
        put(this, LAST_AUDIO_ID, courseId);
    }

    public void clear() {
        if (mediaPlayer != null && mLibVLC != null) {
            if ((!mediaPlayer.isReleased()) && (!mLibVLC.isReleased())) {
                Media media = mediaPlayer.getMedia();
                if (media != null) {
                    media.release();
                    media = null;
                }

                mediaPlayer.release();
                mediaPlayer = null;
                mLibVLC.release();
                mLibVLC = null;
            }
        }

    }

    public void setEventListener(MediaPlayer.EventListener eventListener) {
        mediaPlayer.setEventListener(eventListener);
    }

    public void clearSetOnListener() {
        if (onListener != null) {
            onListener = null;
        }
    }

    public void clearSetOnListenerTwo() {
        if (onListenerTwo != null) {
            onListenerTwo = null;
        }
    }

    public void setOnListener(OnListener onListener) {
        this.onListener = onListener;
    }


    public OnListenerTwo getOnListenerTwo() {
        return onListenerTwo;
    }

    public void setOnListenerTwo(OnListenerTwo onListenerTwo) {
        this.onListenerTwo = onListenerTwo;
    }


    private class PhoneReceiver extends BroadcastReceiver {


        @Override
        public void onReceive(Context context, Intent intent) {
            if (intent.getAction().equals(Intent.ACTION_NEW_OUTGOING_CALL)) {
                if (isPlaying()) {
                    pause();
                    callIsPlay = true;
                } else {
                    callIsPlay = false;
                }
            } else if (intent.getAction().equals(AudioManager.ACTION_AUDIO_BECOMING_NOISY)) {
                if (isPlaying()) {
                    pause();
                }
            }

        }

    }


    HeadsetUtil.OnHeadSetListener headSetListener = new HeadsetUtil.OnHeadSetListener() {
        @Override
        public void onDoubleClick() {
            Log.i("ksdinf", "双击");
        }

        @Override
        public void onClick() {
            Log.i("ksdinf", "单击");
            if (isPlaying()) {
                pause();
            } else {
                play();
            }
        }

        @Override
        public void onThreeClick() {
            Log.i("ksdinf", "三连击");
        }
    };


    public void sendEvent(boolean type) {
        MainApplication application = (MainApplication) getApplication();
        ReactContext reactContext = application.getReactContext();
        if (reactContext != null) {
            WritableMap params = new WritableNativeMap();
            params.putBoolean("isPlayingOrPause", type);
            reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit("playOrPauseToRN", params);

        }

    }

    public static boolean isPlay;

    public static boolean isPlay() {
        return isPlay;
    }

    public static void setIsPlay(boolean isPlay) {
        AudioPlaybackService.isPlay = isPlay;
    }

}
