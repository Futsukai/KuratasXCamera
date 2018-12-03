//
//  KuratasXFaceDetector.swift
//  KuratasXCamera
//
//  Created by zhangwei on 2018/12/1.
//  Copyright © 2018年 Kuratasx. All rights reserved.
//

import UIKit

class KuratasXFaceDetector: NSObject {
    
    class func beginDetectorFace(image:UIImage,inFrame:CGRect) -> UIImage {
        
        let ciimage = CIImage(cgImage: remark(image: image, to: inFrame.size).cgImage!)
        let detector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: [CIDetectorAccuracy : CIDetectorAccuracyHigh])
        let features = detector?.features(in: ciimage) as! [CIFaceFeature]
        UIGraphicsBeginImageContextWithOptions(ciimage.extent.size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        image.draw(in: CGRect(origin: CGPoint.zero, size: ciimage.extent.size))
        
        var transform = CGAffineTransform.identity
        transform = transform.scaledBy(x: 1.0, y: -1.0)
        transform = transform.translatedBy(x: 0.0, y: -ciimage.extent.size.height)
        
        for face in features {
            UIColor.yellow.setFill()
            if face.hasLeftEyePosition{
                context?.addRect(CGRect(origin: face.leftEyePosition.applying(transform), size: CGSize(width: 10, height: 10)))
            }
            if face.hasRightEyePosition{
                context?.addRect(CGRect(origin: face.rightEyePosition.applying(transform), size: CGSize(width: 10, height: 10)))
            }
            if face.hasMouthPosition{
                context?.addRect(CGRect(origin: face.mouthPosition.applying(transform), size: CGSize(width: 10, height: 10)))
            }
            context?.setAlpha(0.5)
            context?.fillPath()
        }
        let new = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return new!
        //        return remark(image: new!, to: inFrame.size)
    }
    
    class func remark(image:UIImage,to:CGSize) -> UIImage {
        let factor = to.width/image.size.width
        let rect = CGRect(origin: CGPoint.zero, size: CGSize(width: image.size.width * factor, height: image.size.height * factor))
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.addEllipse(in: rect)
        context?.clip()
        image.draw(in: rect)
        let reSizeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return reSizeImage!
    }
    
}
