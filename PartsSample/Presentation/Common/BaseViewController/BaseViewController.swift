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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // フォアグラウンドへの移行を監視
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(willEnterForeground),
                                       name: UIApplication.willEnterForegroundNotification,
                                       object: nil)
    }
    
    @objc
    func willEnterForeground() {
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 監視を解除
        NotificationCenter.default.removeObserver(self)
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
