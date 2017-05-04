package com.zhuomogroup.ylyk.activity;

import android.content.Context;
import android.graphics.Rect;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.KeyEvent;
import android.view.View;
import android.view.inputmethod.EditorInfo;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.google.gson.Gson;
import com.reactmodules.callback.BaseStringCallback;
import com.zhuomogroup.ylyk.R;
import com.zhuomogroup.ylyk.adapter.YLSearchAdapter;
import com.zhuomogroup.ylyk.base.YLBaseActivity;
import com.zhuomogroup.ylyk.consts.YLBaseUrl;
import com.zhuomogroup.ylyk.bean.CourseListBean;
import com.zhuomogroup.ylyk.bean.RequestBean;
import com.zhuomogroup.ylyk.network.Signature;
import com.zhy.http.okhttp.OkHttpUtils;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.TreeMap;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import okhttp3.Call;

import static com.zhuomogroup.ylyk.network.Signature.UrlSignature;

/**
 * Created by xyb on 2017/3/24.
 */

public class YLSearchActivity extends YLBaseActivity implements TextView.OnEditorActionListener, TextWatcher {
    @BindView(R.id.searchView)
    EditText searchView;
    @BindView(R.id.recycler_view)
    RecyclerView recyclerView;
    @BindView(R.id.search_clear)
    ImageView searchClear;
    @BindView(R.id.text_back)
    TextView textBack;
    @BindView(R.id.loading_re)
    RelativeLayout loadingRe;
    @BindView(R.id.null_network)
    RelativeLayout nullNetwork;
    @BindView(R.id.null_search)
    RelativeLayout nullSearch;
    private YLSearchAdapter ylSearchAdapter;

    @Override
    public int bindLayout() {
        return R.layout.activity_search;
    }

    @Override
    public void initView(View view) {
        ButterKnife.bind(this);

    }

    @Override
    public void doBusiness(Context mContext) {
        ylSearchAdapter = new YLSearchAdapter(this);
        searchView.setOnEditorActionListener(this);
        searchView.addTextChangedListener(this);
        recyclerView.setLayoutManager(new LinearLayoutManager(this));
        recyclerView.addItemDecoration(new MyItemDecoration());
        recyclerView.setAdapter(ylSearchAdapter);
    }

    @Override
    public void resume() {

    }

    @Override
    public void destroy() {

    }


    @Override
    public boolean onEditorAction(TextView v, int actionId, KeyEvent event) {

        if (actionId == EditorInfo.IME_ACTION_SEARCH) {
            String keyword = searchView.getText().toString().trim();
            searchCourse(keyword);
            return true;
        }

        return false;
    }

    private void searchCourse(final String keyword) {
        if (!(keyword.trim().length() > 0)) {
            Toast.makeText(this, "输入再搜索", Toast.LENGTH_SHORT).show();
            return;
        }
        loadingRe.setVisibility(View.VISIBLE);
        TreeMap<String, String> treeMap = new TreeMap<String, String>();
        treeMap.put("keyword", keyword);
        OkHttpUtils.get()
                .url(YLBaseUrl.BASE_URL_HEAD + "course" + UrlSignature(treeMap))
                .headers(Signature.UrlHeaders(this))
                .build()
                .execute(new BaseStringCallback() {
                    @Override
                    public void onError(Call call, Exception e, int id) {
                        e.printStackTrace();
                        loadingRe.setVisibility(View.GONE);
                        nullNetwork.setVisibility(View.VISIBLE);

                    }

                    @Override
                    public void onResponse(String response, int id) {
                        loadingRe.setVisibility(View.GONE);
                        nullNetwork.setVisibility(View.GONE);
                        Gson gson = new Gson();
                        RequestBean requestBean = gson.fromJson(response, RequestBean.class);
                        if (requestBean.isResult()) {
                            response = requestBean.getResponse();
                            try {
                                JSONArray jsonArray = new JSONArray(response);
                                ArrayList<CourseListBean> courseListBeen = new ArrayList<>();
                                for (int i = 0; i < jsonArray.length(); i++) {
                                    JSONObject jsonObject = jsonArray.getJSONObject(i);
                                    CourseListBean courseListBean = gson.fromJson(jsonObject.toString(), CourseListBean.class);
                                    courseListBeen.add(courseListBean);
                                }
                                if (courseListBeen.size() > 0) {
                                    nullSearch.setVisibility(View.GONE);
                                } else {
                                    nullSearch.setVisibility(View.VISIBLE);
                                }
                                ylSearchAdapter.setCourseList(courseListBeen, keyword);
                            } catch (JSONException e) {
                                e.printStackTrace();
                            }

                        } else {
                            Toast.makeText(YLSearchActivity.this, "requestBean.getCode():" + requestBean.getCode(), Toast.LENGTH_SHORT).show();
                        }
                    }
                });
    }


    @Override
    public void beforeTextChanged(CharSequence s, int start, int count, int after) {

    }

    @Override
    public void onTextChanged(CharSequence s, int start, int before, int count) {

    }

    @Override
    public void afterTextChanged(Editable s) {
        if (s.length() > 0) {
            searchClear.setVisibility(View.VISIBLE);
        } else {
            searchClear.setVisibility(View.GONE);
        }

    }


    @OnClick({R.id.search_clear, R.id.text_back, R.id.null_network, R.id.null_search})
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.search_clear:
                searchView.setText("");
                break;
            case R.id.text_back:
                finish();
                break;
            case R.id.null_network:
                break;
            case R.id.null_search:
                break;
        }
    }

    private class MyItemDecoration extends RecyclerView.ItemDecoration {
        /**
         * @param outRect 边界
         * @param view    recyclerView ItemView
         * @param parent  recyclerView
         * @param state   recycler 内部数据管理
         */
        @Override
        public void getItemOffsets(Rect outRect, View view, RecyclerView parent, RecyclerView.State state) {
            //设定底部边距为1px
            outRect.set(0, 0, 0, 1);
        }
    }

}
