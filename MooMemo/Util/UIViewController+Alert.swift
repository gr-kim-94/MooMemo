//
//  UIViewController+Alert.swift
//  MooMemo
//
//  Created by 김가람 on 2021/06/02.
//

import UIKit

extension UIViewController {
    func alert(title: String = "알림", message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "확인", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
