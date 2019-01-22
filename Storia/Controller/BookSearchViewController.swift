//
//  BookSearchViewController.swift
//  Storia
//
//  Created by Lily Bhattacharjee on 1/21/19.
//  Copyright © 2019 Lily Bhattacharjee. All rights reserved.
//

import UIKit
import Alamofire

class BookSearchViewController: ViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, XMLParserDelegate {

    @IBOutlet var goBack: UIButton!
    @IBOutlet var bookSearchTitle: UILabel!
    @IBOutlet var bookSearchBar: UISearchBar!
    @IBOutlet var searchResults: UITableView!
    
    private var bookResults: [Book] = []
    
    private var eName: String = String()
    private var bookTitle = String()
    private var bookAuthor = String()
    private var bookIsbn = String()
    private var bookImgUrl = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        goBack.setBackgroundImage(UIImage(named: "back-icon.png"), for: .normal)
        goBack.setTitle("", for: .normal)
        
        bookSearchTitle.text = "Search Books"
        bookSearchTitle.font = FontScheme.gillsansFont(size: 50)
        
        bookSearchBar.delegate = self
        
        searchResults.delegate = self
        searchResults.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOSections section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchResults.dequeueReusableCell(withIdentifier: "book", for: indexPath) as! BookTableViewCell
        
        let url = URL(string: bookResults[indexPath.row].getImgUrl())!
        let data = try? Data(contentsOf: url)
        
        if let imageData = data {
            let image = UIImage(data: imageData)
            cell.bookImg.image = image
        }
        
        cell.bookTitle.text = bookResults[indexPath.row].getName()
        cell.bookTitle.lineBreakMode = .byWordWrapping
        cell.bookTitle.numberOfLines = 3
        cell.bookTitle.font = FontScheme.gillsansFont(size: 20)
        
        cell.author.text = bookResults[indexPath.row].getAuthor()
        cell.author.lineBreakMode = .byWordWrapping
        cell.author.numberOfLines = 2
        cell.author.font = FontScheme.gillsansFont(size: 18)
        
        return cell
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        findMatchingBooks(query: bookSearchBar.text ?? "")
    }
    
    private func findMatchingBooks(query: String) {
        let encodedQuery: String = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        if encodedQuery != "" {
            bookResults = []
            let queryUrl: String = "https://www.goodreads.com/search/index.xml?key=" + AppInfo.goodreadsKey + "&q=" + encodedQuery
            let urlToParse = URL(string: queryUrl)!
            let queryParser = XMLParser(contentsOf: urlToParse)!
            queryParser.delegate = self
            queryParser.parse()
        }
    }
    
    func parserDidStartDocument(_ parser: XMLParser) {
        print("document started")
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        print("document ended")
        searchResults.reloadData()
        searchResults.setNeedsLayout()
        searchResults.setNeedsDisplay()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String]) {
        eName = elementName
        if elementName == "work" {
            bookTitle = String()
            bookAuthor = String()
            bookIsbn = String()
            bookImgUrl = String()
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "work" {
            let book = Book(name: bookTitle, author: bookAuthor, isbn: bookIsbn, imgUrl: bookImgUrl)
            bookResults.append(book)
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        if !data.isEmpty {
            if eName == "title" {
                bookTitle += data
            } else if eName == "name" {
                bookAuthor += data
            } else if eName == "id" {
                bookIsbn += data
            } else if eName == "image_url" {
                bookImgUrl += data
            }
        }
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
