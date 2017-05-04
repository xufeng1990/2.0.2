/** Created by 艺术家 on 2017/3/9. cell */
import React, { Component } from 'react';
import { Text, View, TouchableOpacity, ListView, TouchableHighlight,Switch ,Platform} from 'react-native';
//common
import Icon from "../../common/Icon.js";
import styles from "../../common/styles.js";
import Util from '../../common/util.js';
//configs
import YLYKNatives from '../../configs/ylykbridges/YLYKNatives.js';
export default class BottomCheckbox extends Component { /* 构造*/
    constructor(props) {
        super(props);
        this.state = {
           SwitchIsOn: false,
           falseSwitchIsOn:false,
        };
    }
    componentWillMount(){
        YLYKNatives.$shake.bugoutFeedbackState()
        .then((data)=>{
          this.setState({
            SwitchIsOn:data
          })
        }).catch((err)=>{
          console.log('错误' + err)
        })
    }

    _switchIsOn(value){

      YLYKNatives.$shake.openOrCloseBugoutFeedBack(value);
      this.setState({
        SwitchIsOn:value,
        falseSwitchIsOn:value,
      })
      if (this.state.falseSwitchIsOn == true) {
        if (Platform.OS == 'ios') {
          Util.AppToast('已关闭 摇一摇反馈，下次启动生效')
        }else {
          return;
        }

      }else {
        Util.AppToast('已开启 摇一摇反馈')
      }
    }

    render() {
        return (
            <TouchableOpacity activeOpacity ={1}  activeOpacity={this.props.cellPull ? 0.97 : 1} onPress={this.props.cellPull ? this.props.cellFun : () => { }}>
                <View style={styles.bgWhite}>
                    <View style={[styles.cell, this.props.cellLast ? null : styles.cellBorder]} >
                        <View >
                            <Text style={[styles.textLeft, styles.text16]}>
                                {this.props.tag}
                            </Text>
                        </View>
                        <View style={[styles.primary, { paddingLeft: 12, justifyContent: "flex-end" },]}>
                          {
                            this.props.categoryNumber == 1
                             ?  <Switch
                                    onTintColor = '#B41930'
                                   style={{position:'absolute',right:5,top:-15,}}
                                   disabled = {false}
                                   onValueChange={(value) =>{this._switchIsOn(value)} }
                                   value={this.state.SwitchIsOn}

                             />
                             :  <Text style={[styles.textRight, styles.text16, styles.textGrey]} numberOfLines={1}>
                                   {this.props.content}
                               </Text>
                          }

                        </View>
                        {
                            this.props.cellPull ?
                                <View style={[styles.cellPull]}>
                                    <Text style={[styles.text16, styles.textGrey, styles.textCenter, styles.icon]}>
                                        {Icon.rightArrow}
                                    </Text>
                                </View>
                                : null
                        }
                    </View>
                </View>
            </TouchableOpacity>

        )
    }
}
