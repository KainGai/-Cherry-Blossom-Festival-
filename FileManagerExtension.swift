import Foundation
extension FileManager {
    class var NCCBF2017EventImagesCachesDirectory: URL {
        let cachesDirectory = FileManager.cachesDirectory
        return cachesDirectory.appendingPathComponent(NCCBF2017EventImagesString)
    }
}
extension FileManager {
    class var documentDirectory: URL {
        return FileManager.url(for: .documentDirectory)
    }
    class var cachesDirectory: URL {
        return FileManager.url(for: .cachesDirectory)
    }
    private class func url(for directory: FileManager.SearchPathDirectory) -> URL {
        return FileManager.default.urls(for: directory, in: .userDomainMask).last!
    }
}
