# Marvel Heroes

iOS app that communicates with the [Marvel API](https://developer.marvel.com) to show all the Marvel Characters with the information provided by the API.

## First execution

### Install the dependencies with
```
pod install
```

### Create a file swift file `Secret.swift` on `marvel-heroes/Utils` with the following:
```swift
let marvelPublicAPIKey = "..." // Public API Key from developer.marvel.com
let marvelPrivateAPIKey = "..." // Private API Key from developer.marvel.com
```

Now you are ready to execute the app.