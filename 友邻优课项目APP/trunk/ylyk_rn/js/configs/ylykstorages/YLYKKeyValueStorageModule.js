'use strict'

import {
    NativeModules
} from 'react-native'

var YLYKKeyValueStorageModule = NativeModules.YLYKKeyValueStorageModule;


export default {
    getItem: YLYKKeyValueStorageModule.getItem,
    setItem: YLYKKeyValueStorageModule.setItem,
    remove: YLYKKeyValueStorageModule.remove,
    clear: YLYKKeyValueStorageModule.clear,
    getAllKeys: YLYKKeyValueStorageModule.getAllKeys
}