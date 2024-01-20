//
//  PresenterTests.swift
//  MovieQuizTests
//
//  Created by Dmitriy Menshikov on 20.01.24.
//

import Foundation
import XCTest
import UIKit

@testable import MovieQuiz

final class MovieQuizViewControllerMock: UIViewController, MovieQuizViewControllerProtocol {
    
    func showStep(quiz step: MovieQuiz.QuizStepViewModel) {
    }
    
    func showResult(quiz result: MovieQuiz.AlertModel) {
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
    }
    
    func setActivityIndicator(isHidden: Bool) {
    }
    
    func showNetworkError(message: String) {
    }

}


final class MovieQuizPresenterTests: XCTestCase {
    func testPresenterConvertModel() throws {
        let viewControllerMock: MovieQuizViewControllerMock = MovieQuizViewControllerMock()
        let sut = MovieQuizPresenter(viewController: viewControllerMock)
        
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
        let viewModel = sut.convert(model: question)
        
         XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}
