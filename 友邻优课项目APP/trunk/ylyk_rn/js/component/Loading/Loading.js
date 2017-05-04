import React, {Component} from 'react';
import {
    StyleSheet,
    Dimensions,
    NativeModules,
    Platform,
    View,
    Image
} from 'react-native';

import OrientationLoadingOverlay from 'react-native-orientation-loading-overlay';
import LoadingAndroid from "./LoadingAndroid.js";

export default class Loading extends Component {
    render() {
        let windowHeight = Dimensions.get("window").height,
            widowWhidth = Dimensions.get("window").width;
        return (
            Platform.OS === "ios" ?
                <OrientationLoadingOverlay
                    visible={this.props.visible}
                >
                    <View >
                        <Image style={{width:30,height:30}}
                               source={require('../../imgs/loading-cat.gif')}
                        />
                    </View>
                </OrientationLoadingOverlay>
                :
                <LoadingAndroid
                    style={{width:widowWhidth,height:this.props.visible?windowHeight:0,position:"absolute"}}/>
        )
    }
} 

