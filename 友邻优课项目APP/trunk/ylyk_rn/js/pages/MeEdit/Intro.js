/**
 * Created by 艺术家 on 2017/3/12.
 */

import React, { Component } from 'react';
import { Text, View, TouchableOpacity, TextInput } from 'react-native';
//common
import Icon from "../../common/Icon.js";
import styles from "../../common/styles.js";
//component
import Header from "../../component/HeaderBar/HeaderBar.js";



export default class Intro extends Component {

    constructor(props) {
        super(props);
        this.state = {
            text: this.props.intro
        }
    }

    _backFun = () => {
        this.props.navigator.pop();
    };
    _saveIntro() {
        this.props.setIntro(this.state.text);
        this.props.navigator.pop();
    }

    render() {
        return (
            <View style={[styles.bgGrey, styles.primary]}>
                <Header backFun={this._backFun} title={"一句话简介"} rightBtn={Icon.save} rightFun={() => { this._saveIntro() }} />
                <View style={[styles.section]}>
                    <View style={[styles.bgWhite, { paddingHorizontal: 12 }]}>
                        <TextInput style={[styles.text16, { height: 50, padding: 0, textAlignVertical: "center" }]} multiline={false} placeholder={"一句话介绍自己"}
                            value={this.state.text} autoFocus={true} maxLength={20} onSubmitEditing={() => { this._saveIntro() }}
                            underlineColorAndroid="transparent"
                            onChangeText={(text) => {
                                this.setState({
                                    text: text
                                })
                            }}>
                        </TextInput>
                    </View>

                </View>

            </View>
        )
    }
}
