//
//  HomeViewController.swift
//  SegmentedControl
//
//  Created by 孟辉 on 2019/1/25.
//  Copyright © 2019 孟辉. All rights reserved.
//

import UIKit


extension SlidePageController:UICollectionViewDelegate{
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = scrollView.contentOffset.x/self.view.frame.width
        segmentedControl.selectIndex(index: Int(index))
    }
    
}
let sc_cellIdentifier = "SegmentedControlcellIdentifier"
extension SlidePageController:UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
   
        return CGSize(width: self.view.frame.width,height: self.view.frame.height-segmentedControl.frame.maxY)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.childViewControllers.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: sc_cellIdentifier, for: indexPath)
        
        for  view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        let currentView  = self.childViewControllers[indexPath.row].view
        currentView?.frame = cell.bounds;
        cell.contentView.addSubview(currentView ?? UIView())
        
        return cell
    }
    
    
}

class SlidePageController: UIViewController {

    lazy var splitView :UICollectionView = {
       let flowLayou = UICollectionViewFlowLayout()
        flowLayou.minimumLineSpacing = 0
        flowLayou.minimumInteritemSpacing = 0
        flowLayou.scrollDirection = .horizontal

        let coll = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayou)
        coll.isPagingEnabled = true
        coll.delegate = self
        coll.dataSource = self
        coll.register(UICollectionViewCell.self, forCellWithReuseIdentifier: sc_cellIdentifier)
        return coll
    }()
    deinit {
        splitView.delegate = nil
        splitView.dataSource = nil
    }
    var titleArray = [SegmentedControlDateSource]()
   
    lazy var segmentedControl : SegmentedControl = {
        let s = SegmentedControl(titleData: titleArray, frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40))
        s.segmentedItemSelected = {(itemModel) in
            self.splitView.setContentOffset(CGPoint(x: CGFloat(itemModel.index)*self.view.frame.width, y: 0), animated: false)
        }
        return s
    }()
    
    var selectedInedx:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//       let s = SegmentedControl(titleData: ["推荐","热卖","限时秒杀","今日专栏","直通车","麻辣香锅","聚划算"], frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40))
//       self.view.addSubview(s)
//
        
        
    
       
//
//        for i in 1...10 {
//            let banner = Banner(title: "第\(i)个", image: "image", id: i)
//
//            titleArray.append(banner)
//
//
//            let vc  = MHViewController()
//            vc.view.backgroundColor = i%2==0 ? UIColor.red : UIColor.purple
//            self.addChild(vc)
//
//        }
        segmentedControl.selectIndex(index: selectedInedx)
        
        self.view.addSubview(segmentedControl)
        self.view.addSubview(splitView);
        
    }
    
    
    func reloadData(){
        self.segmentedControl.reloadData(titleData: titleArray)
        self.splitView.reloadData()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.splitView.frame = CGRect(x: 0, y: segmentedControl.frame.maxY, width: self.view.frame.width, height: self.view.frame.height-segmentedControl.frame.maxY)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

