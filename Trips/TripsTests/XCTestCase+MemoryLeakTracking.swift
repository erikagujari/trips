//
//  XCTestCase+MemoryLeakTracking.swift
//  TripsTests
//
//  Created by Erik Agujari on 11/06/2020.
//  Copyright © 2020 ErikAgujari. All rights reserved.
//

import XCTest

extension XCTestCase {
    func trackForMemoryLeaks(instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should be deallocated, potentially memory leak", file: file, line: line)
        }
    }
}
