
import React, { Component } from 'react';
import {
    Text,
    View,
    ListView,
    TouchableOpacity,
    TouchableHighlight,
    Dimensions,
    StyleSheet,
    DeviceEventEmitter,
} from 'react-native';
//common
import Util from "../../common/util.js";
import styles from "../../common/styles.js";
import Icon from "../../common/Icon.js";

export default class DownloadItem extends Component {
    constructor(props) {
        super(props);
        this.state = {
            isChecked: this.props.rowData.isChecked,
            selectCount:this.props.selectCount,
        }
    }

    //点击cell选中本条
    _checkThis() {
      this.selectCount = DeviceEventEmitter.addListener('selectCount',()=>{

          this.setState({
              isChecked: this.state.isChecked
          });
      });

        this.setState({
            isChecked:!this.props.rowData.isDownloaded && !this.state.isChecked
        });
    }

    componentWillUnmount(){
      this.selectCount && this.selectCount.remove();
    }

    render() {
        var rowId = this.props.rowId;
        var rowData = this.props.rowData;
        return (
            <View style={[styles.section, styles.row]}>
                <View style={[styles.alignCenter, { width: 42 }]}>
                    <TouchableOpacity activeOpacity={1}
                        activeOpacity={0.8}
                        onPress={() => {
                            this._checkThis();
                            this.props.onTapItem(rowId);
                        }}>
                        <Text
                            style={[styles.icon, styles.text21,
                            this.state.isChecked ? styles.textRed : styles.textGrey]}>
                            {this.props.rowData.isDownloaded ? Icon.checked : (this.state.isChecked ? Icon.checked : Icon.checkBox)}
                        </Text>
                    </TouchableOpacity>
                </View>
                <TouchableOpacity activeOpacity={1}
                    activeOpacity={1}
                    style={[styles.bgWhite, styles.primary, styles.container, pageStyles.sections,
                    { backgroundColor: rowData.isDownloaded ? '#eef1f2' : '#fff' }]}
                    onPress={() => {
                        this._checkThis();
                        this.props.onTapItem(rowId)
                    }}>
                    <View >
                        <Text style={[styles.text16, styles.textBlack]}>{rowData.name}</Text>
                        <Text style={[styles.textGrey, styles.textSmall, styles.courseList, styles.courseDesc]}>
                            {rowData.durationFormat}
                        </Text>
                    </View>
                </TouchableOpacity>
            </View>
        )
    }
}

var pageStyles = StyleSheet.create({
    sections: {
        paddingTop: 11,
        paddingBottom: 9,
        //IOS
        shadowColor: '#000',
        shadowOffset: { w: 0, h: 0 },
        shadowOpacity: 0.1,
        shadowRadius: 8,
    },
    courseName: {
        marginTop: 8,
    }
});
