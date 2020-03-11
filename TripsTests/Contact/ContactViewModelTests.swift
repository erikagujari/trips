//
//  ContactViewModelTests.swift
//  TripsTests
//
//  Created by AGUJARI Erik on 11/03/2020.
//  Copyright © 2020 ErikAgujari. All rights reserved.
//

import XCTest
@testable import Trips

final class ContactViewModelTests: XCTestCase {
    private var sut: ContactViewModelProtocol!

    override func setUp() {
        super.setUp()
        sut = ContactViewModel(dependencies: ContactViewModelDependencies())
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testFormSucess() {
        XCTAssert(sut.errorMessage == nil)
        sut.submitForm(name: "Bob",
                       surname: "Dylan",
                       email: "BobDylan@gmail.com",
                       phone: "",
                       date: "2020-03-10",
                       description: "Test1")
        XCTAssert(sut.errorMessage == nil)
        XCTAssert(sut.successMessage != nil)
        sut.submitForm(name: "Bob",
        surname: "Dylan",
        email: "BobDylan@gmail.com",
        phone: "611111111",
        date: "2020-03-10",
        description: "Test1")
        XCTAssert(sut.errorMessage == nil)
        XCTAssert(sut.successMessage != nil)
    }

    func testFormFails() {
        XCTAssert(sut.errorMessage == nil)
        sut.submitForm(name: "Bob",
                       surname: "Dylan",
                       email: "BobDylan@gmail.com",
                       phone: "",
                       date: "2020-03-10",
                       description: "")
        XCTAssert(sut.errorMessage != nil)
        XCTAssert(sut.successMessage == nil)
        sut.submitForm(name: "",
        surname: "Dylan",
        email: "BobDylan@gmail.com",
        phone: "611111111",
        date: "2020-03-10",
        description: "Test1")
        XCTAssert(sut.errorMessage != nil)
        XCTAssert(sut.successMessage == nil)
    }
}
