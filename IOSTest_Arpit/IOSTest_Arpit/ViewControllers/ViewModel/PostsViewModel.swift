//
//  PostsViewModel.swift
//  IOSTest_Arpit
//
//  Created by Ravi Chokshi on 25/04/24.
//

import Foundation

class PostsViewModel {
    
    var postsArray = [Post]()
    // To determinae that there is no more data from web service
    var shouldLoadMoreData = true
    private var start = 0
    private var end = 10
    private var pageSize = 10

    //MARK: API Call
    func getPosts(pageStart: Int, pageEnds: Int,completion: @escaping (Result<Posts, Error>) -> Void) {
        let endpoint = ServerParam.baseURL + "Posts" + "?_start=" + "\(pageStart)" + "&_end=" + "\(pageEnds)"
        APIManager.shared.request(endpoint: endpoint, method: "GET", parameters: nil) { [weak self] (result: Result<Posts, Error>) in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let posts):
                if posts.count == 0 {
                    self.shouldLoadMoreData = false
                } else {
                    self.shouldLoadMoreData = true
                }
                if pageStart == 0 {
                    self.postsArray = posts

//                    RealmDBManager.shared.deleteObjectsFromDatabse()
//                    RealmDBManager.shared.addObjectsToDatabse(data: posts)
                } else {
                    self.postsArray += posts
//                    RealmDBManager.shared.addObjectsToDatabse(data: posts)
                }
//                self.postsArray =  RealmDBManager.shared.getObjectsFromDatabse()
                self.computeExistingStartAndEnd()
                completion(.success(posts))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}

//MARK: Pagination
extension PostsViewModel {

    func inititaliseStartAndEnd()  -> (Int, Int) {
        print(#function)
        self.start = 0
        self.end = pageSize
        print("start \(start) end \(end)")
        return (start,end)
    }
    func computeExistingStartAndEnd() {
        print(#function)
        self.start = self.postsArray.count == 0 ? 0 : self.postsArray.count - pageSize
        self.end = self.postsArray.count
        print("start \(start) end \(end)")
    }
    
    func computeNextStartAndEnd() -> (Int, Int){
        print(#function)
        self.start += pageSize
        self.end += pageSize
        print("start \(start) end \(end)")
        return (start,end)
    }
}


