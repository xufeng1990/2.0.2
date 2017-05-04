/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import {
  AppRegistry,
  StyleSheet,
  Text,
  View,
  TouchableHighlight,
  NativeAppEventEmitter,
  NativeModules
} from 'react-native';

const NativeEncodeString = NativeModules.NSStringTools;
const WeChat = NativeModules.WeChat;
const NativeNetWork = NativeModules.NativeNetwork;
const Storage = NativeModules.Storage;
const Download = NativeModules.Notification;
var events;
export default class ylyk extends Component {

constructor(props) {
    super(props);
    // NativeEncodeString.getMD5String("1234567890",(error,events)=> {
    //   console.log( 'dwfsdv ' + events);
    // });
    // NativeEncodeString.getSha1EncodeStringWithString("1234567890",(error,events) => {
    //   console.log(events);
    // });
    //  NativeEncodeString.getHmacSha1EncodeWithKey("11","1234567890",(error,events) => {
    //   console.log(events);
    // });
    //  NativeEncodeString.getHMACMD5WithStringWithKey("11","1234567890",(error,events) => {
    //   console.log(events);
    // });

    Storage.setItemByKey("name",JSON.stringify(1)).then((datas)=> {
       console.warn('data', datas);
            alert(datas);
        }).catch((err)=> {
            console.warn('err', err);
            alert(err);
    })
    Storage.getItemByKey("name").then((datas)=> {
       console.warn('data', datas);
            alert(datas);
        }).catch((err)=> {
            console.warn('err', err);
            alert(err);
    })
   
}

  render() {
    return (
      <View style={styles.container}>
        <Text style={styles.welcome}>
          Welcome to React Native!
        </Text>
        <Text style={styles.instructions}>
          To get started, edit index.ios.js
        </Text>
        <Text style={styles.instructions}>
          Press Cmd+R to reload,{'\n'}
          Cmd+D or shake for dev menu
        </Text>
        <View style={styles.home}>
          <TouchableHighlight onPress={this._onPress}>
             <Text>wechat</Text>
          </TouchableHighlight>
          <TouchableHighlight onPress={this._onPressLocation}>
             <Text>location</Text>
          </TouchableHighlight>
        </View>
      </View>
    );
  }
componentDidMount() {
      Download.addEvent('kJPFDidReceiveRemoteNotification',{'111':'222'});
}

componentWillUnmount() {
  JPushModule.removeReceiveCustomMsgListener();
      JPushModule.removeReceiveNotificationListener();
      BackAndroid.removeEventListener('hardwareBackPress');
      NativeAppEventEmitter.removeAllListeners();
     DeviceEventEmitter.removeAllListeners();
  }

_onPressLocation = () => {
  
NativeNetWork.getCourseById('642').then((datas)=> {
            console.warn('data', datas);
            alert(datas);
        }).catch((err)=> {
            console.warn('err', err);
            alert(err);
        });
 var subscription = NativeAppEventEmitter.addListener(
          'kJPFDidReceiveRemoteNotification',
          (message) => {
        //下面就是发送过来的内容，可以用stringfy打印发来的消息
            console.log("content: " + JSON.stringify(message));
            alert('3333333');
      })
}

 _onPress = () => {
    
    }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
  home: {
    marginTop:100,
    marginBottom:400,
    backgroundColor: 'yellow',
    flex: 1,
  },
});

AppRegistry.registerComponent('ylyk', () => ylyk);
