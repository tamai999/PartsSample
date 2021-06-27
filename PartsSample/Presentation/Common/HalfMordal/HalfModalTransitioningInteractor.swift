//
//  HalfModalTransitioningInteractor.swift
//  PartsSample
//

import UIKit

/// ハーフモーダルの下スワイプのインタラクションの制御を行う
class HalfModalTransitioningInteractor: UIPercentDrivenInteractiveTransition {
    
    /// インタラクションの状態
    enum State {
        /// インタラクションを開始していない。
        case notInProgress
        /// インタラクション開始。
        case startInteraction
        /// インタラクション中
        case inProgress
        /// クローズする（手を離しても引っ込む状態）
        case shouldClose
    }
    
    
    // MARK: - internal properties
    
    var state: State = .notInProgress
    var closeHandler: (() -> Void)?
    var resetHandler: (() -> Void)?
    
    override func cancel() {
        completionSpeed = percentComplete
        super.cancel()
    }
    
    override func finish() {
        completionSpeed = 1.0 - percentComplete
        super.finish()
    }
    
    /// インタラクションが開始されていなければ状態を`notInProgress`に変更
    func updateStateShouldStartIfNeeded() {
        switch state {
        case .notInProgress:
            // インタラクションを開始していないので開始する
            state = .startInteraction
            closeHandler?()
        case .startInteraction, .inProgress, .shouldClose:
            break
        }
    }
    
    func reset() {
        state = .notInProgress
        resetHandler?()
    }
}
