package com.zhuomogroup.ylyk.adapter;

import android.content.Context;
import android.content.res.Resources;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.zhuomogroup.ylyk.R;
import com.zhuomogroup.ylyk.bean.DataListBean;
import com.zhuomogroup.ylyk.utils.AudioTimeUtil;
import com.zhy.changeskin.SkinManager;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import static com.zhuomogroup.ylyk.utils.SharedPreferencesUtil.get;

/**
 * Created by xyb on 2017/3/11.
 */

public class YLPlayListAdapter extends BaseAdapter {

    private ArrayList<DataListBean> dataLists;
    private Context context;
    private int isPlayPosition = 0;
    private Resources resources;
    private boolean isPlay;

    private int[] color = {R.color.is_play_name, R.color.is_play_name_green, R.color.is_play_name_night, R.color.is_play_name_yellow};
    private int[] bottomColor = {R.color.is_play_bottom, R.color.is_play_bottom_green, R.color.is_play_bottom_night, R.color.is_play_bottom_yellow};

    private int position;

    public YLPlayListAdapter(ArrayList<DataListBean> dataLists, Context context, int position) {
        this.dataLists = dataLists;
        this.context = context;
        resources = context.getResources();
        this.position = position;
    }

    @Override
    public int getCount() {
        return dataLists != null && dataLists.size() > 0 ? dataLists.size() : 0;
    }

    @Override
    public Object getItem(int position) {

        return dataLists != null && dataLists.size() > 0 ? dataLists.get(position) : null;
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        ViewHolder viewHolder = null;

        if (convertView == null) {
            viewHolder = new ViewHolder();
            convertView = LayoutInflater.from(context).inflate(R.layout.item_playlist, parent, false);
            viewHolder.course_name = (TextView) convertView.findViewById(R.id.course_name);
            viewHolder.teacher_name = (TextView) convertView.findViewById(R.id.teacher_name);
            viewHolder.course_duration = (TextView) convertView.findViewById(R.id.course_duration);
            viewHolder.course_time = (TextView) convertView.findViewById(R.id.course_time);
            viewHolder.view1 = convertView.findViewById(R.id.view1);
            viewHolder.view2 = convertView.findViewById(R.id.view2);
            viewHolder.list_play_type = (ImageView) convertView.findViewById(R.id.list_play_type);
            convertView.setTag(viewHolder);
        } else {
            viewHolder = (ViewHolder) convertView.getTag();
        }

        SkinManager.getInstance().injectSkin(convertView);
        if ((position + "").equals(isPlayPosition + "")) {

            viewHolder.course_name.setTextColor(resources.getColor(color[this.position]));
            viewHolder.teacher_name.setTextColor(resources.getColor(bottomColor[this.position]));
            viewHolder.course_duration.setTextColor(resources.getColor(bottomColor[this.position]));
            viewHolder.course_time.setTextColor(resources.getColor(bottomColor[this.position]));
            viewHolder.view1.setBackgroundColor(resources.getColor(bottomColor[this.position]));
            viewHolder.view2.setBackgroundColor(resources.getColor(bottomColor[this.position]));
            viewHolder.list_play_type.setVisibility(View.VISIBLE);

            if (isPlay) {
                viewHolder.list_play_type.setSelected(false);
            } else {
                viewHolder.list_play_type.setSelected(true);
            }

        } else {
            viewHolder.list_play_type.setVisibility(View.INVISIBLE);
            viewHolder.course_name.setTextColor(resources.getColor(R.color.no_play_name));
            viewHolder.teacher_name.setTextColor(resources.getColor(R.color.no_play_bottom));
            viewHolder.course_duration.setTextColor(resources.getColor(R.color.no_play_bottom));
            viewHolder.course_time.setTextColor(resources.getColor(R.color.no_play_bottom));
            viewHolder.view1.setBackgroundColor(resources.getColor(R.color.no_play_bottom));
            viewHolder.view2.setBackgroundColor(resources.getColor(R.color.no_play_bottom));
        }


        try {
            DataListBean item = (DataListBean) getItem(position);
            int courseId = item.getCourseId();
            String teacherName = item.getTeacherName();
            String content = (String) get(context, courseId + "", "");
            long in_time = 0;
            if (teacherName.equals("")) {
                if ((!"".equals(content))) {
                    JSONObject object = new JSONObject(content);
                    JSONArray teachers = object.getJSONArray("teachers");
                    teacherName = teachers.toString();
                    in_time = object.getLong("in_time");
                } else {
                    teacherName = "[]";
                }
            } else {
                in_time = item.getIn_time();
            }
            String name = item.getName();
            int duration = item.getDuration();
            JSONArray array = new JSONArray(teacherName);
            JSONObject jsonObject = array.getJSONObject(0);
            String teacher = jsonObject.getString("name");
            if (array.length() > 1) {
                viewHolder.teacher_name.setText(teacher + " 等");
            } else {
                viewHolder.teacher_name.setText(teacher);
            }
            if (!(in_time == 0)) {
                Date date = new Date(in_time * 1000L);
                SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
                String format = dateFormat.format(date);
                viewHolder.course_time.setText(format);
            } else {
                viewHolder.course_time.setText("");
            }
            viewHolder.course_name.setText(name);
            String course_duration = AudioTimeUtil.secToTime(duration * 1000);
            viewHolder.course_duration.setText(course_duration);
        } catch (JSONException e) {
            e.printStackTrace();
        }


        return convertView;
    }

    private class ViewHolder {
        TextView course_name, teacher_name, course_duration, course_time;
        View view1, view2;
        ImageView list_play_type;

    }

    public void setIsPlayPosition(int isPlayPosition) {
        this.isPlayPosition = isPlayPosition;
        notifyDataSetChanged();
    }

    public int getIsPlayPosition() {
        return isPlayPosition;
    }


    public boolean isPlay() {
        return isPlay;
    }

    public void setPlay(boolean play) {
        isPlay = play;
        notifyDataSetChanged();
    }
}
