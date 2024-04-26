//
//  PostModel.swift
//  IOSTest_Arpit
//
//  Created by Ravi Chokshi on 25/04/24.
//

import Foundation
import RealmSwift


// MARK: - Post
class Post: Object, Codable {
    @Persisted  (primaryKey: true)var id: Int
    @Persisted var userID: Int
    @Persisted  var title: String
    @Persisted  var body: String

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, body
    }
    
    override init() {
        super.init()
    }
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self._userID = try container.decode(Persisted<Int>.self, forKey: .userID)
        self._id = try container.decode(Persisted<Int>.self, forKey: .id)
        self._title = try container.decode(Persisted<String>.self, forKey: .title)
        self._body = try container.decode(Persisted<String>.self, forKey: .body)
    }
}

typealias Posts = [Post]
