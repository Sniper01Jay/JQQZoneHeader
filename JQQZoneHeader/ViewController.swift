//
//  ViewController.swift
//  JQQZoneHeader
//
//  Created by ccd on 2018/10/23.
//  Copyright © 2018年 CCD. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {

    @IBOutlet var tabView: UITableView!
    @IBOutlet var navBarView: UIView!
    @IBOutlet var backBtn: UIButton!
    @IBOutlet var backLab: UILabel!
    @IBOutlet var addBtn: UIButton!
    
    var bigImgView: UIImageView!
    var bigImgHeight: CGFloat = 0
    var headerHeight: CGFloat = 0
    var originalFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    let radio: CGFloat = 880/1279
    let cellID  = "tableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabView.rowHeight = 45
        bigImgHeight = view.frame.width * radio // 根据比例计算图片适合高度
        headerHeight = bigImgHeight - 64
        
        bigImgView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: bigImgHeight))
        bigImgView.image = UIImage.init(named: "photo.jpeg")
        view.insertSubview(bigImgView, at: 0)
        
        originalFrame = bigImgView.frame
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: headerHeight))
        headerView.backgroundColor = UIColor.clear
        tabView.dataSource = self
        tabView.delegate = self
        tabView.backgroundColor = UIColor.clear
        tabView.tableHeaderView = headerView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 25
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID)
        if cell == nil {
            cell = UITableViewCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: cellID)
        }
        cell?.textLabel?.text = "Item \(indexPath.row)"
        return cell!
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        // yOffset在正常的上滑都是正值，在下拉到初始状态，在继续下拉就为负值
        print("yOffset: \(yOffset)")
        if yOffset < headerHeight { //当滑动到导航拉底部之前
            let alpha = yOffset/headerHeight
            navBarView.backgroundColor = UIColor.white.withAlphaComponent(alpha)
            backBtn.setImage(UIImage.init(named: "back"), for: UIControl.State.normal)
            backLab.textColor = .white
            addBtn.setImage(UIImage.init(named: "add"), for: .normal)
        }else{ // 超过导航栏底部
            navBarView.backgroundColor = .white
            backBtn.setImage(UIImage.init(named: "back_sel"), for: .normal)
            backLab.textColor = .black
            addBtn.setImage(UIImage.init(named: "add_sel"), for: .normal)
        }
        
        if yOffset > 0 { //往上移动
            var frame = originalFrame
            frame.origin.y = originalFrame.origin.y - yOffset
            bigImgView.frame = frame
        }else{ // 下拉（类似下拉刷新）
            var frame = originalFrame
            frame.size.height = originalFrame.size.height - yOffset
            frame.size.width = frame.size.height / radio
            frame.origin.x = originalFrame.origin.x - (frame.size.width - originalFrame.size.width)/2
            bigImgView.frame = frame
        }
    }
    
}

