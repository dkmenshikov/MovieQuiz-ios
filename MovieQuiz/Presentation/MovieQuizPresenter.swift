//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Dmitriy Menshikov on 13.01.24.
//

import Foundation
import UIKit

final class MovieQuizPresenter {
    
    var currentQuestion: QuizQuestion?
    var correctAnswers: Int = 0

    // MARK: - Переменные сторонних сущностей
    weak var viewController: MovieQuizViewController?
    private var statisticService: StatisticService = StatisticServiceImplementation()
    var alertPresenter: ResultAlertPresenter = ResultAlertPresenter()

    
    private var currentQuestionIndex: Int = 0
    let questionsAmount: Int = 10
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount 
    }
    
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
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
    
    
    func yesButtonClicked() {
        didAnswer(isYes: true)
        print ("Нажатие ДА")
    }
    
    func noButtonClicked() {
        didAnswer(isYes: false)
        print ("Нажатие НЕТ")
    }
    
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion else {
            return
        }
        
        let givenAnswer = isYes
        let isCorrect =  givenAnswer == currentQuestion.correctAnswer
        if isCorrect {
            correctAnswers += 1
        }
        viewController?.showAnswerResult(isCorrect: isCorrect)
    }
    
    // MARK: - QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question else {
            return
        }
        currentQuestion = question
//        let viewModel = convert(model: question)
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    func showNextQuestionOrResults () {
//        currentQuestionIndex += 1
        switchToNextQuestion()
//        if currentQuestionIndex == questionsAmount {
        if isLastQuestion() {
            print ("Последний вопрос")
            
            statisticService.store(correct: correctAnswers, total: questionsAmount) //передаем в сервис сохранения статистики данные о правильных ответах в этой игре. Метод должен изменить сеттеры проперти класса
            let alertText = """
                            Ваш результат \(correctAnswers)/\(questionsAmount)
                            Количество сыграных квизов: \(statisticService.gamesCount)
                            Рекорд \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString))
                            Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
                            """
            //подготавливаем текст для печати на алерте из компонентов сервиса

            let alertModel: AlertModel = AlertModel(title: "Этот раунд окончен",
                                                    text: alertText,
                                                    buttonText: "Сыграть еще раз",
                                                    completion: { [weak self] _ in
//                self?.correctAnswers = 0
//                self?.currentQuestionIndex = 0
                self?.restartGame()
                self?.viewController?.questionFactory?.requestNextQuestion()
                print("нажатие повторной игры")
            })
            alertPresenter.delegate = viewController
            alertPresenter.showAlert(alertModel: alertModel)
            print ("Показ алерта")
        } else {
            self.viewController?.questionFactory?.requestNextQuestion()
        }
    }
}
