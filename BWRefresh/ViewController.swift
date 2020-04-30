//
//  ViewController.swift
//  BWRefresh
//
//  Created by 冉彬 on 2020/4/23.
//  Copyright © 2020 BigWhite. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "BWRefresh"
        self.view.addSubview(self.tableView)
        
    }
    var page: Int = 1
    
    lazy var dataAry: Array<String> = {
        let obj = Array<String>()
        return obj
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        let con: UIRefreshControl = UIRefreshControl.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: 50))
        con.tintColor = UIColor.lightGray
        con.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
        return con
    }()
    
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none // 隐藏cell分割线
        tableView.backgroundColor = .lightGray
        tableView.addSubview(self.refreshControl)
        let view = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 60))
        view.backgroundColor = .lightGray
        tableView.tableFooterView = view
        
        
        return tableView
    }()
    
    
    deinit {
        print("\(self)被销毁了")
    }
    
    @objc func refreshAction() {
        print("kaishishuaxin")
        self.refreshData()
    }
    
    
    func refreshData(){
        self.page = 1
        self.loadData()
    }
    
    func loadMoreData() {
        self.page += 1
        self.loadData()
    }
    
    func loadData() {
        if page == 1 {
            self.dataAry.removeAll()
        }
        for index in 0...20 {
            self.dataAry.append("\(index)")
        }
    }
    
    
    //MARK:-UITableViewDelegate,UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataAry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //创建cell
        var cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "ReviewListCell")
        if cell == nil {
            //自定义cell使用此方法
            cell = UITableViewCell(style: .default, reuseIdentifier: "ReviewListCell")
            
        }
        
        let str = self.dataAry[indexPath.row]
        cell?.textLabel?.text = str
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}

