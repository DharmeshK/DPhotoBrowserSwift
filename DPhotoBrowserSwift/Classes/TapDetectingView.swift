//
//  TapDetectingView.swift
//  DPhotoBrowserSwift
//
//  Created by DK on 30/05/21.
//  Original obj-c created by Michael Waterfall 2013
//
//

import Foundation
import UIKit

public class TapDetectingView: UIView {
    public weak var tapDelegate: TapDetectingViewDelegate?
    
    public init() {
        super.init(frame: CGRect.zero)
        isUserInteractionEnabled = true
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first  {
            let tapCount = touch.tapCount
        
            switch tapCount {
            case 1: handleSingleTap(touch: touch)
            case 2: handleDoubleTap(touch: touch)
            case 3: handleTripleTap(touch: touch)
                default: break
            }
        }
        
        if let nr = next {
            nr.touchesEnded(touches, with: event)
        }
    }

    private func handleSingleTap(touch: UITouch) {
        if let td = tapDelegate {
            td.singleTapDetectedInView(view: self, touch: touch)
        }
    }

    private func handleDoubleTap(touch: UITouch) {
        if let td = tapDelegate {
            td.doubleTapDetectedInView(view: self, touch: touch)
        }
    }

    private func handleTripleTap(touch: UITouch) {
        if let td = tapDelegate {
            td.tripleTapDetectedInView(view: self, touch: touch)
        }
    }
}

public protocol TapDetectingViewDelegate: AnyObject {
    func singleTapDetectedInView(view: UIView, touch: UITouch)
    func doubleTapDetectedInView(view: UIView, touch: UITouch)
    func tripleTapDetectedInView(view: UIView, touch: UITouch)
}
