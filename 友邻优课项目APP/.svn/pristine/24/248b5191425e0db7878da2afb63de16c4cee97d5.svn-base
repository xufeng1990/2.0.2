'use strict'
/**
 * 心得数据
 */
import {
    NativeModules
} from 'react-native'

var YLYKNoteServiceModule = NativeModules.YLYKNoteServiceModule;

export default {
    getNoteList: YLYKNoteServiceModule.getNoteList, // 获得心得列表
    getNoteById: YLYKNoteServiceModule.getNoteById, // 根据心得id获得信息
    deleteNote: YLYKNoteServiceModule.deleteNote, // 删除心得
    likeNote: YLYKNoteServiceModule.likeNote, // 点赞心得
    unlikeNote: YLYKNoteServiceModule.unlikeNote, // 取消点赞
}