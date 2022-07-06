//
//  Challenge_Job_ReadinessTests.swift
//  Challenge Job-ReadinessTests
//
//  Created by Douglas Eiki Yonemura on 06/07/22.
//

import XCTest
@testable import Challenge_Job_Readiness

class Challenge_Job_ReadinessTests: XCTestCase {

    func test_CategoryAPI() throws {
        
        let categoryService = CategoryService()
        categoryService.getCategory(category: "Teste") { category in
            XCTAssertNotNil(category)
        }
    }
    
    func test_ListServiceAPI() throws {
        
        let listService = ListService()
        listService.getList(category: "MLM1055") { content in
            XCTAssertNotNil(content)
        }
    }
    
    func test_ItemServiceAPI() throws {
        
        ItemService.getItem(itemArray: ["MLM895736248"]) { items in
            XCTAssertNotNil(items)
        }
    }
    
    func testParseItemJSON() throws {
        
        guard let pathString = Bundle(for: type(of: self)).path(forResource: "item", ofType: "json") else { fatalError("JSON not found") }
        
        guard let json = try? String(contentsOfFile: pathString, encoding: .utf8) else { fatalError("Unable to convert JSON to String") }

        let data = json.data(using: .utf8)!
        let itemData = try JSONDecoder().decode([ResultItem].self, from: data)

        XCTAssertEqual(200, itemData[0].code)
        XCTAssertEqual("MLM895736248", itemData[0].body.id)
        XCTAssertEqual("Celular Samsung Galaxy A52 128gb 6gb Ram Nfc Liberado Negro ", itemData[0].body.title)
    }

}
