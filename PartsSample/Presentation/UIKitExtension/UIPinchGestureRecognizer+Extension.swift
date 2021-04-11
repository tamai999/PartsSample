//
//  UIPinchGestureRecognizer+Extension.swift
//  PartsSample
//

import UIKit

extension UIPinchGestureRecognizer {
    enum ZoomStatus {
        case zoomIn, zoomOut
    }

    var zoomStatus: ZoomStatus {
        return scale > 1.0 ? .zoomIn : .zoomOut
    }
    
    func transitionProgress(zoomStatus: ZoomStatus) -> CGFloat {
        var progress: CGFloat = 0.0
        
        switch (zoomStatus) {
        case .zoomIn:
            // 拡大中 scaleの1.0〜2.0 -> 0.0〜1.0
            progress = scale - 1.0
        case .zoomOut:
            // 縮小中 scaleの1.0〜0.5 -> 0.0〜1.0
            progress = (1.0 - scale) * 2.0
        }
        // clamp
        return min(max(progress, 0.0), 1.0)
    }
}
