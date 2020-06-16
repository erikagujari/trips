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
    func test_validFormWithFilledPhone_endsWithSuccess() {
        let sut = makeSut()
        let form = validForm(phone: "611444333")
        
        expect(sut: sut, form: form, isValid: true)
    }
    
    func test_validFormWithNilPhone_endsWithSuccess() {
        let sut = makeSut()
        let form = validForm(phone: nil)
        
        expect(sut: sut, form: form, isValid: true)
    }
    
    func test_validFormWithEmptyPhone_endsWithSuccess() {
        let sut = makeSut()
        let form = validForm(phone: "")
        
        expect(sut: sut, form: form, isValid: true)
    }
    
    func test_invalidFormWithEmptyName_endsWithError() {
        let sut = makeSut()
        let form = invalidForm(name: "")
        
        expect(sut: sut, form: form, isValid: false)
    }
    
    func test_invalidFormWithEmptySurname_endsWithError() {
        let sut = makeSut()
        let form = invalidForm(surname: "")
        
        expect(sut: sut, form: form, isValid: false)
    }
    
    func test_invalidFormWithEmptyDate_endsWithError() {
        let sut = makeSut()
        let form = invalidForm(date: "")
        
        expect(sut: sut, form: form, isValid: false)
    }
    
    func test_invalidFormWithEmptyDescription_endsWithError() {
        let sut = makeSut()
        let form = invalidForm(description: "")
        
        expect(sut: sut, form: form, isValid: false)
    }
}

//MARK: - Helpers
extension ContactViewModelTests {
    private func makeSut(file: StaticString = #file, line: UInt = #line) -> ContactViewModelProtocol {
        let contact = ContactViewModel()
        trackForMemoryLeaks(instance: contact, file: file, line: line)
        return contact
    }
    
    private func validForm(phone: String? = nil) -> FormModel {
        return FormModel(name: "Bob",
                         surname: "Dylan",
                         email: "BobDylan@gmail.com",
                         phone: phone,
                         date: "2020-03-10",
                         description: "Test1")
    }
    
    private func invalidForm(name: String = "Bob", surname: String = "Dylan", email: String = "BobDylan@gmail.com", date: String = "2020-03-10", description: String = "Test1") -> FormModel {
        return FormModel(name: name,
                         surname: surname,
                         email: email,
                         phone: "",
                         date: date,
                         description: description)
    }
    
    private func expect(sut: ContactViewModelProtocol, form: FormModel, isValid: Bool, file: StaticString = #file, line: UInt = #line) {
        XCTAssertNil(sut.errorMessage.value, file: file, line: line)
        sut.submitForm(name: form.name,
                       surname: form.surname,
                       email: form.email,
                       phone: form.phone,
                       date: form.date,
                       description: form.description)
        XCTAssertEqual(isValid, sut.errorMessage.value == nil, file: file, line: line)
        XCTAssertEqual(isValid, sut.successMessage.value != nil, file: file, line: line)
    }
}
