//
//  XMLParseManager.swift
//  NewsAggregator
//
//  Created by Pavel Procenko on 18.06.2020.
//  Copyright © 2020 Pavel Procenko. All rights reserved.
//

import Foundation

class XmlParserManager: NSObject, XMLParserDelegate {
    
    var parser = XMLParser()
    var news: [News] = []
    var feeds = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = NSString()
    var ftitle = NSMutableString()
    var link = NSMutableString()
    var img = String()
    var fdescription = NSMutableString()
    var fdate = NSMutableString()
    
    // initilise parser
    func initWithURL(_ url :URL) -> AnyObject {
        startParse(url)
        return self
    }
    
    func startParse(_ url :URL) {
        feeds = []
        parser = XMLParser(contentsOf: url)!
        parser.delegate = self
        parser.shouldProcessNamespaces = false
        parser.shouldReportNamespacePrefixes = false
        parser.shouldResolveExternalEntities = false
        parser.parse()
    }
    
    func allFeeds() -> [News] {
        return news
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        element = elementName as NSString
        if (element as NSString).isEqual(to: "item") {
            elements =  NSMutableDictionary()
            elements = [:]
            ftitle = NSMutableString()
            ftitle = ""
            link = NSMutableString()
            link = ""
            fdescription = NSMutableString()
            fdescription = ""
            fdate = NSMutableString()
            fdate = ""
        } else if (element as NSString).isEqual(to: "enclosure") {
            if let urlString = attributeDict["url"] {
                img = urlString
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        var news = News()
        if (elementName as NSString).isEqual(to: "item") {
            news.title = ftitle.replacingOccurrences(of: "\n", with: "") as String
            news.link = link as String
            news.description = fdescription.replacingOccurrences(of: "\n", with: "") as String
            
            var dateInString = fdate as String
            dateInString.removeLast()
            dateInString.removeLast()
            dateInString.removeLast()
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
            let date = dateFormatter.date(from: dateInString)
            guard let resultDate = date else {return}
            news.date = resultDate
            news.image = img
            self.news.append(news)
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if element.isEqual(to: "title") {
            ftitle.append(string)
        } else if element.isEqual(to: "link") {
            link.append(string)
        } else if element.isEqual(to: "description") {
            fdescription.append(string)
        } else if element.isEqual(to: "pubDate") {
            fdate.append(string)
        }
    }
}
