//
//  DataModel.swift
//  Search Image
//
//  Created by MacBook Pro on 4/7/20.
//  Copyright © 2020 skarev. All rights reserved.
//

import UIKit

struct SearchItem {
    let img: UIImage
    let name: String
    
    init(image: UIImage, name: String) {
        self.img = image
        self.name = name
    }
}

class DataModel {
    
    init() {
        self.setData()
    }
    
    public func setData() {
        let session = URLSession(configuration: .default)
        guard let url = URL(string: "https://api.gettyimages.com/v3/search/images") else {return}
        //?phrase=books
        let task = session.dataTask(with: url, completionHandler: {
            (data, responce, error) in
            print("here")
            print(data)
            print("____________________________")
            print(responce)
            print("____________________________")
            print(error)
            do {
                guard let dat = data else {return}
                let json = try JSONSerialization.jsonObject(with: dat, options: .allowFragments)
                print("++++++++++++++++")
                print(json)
            } catch {
                print("Error in JSONSerialization")
            }
        })
        task.resume()
    }
    
}
