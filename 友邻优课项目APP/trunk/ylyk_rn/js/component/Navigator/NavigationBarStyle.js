// NavigationBarStyle 导航条的样式
// create by 小广
'use strict';
import React, {
    StyleSheet,
    Platform,
} from 'react-native';
import g_AppValue from '../../configs/AppGlobal.js'
export default  StyleSheet.create({
    // navBar
    nav_barView: {
        justifyContent: 'center',
        //backgroundColor:'black',
    },
    nav_bar: {
        //flex:1,
        flex: 1,
        flexDirection: 'row',
        justifyContent: 'center',
    },
    // 标题纯title
    nav_title: {
        marginLeft: 2 * g_AppValue.precent,
        fontSize: 18 * g_AppValue.precent,
        //fontWeight:'bold',
        textAlign: 'center',
        flex: 1,
    },
    // titleView
    nav_titleView: {
        flex: 1,
        marginLeft: 4 * g_AppValue.precent,
        alignItems: 'center',
        justifyContent: 'center',
        //backgroundColor:'yellow',
    },
    nav_ItemView: {
        // width:80*g_AppValue.precent,
        // justifyContent: 'center',
        //backgroundColor:'red',
    },
    // 左Item
    nav_leftItem: {
        marginLeft: 8 * g_AppValue.precent,
        marginTop: Platform.OS == 'ios' ? 0 : -5 * g_AppValue.precent,
        flex: 1,
        justifyContent: 'center',
        alignSelf: 'flex-start',
        //backgroundColor:'green',
    },
    // 左Item为title
    nav_leftTitle: {
        marginRight: 5 * g_AppValue.precent,
        marginLeft: 5 * g_AppValue.precent,
        fontSize: 14 * g_AppValue.precent,
    },
    // 左图片
    nav_leftImage: {
        margin: 10 * g_AppValue.precent,
        marginLeft: 4 * g_AppValue.precent,
        height: 18 * g_AppValue.precent,
        width: 18 * g_AppValue.precent,
        resizeMode: 'contain',
    },
    // 右Item
    nav_rightItem: {
        marginRight: 8 * g_AppValue.precent,
        flex: 1,
        justifyContent: 'center',
        alignSelf: 'flex-end',
        //backgroundColor:'#3393F2',
    },
    // 右Item为title
    nav_rightTitle: {
        marginRight: 5 * g_AppValue.precent,
        marginLeft: 5 * g_AppValue.precent,
        fontSize: 14 * g_AppValue.precent,
    },
    // 右图片
    nav_rightImage: {
        margin: 10 * g_AppValue.precent,
        marginRight: 4 * g_AppValue.precent,
        height: 18 * g_AppValue.precent,
        width: 18 * g_AppValue.precent,
        resizeMode: 'contain',
        //backgroundColor:'#f00',
    },
    nav_rightImage1: {
        margin: 10 * g_AppValue.precent,
        marginRight: 4 * g_AppValue.precent,
        height: 18 * g_AppValue.precent,
        width: 18 * g_AppValue.precent,
        backgroundColor: 'red',
        //backgroundColor:'#f00',
    },
    //resizeMode:'contain',
});
