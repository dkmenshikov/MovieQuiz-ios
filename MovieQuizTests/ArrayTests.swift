//
//  ArrayTests.swift
//  MovieQuizTests
//
//  Created by Dmitriy Menshikov on 7.01.24.
//

import Foundation
import XCTest

@testable import MovieQuiz

class ArrayTests: XCTestCase {
    
    //тест на успешное взятие по индлексу
    func testGetValueInRange () throws {
        
        // Given
        let array = [2, 4, 5, 0, 55]
        
        // When
        let element = array [safe: 2]
        
        // Then
        XCTAssertEqual(element, array [2])
        XCTAssertNotNil(element)
    }
    //тест на взятие элемента по неправильному индексу
    func testGetValueOutOfRange() throws {
        // Given
        let array = [1, 1, 2, 3, 5]
        
        // When
        let value = array [safe: 20]
        
        // Then
        XCTAssertNil(value)
    }

}
