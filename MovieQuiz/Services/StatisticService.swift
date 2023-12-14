//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Dmitriy Menshikov on 14.12.23.
//

import Foundation

protocol StatisticService {
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
    
    func store(correct count: Int, total amount: Int)
}

struct GameRecord: Codable {
    var correct: Int
    var total: Int
    var date: Date
    
    func checkNewRecord (newRecord: GameRecord) -> Bool {
        self.correct < newRecord.correct
    }
}

/*
 Этот раунд окончен!
 Ваш результат: 6/10
 Рекорд 6/10 (03.07.22 03:22)
 Средняя точность 60%
 */

final class StatisticServiceImplementation: StatisticService {
    private let userDefaults = UserDefaults.standard
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
    var totalAccuracy: Double {
        get {
            let total = Double(userDefaults.integer(forKey: Keys.total.rawValue))
            let correct = Double(userDefaults.integer(forKey: Keys.correct.rawValue))
            return (correct/total)*100
        }
        
        set {
            
        }
    }
    
    var gamesCount: Int {
        get { // при обращении на чтение
            return userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        }
        set { // при записи нового значения в gamesCount
                userDefaults.setValue(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
            }
            return record
        }
        
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    var correctAnswers: Int {
        get { // при обращении на чтение
            return userDefaults.integer(forKey: Keys.correct.rawValue)
        }
        set { // при записи нового значения в gamesCount
                userDefaults.setValue(newValue, forKey: Keys.correct.rawValue)
        }
    }
    var totalQuestions: Int {
        get { // при обращении на чтение
            return userDefaults.integer(forKey: Keys.total.rawValue)
        }
        set { // при записи нового значения в gamesCount
                userDefaults.setValue(newValue, forKey: Keys.total.rawValue)
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        
        // функция должна проверить, что новый лучший результат лучше предыдущего. Если да, сохранять его в User Defaults. Не забыть, что в GameRecord есть метод по проверке лучшего
        // Метод должен запускать сеттер bestGame
        
        gamesCount += 1
        correctAnswers += count
        totalQuestions += amount
        //totalAccuracy = Double(Double(correctAnswers) / Double(totalQuestions)) * 100
        let newRecord = GameRecord(correct: count, total: amount, date: Date.init())
        if bestGame.checkNewRecord(newRecord: newRecord) {
            bestGame = newRecord
        }
        
    }
    
    
}
