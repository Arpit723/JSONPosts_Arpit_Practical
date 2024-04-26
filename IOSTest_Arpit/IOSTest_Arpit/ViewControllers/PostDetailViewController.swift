//
//  PostDetailViewController.swift
//  IOSTest_Arpit
//
//  Created by Ravi Chokshi on 25/04/24.
//

import UIKit

class PostDetailViewController: UIViewController {

    var postDetail: Post?
    @IBOutlet weak var lblUserId: UILabel!
    
    @IBOutlet weak var lblBody: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblId: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Post Detail"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        // Do any additional setup after loading the view.
        loadData()
    }

    func loadData() {
        lblId.text = String(postDetail?.id ?? 0)
        lblUserId.text = String(postDetail?.userID ?? 0)
        lblTitle.text = String(postDetail?.title ?? "")
        lblBody.text = String(postDetail?.body ?? "")
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
