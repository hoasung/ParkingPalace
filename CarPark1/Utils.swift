//
//  Utils.swift
//  FindNumber
//
//  Created by thonv on 03/16/17.
//  Copyright © 2017 thonv. All rights reserved.
//

import Foundation
import UIKit

import AVFoundation
public class Utils{
    static let me:Utils=Utils()
    let letters : [Character] = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat{
        
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * CGFloat(abs(min - max)) + min
        
    }
    func random(min: Int, max: Int) -> Int{
        if min >= max {
            return min
        }
        
        return Int(CGFloat(arc4random()) / CGFloat(UINT32_MAX) * CGFloat(max - min)) + min
        
    }
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    func  isNumber(str: String) -> Int?{
        return Int(str)
    }
    func random(upperBound: Int) -> Int{
        return Int(arc4random_uniform(UInt32(upperBound)))
    }
    func randomChar() -> Character{
        //let len = UInt32(letters.length)
        let rand = random(upperBound: letters.count)
        let nextChar = letters[rand]
        
        return nextChar
    }
    
    
    
    func getDateFromString(date: String?) -> NSDate? {
        if let date1 = date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
            dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
            let date: NSDate? = dateFormatter.date(from: date1) as NSDate?
            return date!
        }
        return nil
    }
    func date2String(_ date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        let string = dateFormatter.string(from: date)
        return string
    }
    func maskRoundedImage(image: UIImage, radius: Float, width: Int) -> UIImage {
        let imageView: UIImageView = UIImageView(image: image)
        //imageView.frame.size = CGSize(width: width, height: width)
        var layer: CALayer = CALayer()
        layer = imageView.layer
        imageView.contentMode = .scaleAspectFill
        
        layer.masksToBounds = true
        layer.cornerRadius = CGFloat(radius)
        
        UIGraphicsBeginImageContext(imageView.bounds.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return roundedImage!
    }
    func swap<T>(_ a: inout T, _ b: inout T){
        let tmp = a
        a = b
        b = tmp
    }
    func distance(x1: Double, y1: Double, x2: Double, y2: Double) -> Double{
        let deltaX = (x1 - x2)*(x1 - x2)
        let deltaY = (y1 - y2)*(y1 - y2)
        let d = sqrt(deltaX + deltaY)
        return d
    }
    

    func convert2Unsign(s: String) -> String{
        var sReturn = s
        let vnChar = ["aAeEoOuUiIdDyY",
                      "áàạảãâấầậẩẫăắằặẳẵ",
                      "ÁÀẠẢÃÂẤẦẬẨẪĂẮẰẶẲẴ",
                      "éèẹẻẽêếềệểễ",
                      "ÉÈẸẺẼÊẾỀỆỂỄ",
                      "óòọỏõôốồộổỗơớờợởỡ",
                      "ÓÒỌỎÕÔỐỒỘỔỖƠỚỜỢỞỠ",
                      "úùụủũưứừựửữ",
                      "ÚÙỤỦŨƯỨỪỰỬỮ",
                      "íìịỉĩ",
                      "ÍÌỊỈĨ",
                      "đ",
                      "Đ",
                      "ýỳỵỷỹ",
                      "ÝỲỴỶỸ"]
        for i in 1..<vnChar.count{
            for j in 0..<vnChar[i].characters.count{
                //print("ij: \(i)_\(j): \(vnChar[i][j] as String) ++ \(vnChar[0][i-1] as String) ")
                sReturn = sReturn.replacingOccurrences(of: vnChar[i][j], with: vnChar[0][i-1])
                //print("sReturn: \(sReturn)")
            }
        }
        
        return sReturn
    }
    //MARK:- PLAY SOUND
    func playSound(file: String, loops: Int) {
        let url = Bundle.main.url(forResource: file, withExtension: "mp3")!
        
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            //guard let player = player1 else { return }
            player.numberOfLoops = loops
            player.prepareToPlay()
            player.play()
            
        } catch let error as NSError {
            print(error.description)
        }
    }
    func shadown(_ view: UIView){
        
        let shadowPath = UIBezierPath(roundedRect: view.bounds, cornerRadius: 10).cgPath
        view.layer.shadowColor = UIColor.black.cgColor
        //mImage.layer.masksToBounds = false
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 10
        view.layer.shadowPath = shadowPath
        view.clipsToBounds = false
        view.layer.cornerRadius = 10
        
    }
}
