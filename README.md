# OneMappy
A Swift library for consuming One Map API for iOS

Source: https://docs.onemap.sg/

## Prerequisites
* iOS 11.0 and above
* Swift 5

## Installing

* CocoaPods: add 'OneMappy' to your Podfile and [pod install]

## Getting Started
```
import OneMappy

```
You may call the function by using OneMapRequestManager.sharedInstance()

```

OneMapRequestManager.sharedInstance.getOneMapSearch(keyword: searchBar.text!, pageNumber: page, onSuccess: { (jsonData) in
//Success
}, onFailure: { (_) in
//Fail request
})
```

The token generation and renewal will be handled for you

**getOneMapReverseGeocode(latitude: String, longtitude: String)**

latitude, longtitude - Latitude and longitude Coordinates in WGS84 format.

**getOneMapSearch(keyword: String, pageNumber: String)**

searchVal - Keywords entered by user that is used to filter out the results.

getAddrDetails - Checks if user wants to return address details for a point.

pageNum - Specifies the page to retrieve your search results from.

**getOneMapRoute(originLat: String, originLong: String, destinationLat: String, destinationLong: String, routeType: String)**

start - The start point in lat,lng (WGS84) format.

end - The end point in lat,lng (WGS84) format.

routeType - Values: walk, drive, pt, cycle.The different route types available. Route types must be in lowercase.

## Authors
Jerry Goh ( jerrygjy@gmail.com )

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/your/project/tags). 

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details


## To Do
Routing Example
Improvement in threading request


## Version History
* 0.0.1 - Alpha release
