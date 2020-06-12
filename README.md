# Trips
[![Build Status](https://travis-ci.com/erikagujari1/trips.svg?branch=master)](https://travis-ci.com/erikagujari1/trips)

## Architecture
It is developed under MVVM pattern with use cases and repositories for Domain and Data layers.

Use of Combine as an aproximation to the common library 'RxSwift'. An improve to this would be to also add SwiftUI but as my knowledge on this framework is not extense yet I preferred not to include it.

Combine is used on different app layers. Almost all the UI is done programmatically except for 'ContactViewController'. Normally I use AutoLayout but I thought that this could be a good moment to do it on a different way.

## Testing: 
With around 50% of code coverage I Used native XCTest framework to do all the tests which include:

* HomeViewModel
* ContactViewModel
* CoreDataManager
* URLSessionHTTPClient

## CI:
This repository uses [Travis-CI](https://docs.travis-ci.com/) on the master branch.

## Known issues:
- On ContactViewController keyboard may overlap textfields on small devices. KeyboardWillShow and willHide notification methods would be the perfect way to solve this problem, but I had no time to solve it yet.
