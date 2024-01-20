//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Dmitriy Menshikov on 7.01.24.
//

import XCTest

final class MovieQuizUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launch()
 
        continueAfterFailure = false

    }

    override func tearDownWithError() throws {
        
        app.terminate()
        app = nil
        
    }
    
    func testYesButton () {
        // тест на смену постера при нажатии кнопки "Да"
        
        sleep(3)
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        app.buttons["Yes"].tap()
        sleep(3)
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        XCTAssertFalse(firstPosterData == secondPosterData)
        
        let indexLabel = app.staticTexts["Index"]
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
    func testNoButton () {
        // тест на смену постера при нажатии кнопки "Нет"
        
        sleep(3)
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        app.buttons["No"].tap()
        sleep(3)
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        XCTAssertFalse(firstPosterData == secondPosterData)
        
        let indexLabel = app.staticTexts["Index"]
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
    func testAlertPresenter () {
        for _ in 1...10 {
            sleep (1)
            app.buttons["No"].tap()
        }
        sleep (1)
        let alertPresenter = app.alerts["Alert"]
        XCTAssertTrue(alertPresenter.exists)
        XCTAssertTrue(alertPresenter.label == "Этот раунд окончен")
        XCTAssertTrue(alertPresenter.buttons.firstMatch.label == "Сыграть еще раз")
    }
    
    func testStartNewGameAfterAlert () {

        for _ in 1...10 {
            sleep (1)
            app.buttons["No"].tap()
        }
        sleep (1)
        let alertPresenter = app.alerts["Alert"]
        alertPresenter.buttons.firstMatch.tap()
        sleep (2)
        let indexLabel = app.staticTexts["Index"]
        XCTAssertTrue(indexLabel.label == "1/10")
    }

}
