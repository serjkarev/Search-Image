//
//  DataModel.swift
//  Search Image
//
//  Created by MacBook Pro on 4/7/20.
//  Copyright © 2020 skarev. All rights reserved.
//

import UIKit

struct SearchItem {
    let imgURL: String?
    let name: String
    
    init(imageURL: String?, name: String) {
        self.imgURL = imageURL
        self.name = name
    }
}

class DataModel {
    
    public var dataItem: SearchItem?
    
    private let key: String = "edd40a7b3f7ff27d61f72b440e56e16b"
//    private let secret: String = "f2ab11078f508cfd"
    private let baseURL: String = "https://api.flickr.com/services/rest"
    
//    init() {
//        self.getData("cat")
//    }
    
    public func getData(_ text: String) {
        let session = URLSession(configuration: .default)
        var imageSearchURL = URLComponents(string: baseURL)
        imageSearchURL?.queryItems = [URLQueryItem(name: "method", value: "flickr.photos.search"),
                                      URLQueryItem(name: "api_key", value: "edd40a7b3f7ff27d61f72b440e56e16b"),
                                      URLQueryItem(name: "format", value: "json"),
                                      URLQueryItem(name: "nojsoncallback", value: "1"),
                                      URLQueryItem(name: "text", value: text)]
        guard let finalURL = imageSearchURL?.url else {return}
        let task = session.dataTask(with: finalURL, completionHandler: { [weak self]
            (data, responce, error) in
            guard let dat = data else {return}
            let decoder = JSONDecoder()
            if let finalJSON = try? decoder.decode(Search.self, from: dat) {
                let randomResult = finalJSON.photos.photo.randomElement()
                guard let photoId = randomResult?.id else {return}
                var infoURL = URLComponents(string: self?.baseURL ?? "")
                infoURL?.queryItems = [
                                        URLQueryItem(name: "method", value: "flickr.photos.getInfo"),
                                        URLQueryItem(name: "api_key", value: "edd40a7b3f7ff27d61f72b440e56e16b"),
                                        URLQueryItem(name: "photo_id", value: photoId),
                                        URLQueryItem(name: "format", value: "json"),
                                        URLQueryItem(name: "nojsoncallback", value: "1")]
                guard let finalInfoURL = infoURL?.url else {return}
                let task = session.dataTask(with: finalInfoURL, completionHandler: {
                    (data, responce, error) in
                    guard let datInfo = data else {return}
                    if let finalInfoJSON = try? decoder.decode(PhotoInfo.self, from: datInfo) {
                        self?.dataItem = SearchItem(imageURL: finalInfoJSON.photo.urls.url.dropFirst(0).first?.content, name: text)
//                        print(finalInfoJSON.photo.urls.url)
                    } else {
                        print("Error in InfoJSON Decoding")
                    }
                })
                task.resume()
            } else {
                print("Error in JSON Decoding")
            }
        })
        task.resume()
    }
    
}

// MARK: - Search
struct Search: Codable {
    let photos: Photos
    let stat: String
}

// MARK: - Photos
struct Photos: Codable {
    let page, pages, perpage: Int
    let total: String
    let photo: [Photo]
}

// MARK: - Photo
struct Photo: Codable {
    let id, owner, secret, server: String
    let farm: Int
    let title: String
    let ispublic, isfriend, isfamily: Int
}

// MARK: - PhotoInfo
struct PhotoInfo: Codable {
    let photo: Phot
}

// MARK: - Photo
struct Phot: Codable {
    let urls: Urls
}

// MARK: - Urls
struct Urls: Codable {
    let url: [URLElement]
}

// MARK: - URLElement
struct URLElement: Codable {
    let content: String

    enum CodingKeys: String, CodingKey {
        case content = "_content"
    }
}
