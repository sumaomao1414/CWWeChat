//
//  MessageModel.swift
//  ChatKit
//
//  Created by chenwei on 2017/10/4.
//

import ChatClient

public enum MessagePlayStatus {
    case none
    case playing
    case played
}

class MessageModel {
    
    private let message: Message
    
    public var isSend: Bool {
        return message.direction == .send
    }
    
    public var messageBody: MessageBody {
        return message.messageBody
    }
    
    /// 消息类型
    public var messageType: MessageType {
        return message.messageBody.type
    }
    
    public var sendStatus: MessageSendStatus {
        return message.sendStatus
    }
    
    public var messageId: String {
        return message.messageId
    }
    
    public var from: String {
        return message.from
    }
    
    public var conversationId: String {
        return message.conversationId
    }
    
    public var transportProgress: Float = 0
    
    public var playStatus: MessagePlayStatus = .none
    
    /// 是否显示时间
    public var showTime: Bool = false
    /// 是否显示用户名 
    public var showUsername: Bool = false
    
    public init(message: Message) {
        self.message = message        
    }
}

extension MessageModel: Hashable, Equatable, CustomStringConvertible {
    
    public static func ==(lhs: MessageModel, rhs: MessageModel) -> Bool {
        return lhs.message == rhs.message
    }
    
    public var hashValue: Int {
        return message.hashValue
    }

    public var description: String {
        return message.description
    }
}


// 添加拓展
extension MessageType {
    //获取cell的reuseIdentifier
    var identifier: String {
        switch self {
        case .text:
            return "ChatMessageTextCell"
        case .image:
            return "ChatMessageImageCell"
        case .voice:
            return "ChatMessageVoiceCell"
        case .video:
            return "ChatMessageVideoCell"
        case .emoticon:
            return "ChatMessageEmoticonCell"
        case .file:
            return "ChatMessageFileCell"
        case .location:
            return "ChatMessageLocationCell"
        default:
            return "ChatMessageCell"
        }
    }
    
    init(identifier: String) {
        switch identifier {
        case "ChatMessageTextCell":
            self = .text
        case "ChatMessageImageCell":
            self = .image
        case "ChatMessageVoiceCell":
            self = .voice
        case "ChatMessageEmoticonCell":
            self = .emoticon
        case "ChatMessageLocationCell":
            self = .location
        default:
            self = .none
        }
    }
    
}
