//
//  ANF_Code_TestTests.swift
//  ANF Code TestTests
//


import XCTest
@testable import ANF_Code_Test

class ANFExploreCardTableViewControllerTests: XCTestCase {
    var testInstance: ANFExploreCardTableViewController!
    
    // Raw mock responses
    let successData = """
        [{
            "title": "TOPS STARTING AT $12",
            "backgroundImage": "http://anf.scene7.com/is/image/anf/anf-20160527-app-m-shirts?$anf-ios-fullwidth-3x$",
            "content": [
                [
                    "target": "https://www.abercrombie.com/shop/usmens-new-arrivals",
                    "title": "Shop Men"
                ],
                [
                    "target": "https://www.abercrombie.com/shop/us/womens-new-arrivals",
                    "title": "Shop Women"
                ]
            ],
            "promoMessage": "USE CODE: 12345",
            "topDescription": "A&F ESSENTIALS",
            "bottomDescription": "*In stores & online. <a href=\\\"http://www.website.html\\\">Exclusions apply. See Details</a>"
        },
        {
            "title": "TOPS STARTING AT $12",
            "backgroundImage": "http://anf.scene7.com/is/image/anf/anf-20160527-app-m-shirts?$anf-ios-fullwidth-3x$",
        }]
        """.data(using: .utf8)!
    
    let failureData = "Invalid JSON Data".data(using: .utf8)!
    
    func decodeSuccessData() throws -> [ExploreDataResponse] {
        let decoder = JSONDecoder()
        return try decoder.decode([ExploreDataResponse].self, from: successData)
    }
    
    // Testing lifecycle
    override func setUp() {
        testInstance = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController() as? ANFExploreCardTableViewController
        
        // Load the view hierarchy
        _ = testInstance.view
    
        do {
            testInstance.exploreData = try decodeSuccessData()
        } catch {
            print(error)
        }
    }
    
    override func tearDown() {
        testInstance = nil
        super.tearDown()
    }
    
    // Table View Tests
    func test_numberOfSections_ShouldBeOne() {
        let numberOfSections = testInstance.numberOfSections(in: testInstance.tableView)
        XCTAssert(numberOfSections == 1, "table view should have 1 section")
    }
    
    func test_fetchDataCalled() {
        let expectation = XCTestExpectation(description: "Fetch data from API")
        
        testInstance.fetchData {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
        
        XCTAssertNotNil(testInstance.exploreData)
    }
    
    func test_numberOfRows_ShouldBeMatchExploreDataCount() {
        let numberOfRows = testInstance.tableView(testInstance.tableView, numberOfRowsInSection: 0)
        XCTAssertEqual(numberOfRows, testInstance.exploreData?.count ?? 0, "Number of rows should match explore data count")
    }
    
    // Explore Content Tests
    
    // Title Tests
    func test_cellForRowAtIndexPath_titleText_shouldNotBeBlank() {
        let firstCell = testInstance.tableView(testInstance.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        let title = firstCell.viewWithTag(3) as? UILabel
        
        XCTAssertNotNil(title, "Title label should not be nil")
        XCTAssertEqual(title?.text, "TOPS STARTING AT $12", "Title text should match the expected title")
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
        XCTAssertEqual(topDescriptionLabel?.text, "A&F ESSENTIALS", "Top description label text should match the expected description")
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
        //        XCTAssert(promoLabel)
    }
    
    func test_promoLabelShouldBeHidden() {
        let cell = testInstance.tableView(testInstance.tableView, cellForRowAt: IndexPath(row: 1, section: 0))
        let promoLabel = cell.viewWithTag(4) as? UILabel

        XCTAssertTrue(promoLabel != nil)
    }
    
    // Explore Content Action Tests
    
    func test_handleContentButtonTap() {
        let indexPath = IndexPath(row: 0, section: 0)
        let exploreDataContent = testInstance.exploreData[0].content!
        
        let buttonModel = ButtonModel(targetURL: exploreDataContent[0].target, title: exploreDataContent[0].title)
        let button = ButtonComponent.createButton(with: buttonModel, indexPath: indexPath, target: nil, action: nil)
        
        XCTAssertNoThrow(testInstance.handleContentButtonTap(button), "Handling content button tap should not throw an error")
        XCTAssertEqual(button.titleLabel?.text, "Shop Men", "Button title should match the expected value")
        XCTAssertEqual(buttonModel.targetURL, "https://www.abercrombie.com/shop/us/mens-new-arrivals", "Button target should match the expected value")
    }
    
    func test_contentButtonAmount() {
        let exploreDataContent = testInstance.exploreData[0].content!
        XCTAssertEqual(exploreDataContent.count, 2, "number of buttons should equal 2")
    }
    
    // Bottom link button to be added later
    
    // API Tests
    
    func test_fetchDataURLSessionSuccess() {
        let viewModel = ExploreDataViewModel()
        
        let expectation = XCTestExpectation(description: "Fetch data success expectation")
        
        viewModel.fetchData { result in
            switch result {
            case .success(let responseData):
                XCTAssertFalse(responseData.isEmpty, "Expected non-empty data array, but got an empty array")
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Expected success, but got failure: \(error)")
            }
        }
        
        wait(for: [expectation], timeout: 10.0) // Adjust the timeout based on your network conditions
    }
}
