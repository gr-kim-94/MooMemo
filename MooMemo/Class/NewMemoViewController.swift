//
//  NewMemoViewController.swift
//  MooMemo
//
//  Created by 김가람 on 2021/06/02.
//

import UIKit

class NewMemoViewController: UIViewController {
    var willShowToken: NSObjectProtocol?
    var willHideToken: NSObjectProtocol?
    
    var editTarget: Memo?
    var originalMemoContent: String?
    
    
    @IBOutlet weak var memoTextView: UITextView!
    
    deinit {
        if let token = willShowToken {
            NotificationCenter.default.removeObserver(token)
        }
        if let token = willHideToken {
            NotificationCenter.default.removeObserver(token)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let memo = editTarget {
            navigationItem.title = "메모 편집"
            memoTextView.text = memo.content
            originalMemoContent = memo.content
        }
        else {
            navigationItem.title = "새 메모"
            memoTextView.text = ""
            originalMemoContent = ""
        }
        
        memoTextView.delegate = self
        
        willShowToken = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: OperationQueue.main, using: { [weak self] (noti) in
            guard let strongSelf = self else {
                return
            }
            
            if let frame = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let height = frame.cgRectValue.height
                
                var inset = strongSelf.memoTextView.contentInset
                inset.bottom = height
                strongSelf.memoTextView.contentInset = inset
                
                inset = strongSelf.memoTextView.scrollIndicatorInsets
                inset.bottom = height
                strongSelf.memoTextView.scrollIndicatorInsets = inset
            }
        })
        
        willHideToken = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: OperationQueue.main, using: { [weak self] (noti) in
            guard let strongSelf = self else {
                return
            }
            
            var inset = strongSelf.memoTextView.contentInset
            inset.bottom = 0
            strongSelf.memoTextView.contentInset = inset
            
            inset = strongSelf.memoTextView.scrollIndicatorInsets
            inset.bottom = 0
            strongSelf.memoTextView.scrollIndicatorInsets = inset
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        memoTextView.becomeFirstResponder()
        
        navigationController?.presentationController?.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        memoTextView.resignFirstResponder()
        
        navigationController?.presentationController?.delegate = nil
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func save(_ sender: Any) {
        guard let memo = memoTextView.text, memo.count > 0 else {
            alert(message: "메모를 입력하세요.")
            return
        }
        
        if editTarget != nil {
            // 메모편집
            editTarget?.content = memo
            DataManager.shared.saveContext()
            NotificationCenter.default.post(name: NewMemoViewController.editMemoNoti, object: nil)
        }
        else {
            // 새메모
            DataManager.shared.addNewMemo(memo)
            NotificationCenter.default.post(name: NewMemoViewController.newMemoNoti, object: nil)
        }
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension NewMemoViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        let alert = UIAlertController(title: "알림", message: "변경 내용을 저장할까요?", preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "확인", style: .default, handler: { [weak self] (action) in
            self?.save(action)
        }))
        alert.addAction(UIAlertAction.init(title: "취소", style: .cancel, handler: { [weak self] (action) in
            self?.close(action)
        }))
        
        present(alert, animated: true, completion: nil)
    }
}

extension NewMemoViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if let original = originalMemoContent, let edited = textView.text {
            // isModalInPresentation : modal 방식으로 작동해야하는지에대한 플래그
            if #available(iOS 13.0, *) {
                isModalInPresentation = original != edited
            } else {
                // Fallback on earlier versions
            }
        }
    }
}

extension NewMemoViewController {
    static let newMemoNoti = Notification.Name(rawValue: "newMemoNoti")
    static let editMemoNoti = Notification.Name(rawValue: "editMemoNoti")
}
