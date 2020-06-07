# Trips
[![Build Status](https://travis-ci.com/erikagujari1/trips.svg?branch=master)](https://travis-ci.com/erikagujari1/trips)

## Architecture
It is developed under MVVM pattern with use cases and repositories for Domaind an Data layers.

I use RxSwift on my day to day but for this test I decided to try Combine instead. An improve to this would be to also add SwiftUI but as my knowledge on this framework is not extense yet I preferred not to include it.

Use of combine to connect different app layers. Almost all the UI is done programmatically but 'ContactViewController'. Normally I use AutoLayout but I thought that this could be a good moment to do it on a different way.

## Known issues:
- On ContactViewController keyboard may overlap textfields on small devices. KeyboardWillShow and willHide notification methods would be the perfect way to solve this problem, but I had no time to solve it yet.
- CoreData is not tested