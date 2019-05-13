//
//  ErrorController.swift
//  TwitterClientSample
//
//  Created by shota ito on 02/05/2019.
//  Copyright © 2019 shota ito. All rights reserved.
//

import UIKit

enum SessionError: Error {
    case notFound
    case accessError
    case blankSearch
}

protocol ErrorHandller {
    var notFoundAlert: UIAlertController { get }
    var accessErrorAlert: UIAlertController { get }
    var blankSearchAlert: UIAlertController { get }
}

final class ErrorController: ErrorHandller {
    
    let notFoundAlert: UIAlertController = {
        let alert = UIAlertController(title: "Error", message: "Cannot find tweets.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return alert
    }()
    
    let accessErrorAlert: UIAlertController = {
        let alert = UIAlertController(title: "Error", message: "Cannot access the server. Please Retry searching.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return alert
    }()
    
    let blankSearchAlert: UIAlertController = {
        let alert = UIAlertController(title: "Error", message: "Please enter some words.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return alert
    }()
    
}
