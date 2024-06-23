//
//  ImageFileManager.swift
//  OperationPractice
//
//  Created by LittleFoxiOSDeveloper on 11/1/23.
//

import Foundation
import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import func CommonCrypto.CC_MD5
import typealias CommonCrypto.CC_LONG


class ImageFileManager: NSObject{
    
    private var cacheFolder: URL? = {
        if let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first{ //종류 체크
            let bundleID = (Bundle.main.bundleIdentifier ?? "") + "-imageCache"
            let path = cacheDirectory.appendingPathComponent(bundleID)
            
            try? FileManager.default.createDirectory(at: path, withIntermediateDirectories: false)
            
            return path
        }
        return nil
    }()
    
    //MD5 (Message-Digest algorithm 5) : 128비트 암호화 해시 함수
    private func md5(string: String) -> Data?{
        guard let messageData = string.data(using: String.Encoding.utf8) else {
            return nil
        }
        
        var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
        
        _ = digestData.withUnsafeMutableBytes({ digestBytes in
            messageData.withUnsafeBytes { messageBytes in
                CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
            }
        })
        
        return digestData
    }
    
    func imageFilePath(urlStr: String) -> URL?{
        let fileName = md5(string: urlStr)!.map{ String(format: "%02hhx", $0)}.joined() + ".png"
        return cacheFolder?.appendingPathComponent(fileName)
    }
    
    func isExistCacheFile(urlStr: String) -> Bool{
        if let filePath = imageFilePath(urlStr: urlStr){
//            return FileManager.default.fileExists(atPath: filePath.path())
            return FileManager.default.fileExists(atPath: filePath.path)
        }
        return false
    }
}
