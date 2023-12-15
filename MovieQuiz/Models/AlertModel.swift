//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Dmitriy Menshikov on 13.12.23.
//

import Foundation
import UIKit

struct AlertModel {
    let title: String
    let text: String
    let buttonText: String
    
    var completion: ((UIAlertAction) -> Void)? = nil
    
}
