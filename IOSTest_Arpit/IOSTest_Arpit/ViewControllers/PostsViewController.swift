//
//  ViewController.swift
//  IOSTest_Arpit
//
//  Created by Ravi Chokshi on 25/04/24.
//

import UIKit

/* Algorithm
 
    1. First time start the app/ Genral call api and fetch data
       1.1 Initilise start and end
       1.2 Call 'WebService' for get posts
       1.3 Store the Posts in 'Databse'
       1.4 Show the data from 'Databse' to UI

    2. When Second time app opens
        2.1 Fetch the Posts from Databse
        2.2 Posts are found mostly
        2.3 Show the Posts from Database
 
    3. Pagination
       - After load the Post from Databse initllay
       - Comnpute next start and end date
       - Call WebService to get posts, Store in databse
       - Update UI from Databse

 */


class PostsViewController: UIViewController {
    
    static var fetchInProgress = false
    @IBOutlet weak var tableViewPosts: UITableView!
    private let postsViewModel = PostsViewModel()
    let refreshControl = UIRefreshControl()
    
//MARK: View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Posts"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        setUPTableView()
//            let posts =  RealmDBManager.shared.getObjectsFromDatabse()
//            if posts.count == 0 {
                refresh()
//            } else {
//                self.postsViewModel.postsArray = posts
//                self.postsViewModel.computeExistingStartAndEnd()
//                self.updateUI(posts: posts)
//            }
    }
    
    func setUPTableView() {
        tableViewPosts.estimatedRowHeight = 100.0
        // Do any additional setup after loading the view.
        tableViewPosts.register(UINib(nibName: "PostTableViewCell", bundle: nil), forCellReuseIdentifier: "PostTableViewCell")
        //#Pagination
        tableViewPosts.register(UINib(nibName: "LoadingTableViewCell", bundle: nil), forCellReuseIdentifier: "LoadingTableViewCell")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableViewPosts.addSubview(refreshControl)
    }
    
}

//MARK: API Call
extension PostsViewController {
    
    
    @objc func refresh() {
        //#Pagination
        let (start, end) = self.postsViewModel.inititaliseStartAndEnd()
        self.apiCallToGetPosts(start: start, end:end)
    }
    
    func apiCallToGetPosts(start: Int, end: Int) {
        postsViewModel.getPosts(pageStart: start, pageEnds: end, completion: { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else {
                    return
                }
                PostsViewController.fetchInProgress = false
                switch result {
                case .success(let posts):
                    self.refreshControl.endRefreshing()
                    self.updateUI(posts: posts)
                case .failure(let error):
                    print("Error:\(error.localizedDescription)")
                }
            }
            
        })
    }
    
    func updateUI(posts: [Post]) {
        print("Posts count \(posts.count)")
        //#Pagination
        let loadingCell = tableViewPosts.cellForRow(at: IndexPath(row: self.postsViewModel.postsArray.count, section: 0)) as? LoadingTableViewCell
        loadingCell?.activityIndicator.stopAnimating()
        tableViewPosts.reloadData()
    }
}


//MARK: Table View Delegate and Data Source
extension PostsViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.postsViewModel.shouldLoadMoreData ? self.postsViewModel.postsArray.count + 1 : self.postsViewModel.postsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < self.postsViewModel.postsArray.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath) as! PostTableViewCell
            let post = self.postsViewModel.postsArray[indexPath.row]
            cell.lblId.text = String(post.id)
            cell.lblTitle.text = post.title
            return cell
        } else {
            //#Pagination
            let cell = tableView.dequeueReusableCell(withIdentifier: "LoadingTableViewCell", for: indexPath) as! LoadingTableViewCell
            cell.activityIndicator.startAnimating()
            self.fetchMoreData()
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PostDetailViewController") as! PostDetailViewController
        vc.postDetail = self.postsViewModel.postsArray[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: Load more data
    func fetchMoreData() {
        if PostsViewController.fetchInProgress {
            return
        }
        PostsViewController.fetchInProgress = true
        //#Pagination
        let (start, end) = self.postsViewModel.computeNextStartAndEnd()
        self.apiCallToGetPosts(start: start, end: end)
    }
}
