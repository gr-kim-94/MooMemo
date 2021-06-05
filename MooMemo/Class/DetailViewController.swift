//
//  DetailViewController.swift
//  MooMemo
//
//  Created by 김가람 on 2021/06/02.
//

import UIKit

class DetailViewController: UIViewController {
    
    var memo: Memo?
    
    let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .long
        f.timeStyle = .short
        f.locale = Locale(identifier: "Ko_kr")
        return f
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
