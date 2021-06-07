//
//  DetailViewController.swift
//  MooMemo
//
//  Created by 김가람 on 2021/06/02.
//

import UIKit

class DetailViewController: UIViewController {
    var token: NSObjectProtocol?
    
    var memo: Memo?
    
    @IBOutlet weak var tableView: UITableView!
    
    let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .long
        f.timeStyle = .short
        f.locale = Locale(identifier: "Ko_kr")
        return f
    }()
    
    deinit {
        if let token = token {
            NotificationCenter.default.removeObserver(token)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination.children.first as? NewMemoViewController {
            vc.editTarget = memo
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        token = NotificationCenter.default.addObserver(forName: NewMemoViewController.editMemoNoti, object: nil, queue: OperationQueue.main) { [weak self] (noti) in
            self?.tableView.reloadData()
        }
    }
    
    @IBAction func deleteMemo(_ sender: Any) {
        let alert = UIAlertController(title: "삭제 확인", message: "메모를 삭제할까요?", preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "확인", style: .default, handler: { [weak self] (action) in
            DataManager.shared.deleteMemo(self?.memo)
            NotificationCenter.default.post(name: DetailViewController.deleteMemoNoti, object: nil)
            self?.navigationController?.popViewController(animated: true)
        }))
        alert.addAction(UIAlertAction.init(title: "취소", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func shareMemo(_ sender: UIBarButtonItem) {
        guard let memo = memo?.content else {
            return
        }
        
        let vc = UIActivityViewController(activityItems: [memo], applicationActivities: nil)        
        if let pc = vc.popoverPresentationController {
            pc.barButtonItem = sender
        }
        present(vc, animated: true, completion: nil)
    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            // Memo
            let cell = tableView.dequeueReusableCell(withIdentifier: "MemoCell", for: indexPath)
            cell.textLabel?.text = memo?.content
            return cell;
        case 1:
            // Date
            let cell = tableView.dequeueReusableCell(withIdentifier: "DateCell", for: indexPath)
            // string(from: Date) 는 옵셔널 사용 불가 -> 옵셔널 바인딩을 사용하거나 string(for: Any?) 사용
            // memo가 현재 옵셔널이므로 string(for: Any?) 사용
            cell.textLabel?.text = formatter.string(for: memo?.insertDate)
            return cell;
        default:
            fatalError()
        }
    }
    
    
}

extension DetailViewController {
    static let deleteMemoNoti = Notification.Name(rawValue: "deleteMemoNoti")
}
