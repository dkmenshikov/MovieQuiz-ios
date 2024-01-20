//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Dmitriy Menshikov on 13.12.23.
//

import Foundation
import UIKit

class ResultAlertPresenter {
    
    weak var delegate: MovieQuizViewControllerProtocol?
    
    func showAlert(alertModel: AlertModel) {
        let alert = UIAlertController(title: alertModel.title,
                                      message: alertModel.text,
                                      preferredStyle: .alert)

        alert.view.accessibilityIdentifier = "Alert"
        
        let action = UIAlertAction(title: alertModel.buttonText, style: .default, handler: alertModel.completion)
        
        alert.addAction(action)

        
        delegate?.present(alert, animated: true, completion: nil)
    }
}
