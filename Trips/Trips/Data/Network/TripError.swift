//
//  TripError.swift
//  Trips
//
//  Created by AGUJARI Erik on 01/03/2020.
//  Copyright © 2020 ErikAgujari. All rights reserved.
//

enum TripError: Error {
    case serviceError, parsingError, persistenceError

    var message: String {
        switch self {
        case .serviceError:
            return "We had an error, you should try again"
        case .parsingError:
            return "Sorry, data corrupted :("
        case .persistenceError:
            return "Could not store your data :("
        }
    }
}
