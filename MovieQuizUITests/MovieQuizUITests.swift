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
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        
        app.terminate()
        app = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
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
//        дописать тест на старт новой игры после закрытия алерта
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
