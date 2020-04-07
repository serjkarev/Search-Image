//
//  ViewController.swift
//  Search Image
//
//  Created by MacBook Pro on 4/7/20.
//  Copyright © 2020 skarev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //MARK:- Properties
        
    private var mainView: MainView? {
        return self.view as? MainView
    }
    
    //MARK:- Methods
    
    override func loadView() {
        self.view = MainView(frame: UIScreen.main.bounds)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView?.setupUI()
    }

}

