/**
 * Created by 艺术家 on 2017/2/27.
 */

import {StyleSheet,} from 'react-native';
export default StyleSheet.create({
    footer: {
        position: 'absolute',
        bottom: 0,
        left: 0,
        right: 0,
        flexDirection: 'row',
        justifyContent: 'space-between',
        height: 50,
        borderTopColor: "#979797",
        borderTopWidth: StyleSheet.hairlineWidth,
        alignItems: 'center',
        paddingHorizontal: 12,
        backgroundColor: "#fff"
    },
    downloadBtn: {
        backgroundColor: '#b41930',
        width: 90,
        height: 30,
        justifyContent: 'center',
        alignItems: 'center',
        borderRadius: 15,
    },
    btnShadow: {
        margin: 28,
        //IOS
        shadowColor: '#000',
        shadowOffset: {width: 0, height: 0},
        shadowOpacity: 0.1,
        shadowRadius: 8,
        //Android
        elevation: 2,
    },
    btnText: {
        color: "#fff",
        fontSize: 17
    },
    checkBox: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: "center"
    },
    icon: {
        fontFamily: 'iconfont'
    },
    textGreen: {
        color: "#b41930"
    },
});
