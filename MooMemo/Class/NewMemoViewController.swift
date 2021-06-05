//
//  NewMemoViewController.swift
//  MooMemo
//
//  Created by 김가람 on 2021/06/02.
//

import UIKit

class NewMemoViewController: UIViewController {

    @IBOutlet weak var memoTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func save(_ sender: Any) {
        guard let memo = memoTextView.text, memo.count > 0 else {
            alert(message: "메모를 입력하세요.")
            return
        }
        
        DataManager.shared.addNewMemo(memo)
        
        NotificationCenter.default.post(name: NewMemoViewController.newMemoDidInsertNoti, object: nil)
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
}
