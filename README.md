# Trips
[![Build Status](https://travis-ci.com/erikagujari1/trips.svg?branch=master)](https://travis-ci.com/erikagujari1/trips)

This is a sample app that retrieves trips and its stop details from `APIRest`.

Also lets the user to send a contact form with some observations, indeed it's stored in the device using `CoreData`. 

## Architecture
It is developed under MVVM pattern with use cases and repositories for Domain and Data layers.

Use of Combine as an aproximation to the common library 'RxSwift'.

Combine is used on different app layers. Almost all the UI is done programmatically except for 'ContactViewController'.

## Testing: 
With around 60% of code coverage this repository uses native XCTest framework to do all the tests which include:
* ViewModels
* CoreDataManager
* HTTPClient
* Repositories
* UseCases

## CI:
This repository uses [Travis-CI](https://docs.travis-ci.com/) on the master branch.

## Known issues:
- On ContactViewController keyboard may overlap textfields on small devices. KeyboardWillShow and willHide notification methods would be the perfect way to solve this problem.
