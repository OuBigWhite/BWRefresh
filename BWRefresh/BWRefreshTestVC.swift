//
//  BWRefreshTestVC.swift
//  BWRefresh
//
//  Created by 冉彬 on 2020/4/23.
//  Copyright © 2020 BigWhite. All rights reserved.
//

import UIKit

class BWRefreshTestVC: UIViewController, UITableViewDelegate,UITableViewDataSource  {
    
    var page: Int = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "BWRefresh"
        self.view.backgroundColor = .white
        self.tableView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screentHeight - bottomSafeAreaHeight)
        self.view.addSubview(self.tableView)
        
        self.loadData()
        
    }
    
    lazy var dataAry: Array<String> = {
        let obj = Array<String>()
        return obj
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none // 隐藏cell分割线
        tableView.backgroundColor = .lightGray
        let view = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 60))
        view.backgroundColor = .cyan
        tableView.tableFooterView = view
        tableView.bw_header = BWRefreshHeader(action: {
            print("刷新。。。。。\(Date())")
            self.refreshData()
        })
        tableView.bw_footer = BWRefreshFooter(action: {
            self.loadMoreData()
        })
        
        tableView.bw_footer?.isShow = false
        
        return tableView
    }()
    
    func refreshData(){
        self.page = 1
        self.loadData()
    }
    
    func loadMoreData() {
        self.page += 1
        self.loadData()
    }
    
    func loadData() {
        DispatchQueue.main.asyncAfter(deadline: .now()+2) { [weak self] in
            
            if self?.page == 1 {
                self?.dataAry.removeAll()
            }
            var num = 20
            if self?.dataAry.count ?? 0 > 80 {
                num = 12
            }
            for index in 0...num {
                self?.dataAry.append("\(index)")
            }
            self?.tableView.bw_footer?.isShow = num > 19
            self?.tableView.reloadData()
            self?.tableView.bw_header?.endRefresh()
            self?.tableView.bw_footer?.endRefresh()
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
