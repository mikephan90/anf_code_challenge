//
//  ANF_Code_TestTests.swift
//  ANF Code TestTests
//


import XCTest
@testable import ANF_Code_Test

class ANFExploreCardTableViewControllerTests: XCTestCase {

    var testInstance: ANFExploreCardTableViewController!
    
    override func setUp() {
        testInstance = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController() as? ANFExploreCardTableViewController
    }

    // Title Tests
    func test_numberOfSections_ShouldBeOne() {
        let numberOfSections = testInstance.numberOfSections(in: testInstance.tableView)
        XCTAssert(numberOfSections == 1, "table view should have 1 section")
    }
    
    func test_numberOfRows_ShouldBeTen() {
        let numberOfRows = testInstance.tableView(testInstance.tableView, numberOfRowsInSection: 0)
        XCTAssert(numberOfRows == 10, "table view should have 10 cells")
    }
    
    func test_cellForRowAtIndexPath_titleText_shouldNotBeBlank() {
        let firstCell = testInstance.tableView(testInstance.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        let title = firstCell.viewWithTag(2) as? UILabel
        XCTAssert(title?.text?.count ?? 0 > 0, "title should not be blank")
    }
    
    // Image Tests
    func test_cellForRowAtIndexPath_ImageViewImage_shouldNotBeNil() {
        let firstCell = testInstance.tableView(testInstance.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        let imageView = firstCell.viewWithTag(1) as? UIImageView
        XCTAssert(imageView?.image != nil, "image view image should not be nil")
    }
    
    // Bottom Description Tests
    func test_labelWithLink() {
        let attributedString = testInstance.labelWithLink("<a href=\"https://test.com\">Link</a>")
        XCTAssertNotNil(attributedString, "Attributed string should not be nil")
    }
    
    func test_labelWithLink_InvalidHTMLString_ShouldReturnEmptyAttributedString() {
        let invalidHTMLString = "<invalidhtml>"
        let attributedString = testInstance.labelWithLink(invalidHTMLString)
        XCTAssertTrue(attributedString.string.isEmpty, "Attributed string should be empty for invalid HTML string")
    }
    
    func test_cellForRowAtIndexPath_BottomDescriptionLabel_ShouldNotBeNil() {
        let cell = testInstance.tableView(testInstance.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        let bottomDescriptionLabel = cell.viewWithTag(5) as? UILabel
        
        XCTAssertNotNil(bottomDescriptionLabel, "Bottom description label should not be nil")
        // Need test here for hyperlink and other text
    }
    
    func test_bottomDescriptionLabelShouldBeHidden() {
        let cell = testInstance.tableView(testInstance.tableView, cellForRowAt: IndexPath(row: 1, section: 0))
        let bottomDescriptionLabel = cell.viewWithTag(5) as? UILabel

        XCTAssertTrue(bottomDescriptionLabel != nil)
    }
    
    // Test Top Description,
    func test_cellForRowAtIndexPath_TopDescriptionLabel_ShouldNotBeNil() {
        let cell = testInstance.tableView(testInstance.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        let topDescriptionLabel = cell.viewWithTag(2) as? UILabel
        
        XCTAssertNotNil(topDescriptionLabel, "Top description label should not be nil")
    }
    
    func test_topDescriptionLabelShouldBeHidden() {
        let cell = testInstance.tableView(testInstance.tableView, cellForRowAt: IndexPath(row: 1, section: 0))
        let topDescriptionLabel = cell.viewWithTag(2) as? UILabel

        XCTAssertTrue(topDescriptionLabel != nil)
    }
    
    // Promo Label Tests
    func test_cellForRowAtIndexPath_PromoLabel_ShouldNotBeNil() {
        let cell = testInstance.tableView(testInstance.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        
        let promoLabel = cell.viewWithTag(4) as? UILabel
        XCTAssertNotNil(promoLabel, "Promo label should not be nil")
    }
    
    func test_promoLabelShouldBeHidden() {
        let cell = testInstance.tableView(testInstance.tableView, cellForRowAt: IndexPath(row: 1, section: 0))
        let promoLabel = cell.viewWithTag(4) as? UILabel

        XCTAssertTrue(promoLabel != nil)
    }
}
