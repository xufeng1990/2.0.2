package com.zhuomogroup.ylyk.popupwindow;

import android.app.Dialog;
import android.content.Context;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.DialogFragment;
import android.support.v4.app.FragmentActivity;
import android.support.v4.app.FragmentManager;
import android.util.DisplayMetrics;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.widget.AdapterView;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

import com.zhuomogroup.ylyk.R;
import com.zhuomogroup.ylyk.adapter.YLPlayListAdapter;
import com.zhuomogroup.ylyk.bean.DataListBean;
import com.zhuomogroup.ylyk.bean.PlaySelectBean;
import com.zhuomogroup.ylyk.utils.SharedPreferencesUtil;
import com.zhy.changeskin.SkinManager;
import com.zhy.changeskin.utils.PrefUtils;

import org.greenrobot.eventbus.EventBus;
import org.greenrobot.eventbus.Subscribe;
import org.greenrobot.eventbus.ThreadMode;

import java.util.ArrayList;

import static com.zhuomogroup.ylyk.consts.YLBaseUrl.PLAY_POSITION;
import static com.zhuomogroup.ylyk.consts.YLBaseUrl.PLAY_TYPE;
import static com.zhuomogroup.ylyk.consts.YLPlayCode.PLAY_LIST_TYPE;
import static com.zhuomogroup.ylyk.consts.YLPlayCode.THIS_BIGIN_PLAY_TYPE;

/**
 * Created by xyb on 2017/3/11.
 */

public class YLPlayListDialogFragment extends DialogFragment implements View.OnClickListener, AdapterView.OnItemClickListener {

    private ImageView play_type_img;
    private TextView play_title_text;

    private TextView play_type_text;
    private ListView play_list;
    private ImageView close_img;
    private YLPlayListAdapter ylPlayListAdapter;

    private GoToPlay goToPlay;
    private ArrayList<DataListBean> dataLists;
    private int[] play_type_imgs = {R.mipmap.play_button_byone, R.mipmap.play_button_next, R.mipmap.play_button_singletrack};
    private int[] play_type_imgs_green = {R.mipmap.play_button_byone_green, R.mipmap.play_button_next_green, R.mipmap.play_button_singletrack_green};
    private int[] play_type_imgs_night = {R.mipmap.play_button_byone_night, R.mipmap.play_button_next_night, R.mipmap.play_button_singletrack_night};
    private int[] play_type_imgs_yellow = {R.mipmap.play_button_byone_yellow, R.mipmap.play_button_next_yellow, R.mipmap.play_button_singletrack_yellow};
    private String[] play_type_texts = {"单节循环", "顺序播放", "单节播放"};
    private int play_type_now;
    private String[] show_type = {"", "green", "night", "yellow"};

    private int[][] playTypes = {play_type_imgs, play_type_imgs_green, play_type_imgs_night, play_type_imgs_yellow};
    private int position = 0;
    public static YLPlayListDialogFragment newInstance(ArrayList<DataListBean> dataLists, int position, boolean isPlay, String playListName) {

        Bundle args = new Bundle();
        args.putParcelableArrayList("dataLists", dataLists);
        args.putInt("position", position);
        args.putBoolean("isPlay", isPlay);
        args.putString("playListName", playListName);
        YLPlayListDialogFragment fragment = new YLPlayListDialogFragment();
        fragment.setArguments(args);
        return fragment;
    }

    @Override
    public void onAttach(Context context) {
        super.onAttach(context);
        goToPlay = (GoToPlay) context;
    }

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        FragmentActivity activity = getActivity();
        if (activity != null) {
            SkinManager.getInstance().register(activity);
        }
        super.onCreate(savedInstanceState);
        EventBus.getDefault().register(this);

    }


    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        play_type_now = (int) SharedPreferencesUtil.get(getActivity().getApplicationContext(), PLAY_LIST_TYPE, THIS_BIGIN_PLAY_TYPE);

        PrefUtils prefUtils = new PrefUtils(getActivity());
        String suffix = prefUtils.getSuffix();
        for (int i = 0; i < show_type.length; i++) {
            if (show_type[i].equals(suffix)) {
                position = i;
            }
        }

        getDialog().requestWindowFeature(Window.FEATURE_NO_TITLE);
        Bundle arguments = getArguments();
        dataLists = arguments.getParcelableArrayList("dataLists");
        int position = arguments.getInt("position");
        boolean isPlay = arguments.getBoolean("isPlay");
        String playListName = arguments.getString("playListName");
        View view = inflater.inflate(R.layout.fragment_playlist, container, false);

        SkinManager.getInstance().injectSkin(view);
        play_type_img = (ImageView) view.findViewById(R.id.play_type_img);

        play_type_text = (TextView) view.findViewById(R.id.play_type_text);
        play_title_text = (TextView) view.findViewById(R.id.play_title_text);
        play_list = (ListView) view.findViewById(R.id.play_list);
        close_img = (ImageView) view.findViewById(R.id.close_img);
        ylPlayListAdapter = new YLPlayListAdapter(dataLists, getActivity().getApplicationContext(),this.position);
        ylPlayListAdapter.setIsPlayPosition(position);
        ylPlayListAdapter.setPlay(isPlay);
        play_list.setAdapter(ylPlayListAdapter);
        close_img.setOnClickListener(this);
        play_type_img.setOnClickListener(this);
        play_type_text.setOnClickListener(this);
        play_list.setOnItemClickListener(this);
        play_list.setSelection(position);

        play_title_text.setText(playListName);
        play_type_img.setImageResource(playTypes[this.position][play_type_now]);
        play_type_text.setText(play_type_texts[play_type_now]);
        return view;
    }

    @Subscribe(threadMode = ThreadMode.MAIN) //在ui线程执行
    public void onDataSynEvent(PlaySelectBean playSelectBean) {
        if (playSelectBean != null) {
            String type = playSelectBean.getType();
            if (type.equals(PLAY_POSITION)) {
                int courseId = playSelectBean.getCourseId();
                int position = 0;
                if (dataLists != null) {
                    for (int i = 0; i < dataLists.size(); i++) {
                        int course = dataLists.get(i).getCourseId();
                        if (courseId == course) {
                            position = i;
                            //   获得当前曲目的下标
                        }
                    }
                }
                ylPlayListAdapter.setIsPlayPosition(position);

            } else if (type.equals(PLAY_TYPE)) {
                ylPlayListAdapter.setPlay(playSelectBean.isPlay());
            }

        }

    }

    @Override
    public void onStart() {
        super.onStart();
        Dialog dialog = getDialog();
        if (dialog != null) {
            DisplayMetrics dm = new DisplayMetrics();
            getActivity().getWindowManager().getDefaultDisplay().getMetrics(dm);
            dialog.getWindow().setLayout((int) (dm.widthPixels), (int) (dm.heightPixels * 0.7));
            dialog.getWindow().setGravity(Gravity.BOTTOM);
        }
    }

    public void showDialog(FragmentManager manager) {
        show(manager, "PlayList");
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.close_img:
                dismiss();
                break;
            case R.id.play_type_img:
                playType(v);
                break;
            case R.id.play_type_text:
                playType(v);
                break;

        }

    }

    private void playType(View v) {
        play_type_now = play_type_now + 1;
        int type = play_type_now % 3;
        play_type_img.setImageResource(playTypes[this.position][type]);
        play_type_text.setText(play_type_texts[type]);
        SharedPreferencesUtil.put(v.getContext(), PLAY_LIST_TYPE, type);
        EventBus.getDefault().post("PLAY_TYPE");
    }


    @Override
    public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
        if (ylPlayListAdapter.getIsPlayPosition() == position) {
            goToPlay.changePlayType();
        } else {
            DataListBean itemAtPosition = (DataListBean) parent.getItemAtPosition(position);
            int courseId = itemAtPosition.getCourseId();
            ylPlayListAdapter.setIsPlayPosition(position);

            goToPlay.gotoPlayById(courseId);
        }

    }


    @Override
    public void onDestroy() {
        super.onDestroy();
        EventBus.getDefault().unregister(this);
        FragmentActivity activity = getActivity();
        if (activity != null) {
            SkinManager.getInstance().unregister(activity);
        }
    }

    public interface GoToPlay {
        void gotoPlayById(int courseId);

        void changePlayType();
    }
}
