//
//  CWChatImageView.swift
//  CWWeChat
//
//  Created by chenwei on 16/4/6.
//  Copyright © 2016年 chenwei. All rights reserved.
//

import UIKit
import YYWebImage

///下载展示imageView
class CWChatImageView: UIImageView {
    
    //引导
    let activityView = UIActivityIndicatorView(activityIndicatorStyle: .white)
    
    let indicatorbackgroundView:UIView = {
        let indicatorbackgroundView = UIView()
        indicatorbackgroundView.backgroundColor = UIColor("#80808008")
        return indicatorbackgroundView
    }()
    
    let indicatorLabel:UILabel = {
        let indicatorLabel = UILabel()
        indicatorLabel.font = UIFont.systemFont(ofSize: 11)
        indicatorLabel.textAlignment = .center
        indicatorLabel.textColor = UIColor.white
        indicatorLabel.text = "00%"
        return indicatorLabel
    }()
    
    convenience init() {
        self.init(frame: .zero)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        self.addSubview(indicatorbackgroundView)
        self.addSubview(activityView)
        self.addSubview(indicatorLabel)
        
        //初始化状态
        self.indicatorbackgroundView.isHidden = true
        self.activityView.stopAnimating()
        self.indicatorLabel.isHidden = true 
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
                
        self.indicatorbackgroundView.frame = self.bounds
        self.activityView.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY-10)
        
        self.indicatorLabel.frame.size = CGSize(width: 100, height: 15)
        self.indicatorLabel.frame.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY+8)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
