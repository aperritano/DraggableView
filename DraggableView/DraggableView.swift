//
//  DraggableView.swift
//  PrototypeGesture
//
//  Created by Anthony Perritano on 5/27/16.
//  Copyright © 2016 Mark Angelo Noquera. All rights reserved.
//

import Foundation
import UIKit

protocol DraggableViewDelegate {
    func onDropedToTarget(sender: DraggableView, target: UIView)
}

class DraggableView: UIImageView {
    
    var copiedDraggableView : DraggableView?
    var dropTarget : UIView?
    var hasEnterDroppedZone = false
    var hasLeftDroppedZone = false

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(DraggableView.responseToPanGesture(_:)))
        self.userInteractionEnabled = true
        self.addGestureRecognizer(panGesture)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func responseToPanGesture(sender: UIPanGestureRecognizer){

        if sender.state == UIGestureRecognizerState.Began {
            
            copiedDraggableView = DraggableView(frame: self.frame)
            copiedDraggableView!.userInteractionEnabled = true
            copiedDraggableView!.autoresizingMask = UIViewAutoresizing.None
            copiedDraggableView!.contentMode = UIViewContentMode.Center
            copiedDraggableView!.layer.cornerRadius = 5.0
            copiedDraggableView!.layer.borderWidth = 1.0
            copiedDraggableView!.clipsToBounds = true
            copiedDraggableView!.addSubview(UIImageView(image: scaledImageToSize(self.image!, newSize: self.bounds.size)))
            
            self.superview?.addSubview(copiedDraggableView!)
            
            animateView(copiedDraggableView!, sender: sender, scale: 1.3, alpha: 0.6, duration: 0.3)
        } else if sender.state == UIGestureRecognizerState.Changed {
                
                let translation = sender.translationInView(copiedDraggableView!.superview!)
                copiedDraggableView!.center = CGPointMake(copiedDraggableView!.center.x + translation.x, copiedDraggableView!.center.y + translation.y)
                sender.setTranslation(CGPointZero, inView: copiedDraggableView!.superview)
                
                if dropTarget != nil {
                    checkIfEnterDropTarget(sender)
                    checkIfLeavingDropTarget(sender)

                }
            }
            if sender.state == UIGestureRecognizerState.Ended{
                
                
            }
        }
    
    private func scaledImageToSize(image: UIImage, newSize: CGSize) -> UIImage{
        UIGraphicsBeginImageContext(newSize)
        image.drawInRect(CGRectMake(0 ,0, newSize.width, newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext()
        return newImage
    }
    
    private func checkIfEnterDropTarget(sender:UIGestureRecognizer) -> Bool{
        let location = sender.locationInView(copiedDraggableView!.superview)
        if CGRectContainsPoint(dropTarget!.frame, location)
        {
            animateView(dropTarget!, sender: sender, scale: 1.5, alpha: 0.6, duration: 0.3)
            hasEnterDroppedZone = true
        }
        else{
            if hasEnterDroppedZone {
                hasLeftDroppedZone = true
            }
        }
        return hasEnterDroppedZone
    }
    
    private func checkIfLeavingDropTarget(sender:UIGestureRecognizer){
        if hasEnterDroppedZone && hasLeftDroppedZone{
            animateView(copiedDraggableView!, sender: sender, scale: 1.0, alpha: 1.0, duration: 0.3)

            animateView(dropTarget!, sender: sender, scale: 1.0, alpha: 1.0, duration: 0.3)
            hasEnterDroppedZone = false
            hasLeftDroppedZone = false
        }
        
    }
}


extension DraggableView : DraggableViewDelegate {
    func onDropedToTarget(sender: DraggableView, target: UIView) {
        //
    }
    
    //MARK: animation
    
    private func animateView(view:UIView, sender: UIGestureRecognizer, scale:CGFloat = 1.3, alpha:CGFloat = 0.5,duration:NSTimeInterval = 0.2){
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(duration)
        view.transform = CGAffineTransformMakeScale(scale, scale)
        view.alpha = alpha
        UIView.commitAnimations()
    }
}
