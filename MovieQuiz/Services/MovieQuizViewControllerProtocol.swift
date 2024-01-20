//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Dmitriy Menshikov on 20.01.24.
//

import Foundation
import UIKit

protocol MovieQuizViewControllerProtocol: /*AnyObject, */UIViewController {
    func showStep(quiz step: QuizStepViewModel)
    func showResult(quiz result: AlertModel)
    
    func highlightImageBorder(isCorrectAnswer: Bool)
    
    func setActivityIndicator(isHidden: Bool)
    
    func showNetworkError(message: String)
}
