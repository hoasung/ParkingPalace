//
//  MarkerInfo.swift
//  CarPark1
//
//  Created by thonv on 05/19/17.
//  Copyright © 2017 thonv. All rights reserved.
//

import UIKit

class MarkerInfoView: UIView {

    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var placeAddr: UILabel!
    @IBOutlet weak var placePhoto: UIImageView!
    @IBOutlet weak var placeRemain: UILabel!
    @IBOutlet weak var placePrice: UILabel!
    
//    @IBOutlet weak var placeName: UILabel!
//    @IBOutlet weak var placePhoto: UIImageView!
//    @IBInspectable var image: UIImage? {
//        get {
//            return placePhoto.image
//        }
//        set(image) {
//            placePhoto.image = image
//        }
//    }
    
    
//    @IBOutlet weak var placeAddr: UILabel!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    func instanceFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "MarkerInfo", bundle: bundle)
        
        let arr = nib.instantiate(withOwner: self, options: nil)
        let view = arr.first as! UIView
        return view
        
        //return UINib(nibName: "MarkerInfo", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MarkerInfo
    }
    
    func xibSetup() {
        let view = instanceFromNib()
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        view.backgroundColor = UIColor.clear
        // Make the view stretch with containing view
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //let view = instanceFromNib()
        //addSubview(view)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //let view = instanceFromNib()
//        addSubview(view)
        xibSetup()
    }
    
    
    func display(marker: MarkerPlace){
        placeName.text = marker.placeName
        placeAddr.text = marker.placeAddress
        placePrice.text = "15.000 Đ"
        placeRemain.text = String(marker.remain) + "/" + String(marker.capacity)
        
        
        isHidden = false
        
    }
    

}
