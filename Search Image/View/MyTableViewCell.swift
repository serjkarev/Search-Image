//
//  MyTableViewCell.swift
//  Search Image
//
//  Created by MacBook Pro on 4/7/20.
//  Copyright © 2020 skarev. All rights reserved.
//

import UIKit

class MyTableViewCell: UITableViewCell {

    //MARK:- Properties
    
    var img: UIImageView = UIImageView(frame: .init(x: 0, y: 0, width: 1, height: 1))
    var label: UILabel = UILabel(frame: .init(x: 0, y: 0, width: 1, height: 1))
    
    //MARK:- Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.img.translatesAutoresizingMaskIntoConstraints = false
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(img)
        self.contentView.addSubview(label)
        self.img.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
        self.img.contentMode = .scaleAspectFit
        self.img.clipsToBounds = true
        self.label.numberOfLines = 0
        self.label.textAlignment = .center
        makeConstraints()
    }
    
    private func makeConstraints() {
        var constraints: [NSLayoutConstraint] = []
        constraints.append(contentsOf: [
            NSLayoutConstraint(item: img, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 5.0),
            NSLayoutConstraint(item: img, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 5.0),
            NSLayoutConstraint(item: img, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: 140),
            NSLayoutConstraint(item: img, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 140),
            NSLayoutConstraint(item: img, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: -5.0)
        ])
        constraints.append(contentsOf: [
            NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 5.0),
            NSLayoutConstraint(item: label, attribute: .leading, relatedBy: .equal, toItem: img, attribute: .trailing, multiplier: 1.0, constant: 5.0),
            NSLayoutConstraint(item: label, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -5.0),
            NSLayoutConstraint(item: label, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: -5.0)
        ])
        self.removeConstraints(self.constraints)
        self.addConstraints(constraints)
    }
    
    public func setData(data: SearchItem?) {
        guard let stringURL = data?.imgURL else {return}
        if let url = URL(string: stringURL) {
            self.img.load(url: url)
        }
        self.label.text = data?.name
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
