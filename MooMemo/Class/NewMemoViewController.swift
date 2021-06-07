//
//  NewMemoViewController.swift
//  MooMemo
//
//  Created by 김가람 on 2021/06/02.
//

import UIKit

class NewMemoViewController: UIViewController {

    var editTarget: Memo?
    
    @IBOutlet weak var memoTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let memo = editTarget {
            navigationItem.title = "메모 편집"
            memoTextView.text = memo.content
        }
        else {
            navigationItem.title = "새 메모"
            memoTextView.text = ""
        }
        
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
            NotificationCenter.default.post(name: NewMemoViewController.editMemoDidChageNoti, object: nil)
        }
        else {
            // 새메모
            DataManager.shared.addNewMemo(memo)
            NotificationCenter.default.post(name: NewMemoViewController.newMemoDidInsertNoti, object: nil)
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

extension NewMemoViewController {
    static let newMemoDidInsertNoti = Notification.Name(rawValue: "newMemoDidInsertNoti")
    static let editMemoDidChageNoti = Notification.Name(rawValue: "editMemoDidChageNoti")
}
