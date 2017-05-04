package com.zhuomogroup.ylyk.base;

import android.content.Context;
import android.view.View;

/**
 * Created by xyb on 15/12/3 at UHylab
 *
 * @version 1.0
 */
public interface YLInitActivity {
    /**
     * 绑定布局
     *
     * @return int
     */
    int bindLayout();

    /**
     * 初始化布局
     */
    void initView(final View view);

    /**
     * 业务处理操作（onCreate方法中调用）
     *
     * @param mContext 当前Activity对象
     */
    void doBusiness(Context mContext);

    /**
     * 暂停恢复刷新相关操作（onResume方法中调用）
     */
    void resume();

    /**
     * 销毁、释放资源相关操作（onDestroy方法中调用）
     */
    void destroy();


}
