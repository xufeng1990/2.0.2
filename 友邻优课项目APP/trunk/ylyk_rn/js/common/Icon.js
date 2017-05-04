/**
 * Created by 艺术家 on 2017/3/8.
 */

export  default  sourceCode = {
    filter: "e654",         //漏斗
    checkBox: "e681",       //复选框
    checked: "e65a",        //已选择
    delete: "e684",         // 删除
    fail: "e64e",           //失败
    music: "e630",          //正在播放
    back: "e639",          //返回
    camera: "e641",         //相机
    man: "e65b",            //人头像
    headset: "e61c",        //耳机
    image: "e608",          //图片
    upPull: "e64f",         //上拉箭头
    downPull: "e651",       //下拉箭头
    note: "e656",           //笔记
    pauseReverse: "e674",   //暂停 - 填充 - 反色
    edit: "e61e",           //修改，编辑
    lock: "e63c",           //锁
    close: "e63d",           //关闭
    download: "e641",       //下载
    female: "e642",         //女
    male: "e648",           //男
    phone: "e649",          //手机
    pause: "e64b",          //暂停
    wechat: "e64b",         //微信
    play: "e662",           //播放
    more: "e64d",           //更多
    pulldown: "e652",       //下拉的箭头-实体箭头
    question: "e64f",       //问题-问号
    save: "e650",           //保存
    search: "e651",          //搜索
    sent: "e652",           //发送
    setting: "e653",        //设置
    share: "e655",          //分享
    wait: "e658",           //等待
    likeFill: "e65f",       //点赞-填充-反色
    like: "e660",           //点赞
    playFill: "e661",      //播放-填充-反色,
    rightArrow: "e6b7",     //右键头
    plus: "e622",           //加号
    wechatFill: "e600",       //微信有背景
    zhifubao: "e607",        //支付宝
    listen:"e61c",       //收听人数
    close:"e63c",           //收听人数

};

(function () {
    for (let item in sourceCode) {
        sourceCode[item] = String.fromCharCode(parseInt(sourceCode[item], 16))
    }
})();
