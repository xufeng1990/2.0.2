/**
 * Created by 艺术家 on 2017/3/9.
 * cells组件
 * props: [{tag: "姓名"，content："艺术家",cellPull: false}]
 */


import React, {Component} from 'react';
import {Text, View, TouchableOpacity, ListView} from 'react-native';
import Icon from "../../common/Icon.js";

import styles from "../../common/styles.js"
export default class BottomCheckbox extends Component {
    // 构造
    constructor(props) {
        super(props);
        const ds = new ListView.DataSource({rowHasChanged: (r1, r2) => r1 !== r2});
        this.state = {
            dataSource: ds.cloneWithRows(this.props.cells),
        };
    }
    refresh(data, index) {
        this.props.father.showActionSheet(data, index);
        let sourceData = this.props.father.state.cellsData[data];
        let newData = JSON.stringify(sourceData);
        let newDataSource = JSON.parse(newData);
        // console.log(this.props.father.state.cellsData[data]);
        this.setState({
            dataSource: this.state.dataSource.cloneWithRows(newDataSource),
        });
    }
    render() {
        return (
            <View style={[styles.section, styles.cells, styles.bgWhite]}>
                <ListView
                    dataSource={this.state.dataSource}
                    enableEmptySections={true}
                    renderRow={(rowData, sectionId, rowId) =>
                        <TouchableOpacity style={[styles.cell, styles.cellBorder]}
                            onPress={() => {
                                this.refresh(this.props.dataFrom, rowId);
                            }}>
                            <View style={[styles.primary]}>
                                <Text style={[styles.textLeft, styles.text16]}>
                                    {rowData.tag}
                                </Text>
                            </View>
                            <View style={[]}>
                                <Text style={[styles.textRight, styles.text16, styles.textGrey]}>
                                    {rowData.content}
                                </Text>
                            </View>
                            {
                                rowData.cellPull ?
                                    <View style={[styles.cellPull]}>
                                        <Text style={[styles.text16, styles.textGrey]}>
                                            >
                                        </Text>
                                    </View> : null
                            }
                        </TouchableOpacity>
                    }
                />
            </View>
        )
    }
}