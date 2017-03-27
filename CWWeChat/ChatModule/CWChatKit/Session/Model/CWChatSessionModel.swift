//
//  CWChatSessionModel.swift
//  CWWeChat
//
//  Created by chenwei on 2017/3/26.
//  Copyright © 2017年 cwcoder. All rights reserved.
//

import UIKit

/// 会话模型
class CWChatSessionModel: NSObject {

    /// 会话
    var chatSession: CWChatSession
    /// 未读消息
    var unreadCount: Int {
        return chatSession.unreadCount
    }
    
    /// 最后消息时间
    var lastMessageTime: String {
        
        guard let message = chatSession.lastMessage else {
            return ""
        }
        
        let date = Date(timeIntervalSince1970: message.timestamp)
        return ChatTimeTool.timeStringFromSinceDate(date)
    }
    
    var content: String {
        
        if (self.chatSession.draft != nil) {
            return "[草稿]"+self.chatSession.draft!
        }
        
        guard let message = chatSession.lastMessage else {
            return ""
        }
        
        switch message.messageType {
        case .text:
            let messageBody = message.messageBody as! CWTextMessageBody
            return messageBody.text
        case .image:
            return "[图片]"
        case .voice:
            return "[声音]"
        case .video:
            return "[视频]"
        case .location:
            return "[位置]"
            
        default:
            return "[未知消息]"
        }
        
    }
    
    init(session: CWChatSession) {
        self.chatSession = session
        
        
    }
    
}
