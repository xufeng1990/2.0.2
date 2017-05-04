/**
 * Created by 艺术家 on 2017/2/28.
 */

import React, { Component } from 'react';
import {
    Text,
    View,
    Image,
    TextInput,
    ScrollView,
    ListView,
    StyleSheet,
    TouchableOpacity,
    TouchableHighlight,
    TouchableWithoutFeedback,
    Alert,
    Dimensions,
} from 'react-native';

export default class Filter extends Component {
    constructor(props) {
        super(props);
        // 初始状态
        this.state = {

        }
    }

    render() {
        return (
            <View style={styles.container}>
                { this.props.data.map((item, index) => {
                        return (
                            <TouchableOpacity activeOpacity={1} key={item.data + index}
                                onPress={() => {
                                    this.props.checkedCallBack(index);
                                }}>
                                <View style={[styles.item, item.isChecked ? styles.itemChecked : '']}>
                                    <Text style={[styles.itemText, item.isChecked ? styles.itemTextChecked : '']}>{item.data}</Text>
                                </View>
                            </TouchableOpacity>
                        )
                    })
                }
            </View>
        )
    }
}

var styles = StyleSheet.create({
    container: {
        flexDirection: 'row',
        flexWrap: "wrap",
        justifyContent: "space-around"
    },
    item: {
        backgroundColor: "#eef1f2",
        borderRadius: 4,
        marginTop: 14,
        justifyContent: 'center',
        alignItems: 'center',
        width: 99,
        height: 34,
    },
    itemChecked: {
        borderColor: "#b41930",
        borderWidth: 1,
        backgroundColor: "#fff",
    },
    itemText: {
        fontSize: 14,
        textAlign: 'center',
    },
    itemTextChecked: {
        color: "#b41930",
    },
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
        paddingHorizontal: 12
    },
    downloadBtn: {
        backgroundColor: '#b41930',
        width: 90,
        height: 30,
        justifyContent: 'center',
        alignItems: 'center',
        borderRadius: 15
    },
    btnText: {
        color: "#fff",
        fontSize: 17
    },
    checkBox: {
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: "center"
    }

});
