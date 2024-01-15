//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Dmitriy Menshikov on 13.01.24.
//

import Foundation
import UIKit

final class MovieQuizPresenter {
    
    private var currentQuestionIndex: Int = 0
    let questionsAmount: Int = 10
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount 
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
        print("значение счетчика вопросов \(currentQuestionIndex)")

    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
        print("значение счетчика вопросов \(currentQuestionIndex)")

    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
}
