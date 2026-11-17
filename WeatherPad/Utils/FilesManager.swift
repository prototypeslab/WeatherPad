import Foundation
import UIKit


func getFileSize(fromPath path: String) -> String? {
    var size: Any?
    do {
        size = try FileManager.default.attributesOfItem(atPath: path)[FileAttributeKey.size]
    } catch (let error) {

        Log.e("File size error: \(error)")
        return nil
    }
    guard let fileSize = size as? UInt64 else {
        return nil
    }
    
    if fileSize < 1023 {
        return String(format: "%lu bytes", CUnsignedLong(fileSize))
    }
    var floatSize = Float(fileSize / 1024)
    if floatSize < 1023 {
        return String(format: "%.1f KB", floatSize)
    }
    floatSize = floatSize / 1024
    if floatSize < 1023 {
        return String(format: "%.1f MB", floatSize)
    }
    floatSize = floatSize / 1024
    return String(format: "%.1f GB", floatSize)
}

func getDirectoryPath() -> String {
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    let documentsDirectory = paths[0]
    return documentsDirectory
}

func contentsOfDirectoryAtPath(path: String) -> [String]? {
    guard let paths = try? FileManager.default.contentsOfDirectory(atPath: path) else { return nil}
    return paths.map { aContent in (path as NSString).appendingPathComponent(aContent)}
}

func countTotalFilesInDirectoryAtPath(path: String) -> Int? {

    let enumerator = FileManager.default.enumerator(atPath: path)
    var filesCount : Int = 0
    while let filename = enumerator?.nextObject() as? String
    {
        let url = URL(fileURLWithPath: filename )
       let path = Path(url.path)
        
    if( path.isDirectory == false)
        {
            if(url.pathExtension == "pdf")
                {
                    filesCount+=1
                }
        }
        else
        {
        }

    }
    
    return filesCount
}

