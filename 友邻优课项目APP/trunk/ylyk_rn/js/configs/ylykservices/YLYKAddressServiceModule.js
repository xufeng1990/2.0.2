'use strict'
/**
 * 地址
 */
import {
    NativeModules
} from 'react-native'

var YLYKAddressServiceModule = NativeModules.YLYKAddressServiceModule;

export default {
  getAddressList:YLYKAddressServiceModule.getAddressList,//获取收货地址列表
  createAddress:YLYKAddressServiceModule.createAddress,//创建新的收货地址
  updateAddress:YLYKAddressServiceModule.updateAddress,//修改指定的收货地址
  deleteAddress:YLYKAddressServiceModule.deleteAddress,//删除指定的收货地址
}
