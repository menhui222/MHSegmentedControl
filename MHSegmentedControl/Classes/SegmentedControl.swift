//
//  SegmentedControl.swift
//  SegmentedControl
//
//  Created by 孟辉 on 2019/1/25.
//  Copyright © 2019 孟辉. All rights reserved.
//

import UIKit

typealias SegmentedItemSelected = (SegmentItemModel)->()

protocol SegmentedControlDateSource {
    var text:String{
       get
       set
    }
    func calTextWidth(font:UIFont) -> CGFloat
}

extension SegmentedControlDateSource{
    func calTextWidth(font:UIFont) -> CGFloat{
        return ceil(text.size(withAttributes: [NSAttributedString.Key.font:font]).width)
    }
}
extension String:SegmentedControlDateSource{
    var text: String {
        get {
            return self
        }
        set {
            self = text
        }
    }
    
    
}
struct SegmentItemModel {
    var text:String
    var size:CGSize
    var index:Int
    
    init(text:String,size:CGSize=CGSize(width: 0, height: 0),index:Int = 0) {
        self.text = text
        self.size = size
        self.index = index
    }
}

class SegmentedItem:UIView{
    
    var itemSelectedColor : UIColor  {
        didSet{
            if(isSelected){
                self.titleLabel.textColor = self.itemSelectedColor
            }
        }
    }
    
    var itemDefultColor : UIColor {
        didSet{
            if(!isSelected){
                self.titleLabel.textColor = self.itemDefultColor
            }
        }
    }
    
    
    
    
    var itemModel: SegmentItemModel{
        didSet{
            self.titleLabel.text = itemModel.text
            self.frame.size = itemModel.size
        }
    }
    
    var  segmentedItemSelected:SegmentedItemSelected?
    
    var isSelected:Bool = false {
        didSet{
            if(isSelected){
                self.titleLabel.textColor = self.itemSelectedColor
            }else{
                self.titleLabel.textColor = self.itemDefultColor
            }
        }
    }
    
    lazy var titleBtn:UIButton = {
       let btn =  UIButton(type: .custom)
        btn.addTarget(self, action: #selector(selectItem), for: .touchUpInside)
        return btn
    }()
    @objc func selectItem()  {
        segmentedItemSelected?(itemModel)
    }
    lazy var titleLabel : UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 15.0)
        l.textColor = UIColor.black
        l.textAlignment = .center
        return l
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = self.bounds
        titleBtn.frame = self.bounds
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(model: SegmentItemModel ,frame: CGRect) {
        self.init(frame: frame)
        itemModel = model
        titleLabel.text = model.text;
    }
    override init(frame: CGRect) {
        itemModel = SegmentItemModel(text:"")
        itemDefultColor = UIColor.black
        itemSelectedColor = UIColor.red
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(titleBtn)
        
    }
   
}




/*             ----------------------------------------------------------------------------------------*/


struct  SegmentedConfig{
    
    var itemSelectedColor = UIColor.red
    
    var itemDefultColor = UIColor.black
    
    var titleFont  = UIFont.systemFont(ofSize: 15.0)
    
    var chief_w:CGFloat = 30.0
    
    var trail_w:CGFloat = 30.0
    
    var space_w:CGFloat = 20.0
}

class SegmentedControl: UIView {

    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    enum segmentLayout{
        case fixation(space:CGFloat)
        case scroll
    
    }
   
    var segmentedConfig : SegmentedConfig

    var lineColor = UIColor.red{
        didSet{
            self.lineView.backgroundColor = lineColor;
        }
    }
    
    var lineHeight:CGFloat = 2{
        didSet{
            self.lineView.frame = CGRect(x: self.lineView.frame.minX, y: self.frame.height-self.lineHeight, width: self.lineView.frame.width, height: self.lineHeight);
        }
    }
    
 

    var segmentedItemSelected:SegmentedItemSelected?
    
    private var  layout : segmentLayout = .scroll
    
   
   
    func configSegmentItem(config:()->SegmentedConfig) -> () {
        self.segmentedConfig = config()
        updateView()
    }
    private var dataArray = [SegmentedControlDateSource]()

    private var itemModels = [SegmentItemModel]()
    
    private var labelArray = [SegmentedItem]()
    
   

    private lazy var scorllView :UIScrollView = {
        let s = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
    
        return s
    }()
    
    
    var currentItem:SegmentedItem?
    
    private lazy var lineView:UIView = {
        let line = UIView(frame: CGRect.zero)
        line.backgroundColor = UIColor.red
        return line
    }()
    
    public  init(config:SegmentedConfig = SegmentedConfig(),titleData:[SegmentedControlDateSource],frame: CGRect) {
        
        segmentedConfig = config
        
        super.init(frame: frame)
    
        
        
        addSubview(self.scorllView)
        scorllView.addSubview(self.lineView)
        dataArray = titleData
        configDataModel()
        setupItem()
        if titleData.count > 0 {
            selectIndex(index: 0)
        }
    }
   
   
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //
    
    
    private func removeSegment(){
        labelArray.removeAll()
        dataArray.removeAll()
        itemModels.removeAll()
        for view in self.scorllView.subviews{
            if view.isKind(of: SegmentedItem.self){
                view.removeFromSuperview()
            }
        }
    }
    private func configDataModel(){
        if dataArray.count==0 {
            return;
        }
        var width_sum:CGFloat = 0.0
       
        let height = self.frame.size.height<30 ? self.frame.size.height:30
        
        for i in 0...dataArray.count-1{
            let data = dataArray[i]
            let width = data.calTextWidth(font: segmentedConfig.titleFont)
            let size = CGSize(width: width, height: height)
            let model = SegmentItemModel(text: data.text, size:size , index: i)
            itemModels.append(model)
            width_sum += width;
            
        }
        let x_sum = segmentedConfig.trail_w + segmentedConfig.space_w*CGFloat(dataArray.count) + segmentedConfig.chief_w + width_sum;
      
        if x_sum <= self.frame.size.width{
            
            let space = (self.frame.size.width - width_sum - segmentedConfig.trail_w - segmentedConfig.chief_w)/CGFloat(dataArray.count-1)
            layout = .fixation(space: space)
            
        }else{
            layout = .scroll
        }
        
        
    }
    private func setupItem() {
        
        
        if dataArray.count==0 {
            return;
        }
    
        var x_lable:CGFloat = 0.0
        
        x_lable += segmentedConfig.chief_w
    
        var  curr_space : CGFloat = 0.0
        switch layout {
            
        case .fixation(let space):
            curr_space = space
            break
        case .scroll:
            curr_space = segmentedConfig.space_w
            break
        }
        for model in itemModels {
           
           
            let frame = CGRect(x: x_lable, y: (self.frame.height-model.size.height)/2.0, width: model.size.width, height: model.size.height)
            let item = SegmentedItem(model: model, frame: frame)
            self.scorllView.addSubview(item)
            
            x_lable += model.size.width
            if model.index != itemModels.count-1{
                x_lable += curr_space
            }
            item.titleLabel.font = segmentedConfig.titleFont
            
            item.itemSelectedColor = segmentedConfig.itemSelectedColor
            item.itemDefultColor = segmentedConfig.itemDefultColor
            item.segmentedItemSelected = {(itemModel) in
          
                self.selectIndex(index: itemModel.index)
                
            }
            self.labelArray.append(item)
            

        
       }
        x_lable += segmentedConfig.trail_w
        scorllView.contentSize = CGSize(width: x_lable, height: self.frame.size.height)
    }
    
    public func selectIndex(index:Int){
        
        if !(dataArray.count > index) {
            return
        }
        let item = self.labelArray[index];
        let itemModel = itemModels[index];
        
        self.currentItem?.isSelected = false
        self.currentItem = item
        item.isSelected = true
        
        
        var offset:CGFloat = 0.0;
        
        let contentWidth:CGFloat = self.scorllView.contentSize.width;
        
        let halfWidth:CGFloat = self.frame.width/2.0;
        
        if (item.frame.midX < halfWidth) {
            offset = 0;
        }else if (item.frame.midX > contentWidth - halfWidth){
            offset = contentWidth - 2 * halfWidth;
        }else{
            offset = item.frame.midX - halfWidth;
        }
        
        if(self.lineView.frame != CGRect.zero){
            UIView.animate(withDuration: 0.2, animations: {
                self.lineView.frame = CGRect(x: item.frame.minX, y: self.frame.height-self.lineHeight, width: itemModel.size.width, height: self.lineHeight)
                self.scorllView.setContentOffset(CGPoint(x: offset , y: 0), animated: false);
            })
            
            
        }else{
            self.lineView.frame = CGRect(x: item.frame.minX, y: self.frame.height-1, width: itemModel.size.width, height: 1)
            self.scorllView.setContentOffset(CGPoint(x: offset , y: 0), animated: false);
        }
        self.segmentedItemSelected?(itemModel)
    }
    
    
    
    func reloadData(titleData:[SegmentedControlDateSource]){
        
        removeSegment()
        
        dataArray = titleData
        
        configDataModel()
        
        setupItem()
        
        selectIndex(index: 0)
    }
    
    
    
    func updateView(){
        
        if dataArray.count == 0 {
            return;
        }
        itemModels.removeAll()
        configDataModel()
        var x_lable:CGFloat = 0.0
        
        x_lable += segmentedConfig.chief_w
        
        var  curr_space : CGFloat = 0.0
        switch layout {
            
        case .fixation(let space):
            curr_space = space
            break
        case .scroll:
            curr_space = segmentedConfig.space_w
            break
        }
        for i in 0...dataArray.count-1{
            let model = itemModels[i]
            let lable = labelArray[i]
            
            let frame = CGRect(x: x_lable, y: (self.frame.height-model.size.height)/2.0, width: model.size.width, height: model.size.height)
            
            lable.titleLabel.font = segmentedConfig.titleFont
            lable.itemModel = model
            lable.itemSelectedColor = segmentedConfig.itemSelectedColor
            lable.itemDefultColor = segmentedConfig.itemDefultColor
            lable.frame = frame
            x_lable += model.size.width
            if model.index != itemModels.count-1{
                x_lable += curr_space
            }
            if(lable.isSelected){
                 self.lineView.frame = CGRect(x: lable.frame.minX, y: self.frame.height-lineHeight, width: model.size.width, height: lineHeight)
            }
        }
        x_lable += segmentedConfig.trail_w
        scorllView.contentSize = CGSize(width: x_lable, height: self.frame.size.height)
    }
}
