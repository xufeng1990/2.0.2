//
//  BugoutC.h
//  Bugout
//
//  Copyright (c) 2014 testin. All rights reserved.
//

#ifndef __BUGOUT_C_H_
#define __BUGOUT_C_H_

#define BUGOUT_TYPE_JAVA    0
#define BUGOUT_TYPE_CPP     1
#define BUGOUT_TYPE_OBJC    2
#define BUGOUT_TYPE_LUA     3
#define BUGOUT_TYPE_JS      4
#define BUGOUT_TYPE_CSHARP  5

// 捕获到崩溃时调用，返回当前调用堆栈，不可在该函数内做复杂的操作
typedef void (*crashNotificationCallBack)(const char*);
// 当用户关闭摇一摇反馈时调用
typedef void (*userClosedShakeReportCallBack)(void);

typedef struct __BugoutCallback
{
    crashNotificationCallBack     crashNotificationCallBack;        //default NULL
    userClosedShakeReportCallBack userClosedShakeReportCallBack;    //default NULL
}BugoutCallback;

typedef struct __BugoutCConfig
{
    int enabledMonitorException;       // default 1
    int enabledShakeFeedback;          // default 1
    int alertBtnCloseShakeFeedback;    // default 0
    int useLocationInfo;               // default 0
    int reportOnlyWIFI;                // default 1
    int printLogForDebug;              // default 0
    
    BugoutCallback callback;           // callback struct
    
}BugoutCConfig;

#ifdef __cplusplus
extern "C" {
#endif
    void bugoutInit(const char* cAppId, const char* cChannel);
    void bugoutInitWithConfig(const char* cAppId, const char* cChannel, BugoutCConfig config);
    void bugoutSetUserInfo(const char* cUserInfo);
    void bugoutLeaveBreadcrumb(const char* cString);
    void bugoutReportException(int nType, const char* cMessage, const char* cStacktrace);

    /******************当enabledShakeFeedback设置为NO时，以下方法无效****************/
    //如果Key不存在，则添加数据，并且data不能为空.
    //如果Key已存在，并且data为nil，则删除这个Key，如果data不为nil，则修改这个Key的数据.
    void bugoutSetUserData(const char* cKey, const char* cData);
    //删除所有数据.
    void bugoutRemoveAllUserData(void);
    //开启/关闭摇一摇反馈  0为关闭，非0为开启
    void bugoutEnabledShakeFeedback(int enabled);
    //上传反馈信息
    void bugoutFeedbackWithMessage(const char* cMessage);
    /******************当enabledShakeFeedback设置为NO时，以上方法无效****************/
    
#ifdef __cplusplus
    }
#endif

#endif //__BUGOUT_C_H_
