//
//  Book.swift
//  Storia
//
//  Created by Lily Bhattacharjee on 1/21/19.
//  Copyright © 2019 Lily Bhattacharjee. All rights reserved.
//

import Foundation

class Book {
    
    private var name: String!
    private var author: String!
    private var isbn: String!
    private var imgUrl: String!
    
    init(name: String, author: String, isbn: String, imgUrl: String) {
        self.name = name
        self.author = author
        self.isbn = isbn
        self.imgUrl = imgUrl
    }
    
    // getter methods
    public func getName() -> String {
        return self.name
    }
    
    public func getAuthor() -> String {
        return self.author
    }
    
    public func getIsbn() -> String {
        return self.isbn
    }
    
    public func getImgUrl() -> String {
        return self.imgUrl
    }
}
