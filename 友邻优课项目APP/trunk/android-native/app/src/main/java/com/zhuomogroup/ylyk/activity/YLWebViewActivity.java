package com.zhuomogroup.ylyk.activity;

import android.content.Context;
import android.content.Intent;
import android.view.View;
import android.webkit.WebChromeClient;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.ImageView;

import com.zhuomogroup.ylyk.R;
import com.zhuomogroup.ylyk.base.YLBaseActivity;
import com.zhuomogroup.ylyk.views.ScrollTextView;

/**
 * Created by xyb on 2017/3/6.
 */

public class YLWebViewActivity extends YLBaseActivity implements View.OnClickListener {

    private ScrollTextView titleCenterText;
    private ImageView titleBack;
    private WebView webView;
    private String url = null;

    @Override
    public int bindLayout() {
        return R.layout.activity_webview;
    }

    @Override
    public void initView(View view) {
        webView = (WebView) view.findViewById(R.id.webview);
        titleBack = (ImageView) view.findViewById(R.id.back_img);
        titleCenterText = (ScrollTextView) view.findViewById(R.id.title_center_text);
    }

    @Override
    public void doBusiness(Context mContext) {
        Intent intent = getIntent();
        if (intent != null) {
            url = intent.getStringExtra("url");
        }

        titleBack.setOnClickListener(this);
        WebSettings settings = webView.getSettings();
        settings.setJavaScriptEnabled(true);
        settings.setDisplayZoomControls(true);
        settings.setDefaultFixedFontSize(20);
        //适应屏幕
        settings.setAppCacheEnabled(true);
        settings.setCacheMode(WebSettings.LOAD_DEFAULT);
        settings.setLayoutAlgorithm(WebSettings.LayoutAlgorithm.NARROW_COLUMNS);
        settings.setLoadWithOverviewMode(true);
        settings.setBuiltInZoomControls(false); // 设置不显示缩放按钮
        webView.setWebChromeClient(new WebChromeClient() {
            @Override
            public void onReceivedTitle(WebView view, String title) {
                super.onReceivedTitle(view, title);
                if (title != null) {
                    titleCenterText.setText(title);
                }
            }
        });
        webView.setWebViewClient(new WebViewClient());
        if (url != null) {
            webView.loadUrl(url);
        }
    }

    @Override
    public void resume() {

    }

    @Override
    public void destroy() {

    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.back_img:
                finish();
                break;
        }

    }

    @Override
    public void onBackPressed() {
        if (webView.canGoBack()) {
            webView.goBack();
        } else {
            super.onBackPressed();
        }

    }
}
