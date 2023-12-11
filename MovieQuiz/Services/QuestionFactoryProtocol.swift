//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Dmitriy Menshikov on 12.12.23.
//

import Foundation

protocol QuestionFactoryProtocol {
    func requestNextQuestion () -> QuizQuestion?
}
