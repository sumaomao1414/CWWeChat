//
//  CWChatConversationController.swift
//  CWWeChat
//
//  Created by chenwei on 2017/3/26.
//  Copyright © 2017年 cwcoder. All rights reserved.
//

import UIKit

/// 会话
class CWChatConversationController: UIViewController {

    var conversationList = [CWChatConversationModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        let chatManager = CWChatClient.share.chatManager
        let result = chatManager.fetchAllConversations()
        for conversation in result {
            conversationList.append(CWChatConversationModel(conversation: conversation))
        }
        chatManager.addChatDelegate(self, delegateQueue: DispatchQueue.main)
        
        
        CWChatKit.share.userInfoDataSource = self
        setupUI()
        registerCellClass()
        // Do any additional setup after loading the view.
    }
    
    func setupUI() {
        self.view.addSubview(self.tableView)
    }
    
    func registerCellClass() {
        self.tableView.register(CWChatConversationCell.self, forCellReuseIdentifier: CWChatConversationCell.identifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: 属性Getter
    /// TableView
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.backgroundColor = UIColor.white
        tableView.rowHeight = 64.0
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableHeaderView = self.searchController.searchBar
        return tableView
    }()
    
    lazy var searchController: CWSearchController = {
        let searchController = CWSearchController(searchResultsController: self.searchResultController)
        searchController.searchResultsUpdater = self.searchResultController
        searchController.searchBar.placeholder = "搜索"
        searchController.searchBar.delegate = self
        searchController.showVoiceButton = true
        return searchController
    }()
    
    //搜索结果
    var searchResultController: CWSearchResultController = {
        let searchResultController = CWSearchResultController()
        return searchResultController
    }()
    
}

// MARK: - CWChatUserInfoDataSource
extension CWChatConversationController: CWChatUserInfoDataSource {
    func loadUserInfo(userId: String, completion: @escaping ((CWChatUser?) -> Void)) {
        let model = CWChatUserModel(userId: "chenwei")
        model.nickname = userId
        model.avatarURL = "http://o7ve5wypa.bkt.clouddn.com/\(userId).jpg"
        completion(model)
    }
}


//MARK: UITableViewDelegate UITableViewDataSource
extension CWChatConversationController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteTitle = "删除"
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: deleteTitle) { (action:UITableViewRowAction, indexPath) in
            
            //获取当前model
            let _ = self.conversationList[indexPath.row]
            //数组中删除
            self.conversationList.remove(at: indexPath.row)
            //从数据库中删除
            
            //删除
            self.tableView.deleteRows(at: [indexPath], with: .none)
        }
        
        let actionTitle = "标记已读"
        let moreAction = UITableViewRowAction(style: UITableViewRowActionStyle.normal, title: actionTitle) { (action:UITableViewRowAction, indexPath) in
            
            tableView.setEditing(false, animated: true)
        }
        return [deleteAction,moreAction]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let chatVC = CWChatMessageController()
        let conversation = conversationList[indexPath.row].conversation
        chatVC.conversation = conversation
        chatVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.conversationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CWChatConversationCell.identifier, for: indexPath) as! CWChatConversationCell
        cell.conversationModel = conversationList[indexPath.row]
        return cell
    }
}

// MARK: - UISearchBarDelegate
extension CWChatConversationController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        let message = "语言搜索"
        let alertController = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        let alertAtion = UIAlertAction(title: "确定", style: .default) { (action) in
            
        }
        alertController.addAction(alertAtion)
        self.present(alertController, animated: true, completion: nil)
    }
}


// MARK: - CWChatManagerDelegate
extension CWChatConversationController: CWChatManagerDelegate {
    // 收到会话变化
    func conversationDidUpdate(_ conversation: CWChatConversation) {

        var unread = 0
        var index = -1
        for i in 0..<conversationList.count {
            let model = conversationList[i].conversation
            if model == conversation {
                index = i
                model.appendMessage(conversation.lastMessage)
            }
            unread += model.unreadCount
        }
        
        // 不是第一个
        if index != 0 {
            conversationList.remove(at: index)
            let model = CWChatConversationModel(conversation: conversation)
            conversationList.insert(model, at: 0)
        }
        
        tableView.reloadData()
        if unread == 0 {
            self.tabBarItem.badgeValue = nil
        } else if (unread > 99) {
            self.tabBarItem.badgeValue = "99+"
        } else {
            self.tabBarItem.badgeValue = "\(unread)"
        }
    }
}

