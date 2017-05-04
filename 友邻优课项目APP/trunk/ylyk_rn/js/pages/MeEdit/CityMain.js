/**
 * Created by 艺术家 on 2017/3/12.
 */


import React, { Component } from 'react';
import { Text, View, TouchableOpacity, Dimensions, ListView } from 'react-native';
//common
import Icon from "../../common/Icon.js";
import styles from "../../common/styles.js";
//component
import Header from "../../component/HeaderBar/HeaderBar.js";
import Cell from "../../component/Cells/Cell.js";
//pages
import CityData from "./data/cityData.js";
import City from "./City.js";


export default class CityMain extends Component {

    constructor(props) {
        super(props);
        var ds = new ListView.DataSource({ rowHasChanged: (r1, r2) => r1 !== r2 });
        this.state = {
            dataSource: ds.cloneWithRows([]),
        };
    }

    _backFun = () => {
        this.props.navigator.pop();
    };

    //渲染前
    componentWillMount() {
        //获取数据
        this.setState({
            dataSource: this.state.dataSource.cloneWithRows(CityData),
        });

    }

    _selectCity(rowId) {
        this.props.navigator.push({
            name: "City",
            component: City,
            params: {
                index: rowId,
                setCity: this.props.setCity
            }
        });
    }

    render() {
        return (
            <View style={[styles.bgGrey]}>
                <Header backFun={this._backFun} title={"选择地区"} />
                <View style={[styles.section, styles.bgWhite]}>
                    <ListView
                        style={[{ height: Dimensions.get('window').height - 84 }]}
                        dataSource={this.state.dataSource}
                        enableEmptySections={true}
                        removeClippedSubviews={false}
                        renderRow={(rowData, sectionId, rowId) =>
                            <TouchableOpacity activeOpacity={1} onPress={() => {
                                this._selectCity(rowId);
                            }}
                                style={[styles.cell, rowId >= CityData.length - 1 ? null : styles.cellBorder]} >
                                <Text style={[styles.textLeft, styles.text16]}>
                                    {rowData.value}
                                </Text>
                            </TouchableOpacity>
                        }
                    />
                </View>
            </View>
        )
    }
}
