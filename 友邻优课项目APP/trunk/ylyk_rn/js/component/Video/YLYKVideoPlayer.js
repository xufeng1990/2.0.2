// // YLYKVideoPlayer.js

import React, { Component, PropTypes } from 'react';
import { requireNativeComponent } from 'react-native';

// requireNativeComponent 自动把这个组件提供给 "RCTVideoPlayer"
var RCTVideoPlayer = requireNativeComponent('YLYKVideoPlayer', YLYKVideoPlayer);

export default class YLYKVideoPlayer extends Component {

  render() {
    return <RCTVideoPlayer {...this.props} />;
  }

}

YLYKVideoPlayer.propTypes = {
    /**
    * 属性类型，其实不写也可以，js会自动转换类型
    */
    videoRULString:PropTypes.string,
};

module.exports = YLYKVideoPlayer;