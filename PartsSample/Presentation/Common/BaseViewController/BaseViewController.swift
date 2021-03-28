//
//  BaseViewController.swift
//  PartsSample
//

import UIKit

class BaseViewController: UIViewController {
    
    // MARK: - private properties

    // アラートのFIFO表示キュー
    let alertPresentationQueue = OperationQueue()
    
    // MARK: - lifecycle
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // 未表示のアラートは消去
        cancelAllAlert()
    }
    
    // MARK: - internal methods
    
    /// アラート表示。表示順はFIFO
    /// - Parameter presented: アラート（ViewController）
    func showAlert(presented: CustomAlertViewController) {

        let newOperation = BlockOperation {
            let semaphore = DispatchSemaphore(value: 0)

            // アラートを閉じたタイミングでOperationを終了する
            presented.dismissCompletion = {
                semaphore.signal()
            }
            
            // アラートを表示する
            OperationQueue.main.addOperation{
                self.present(presented, animated: true)
            }
            
            semaphore.wait()
        }
        newOperation.queuePriority = .veryHigh
        
        // キューの一番最後のアラート表示処理の後に、アラートを表示するように依存関係を設定
        if let lastOperation = alertPresentationQueue.operations.last {
            newOperation.addDependency(lastOperation)
        }
        //  アラート表示処理をキューに追加
        alertPresentationQueue.addOperation(newOperation)
    }
    
    /// アラートのFIFO表示キューを全てキャンセル
    func cancelAllAlert() {
        alertPresentationQueue.cancelAllOperations()
    }
}
