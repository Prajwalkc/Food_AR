//
//  ModelLoader.swift
//  SimpleWebAR
//
//  Created by Prajwal Kc on 12/10/18.
//  Copyright © 2018 ekBana. All rights reserved.
//

import Foundation
import ARKit
import SSZipArchive

class ModelLoader {
    
    func downloadZip(model : Items, completion : @escaping (SCNNode?) -> ()) {
        
        let urlReq = URLRequest(url: URL(string: model.modelUrl!)!)
        let configuration = URLSessionConfiguration.default
        let urlSession : URLSession = URLSession(configuration: configuration)
        let documentUrl : URL? = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let destinationFileUrl = documentUrl!.appendingPathComponent("\(String(describing: model.folderName!)).zip")
        let nodeUrl = documentUrl!.appendingPathComponent("\(model.folderName!)/\(model.modelName!).dae")
        
        let downloadTask = urlSession.downloadTask(with: urlReq) { (remoteUrl, urlResponse, error) in
            if let fileRemoteUrl = remoteUrl{
               do {
                    if (FileManager.default.fileExists(atPath: destinationFileUrl.path)) {
                        let node = SCNReferenceNode(url: nodeUrl)
                        node?.load()
                        print(node!.childNodes)
                        completion(node)
                    } else {

                        print(FileManager.default.fileExists(atPath: destinationFileUrl.path))
                        try SSZipArchive.unzipFile(atPath: fileRemoteUrl.path , toDestination: (documentUrl?.path)!, overwrite: true, password: nil)
                        print("file exist \(FileManager.default.fileExists(atPath: nodeUrl.path))")
                        
                        let node = SCNReferenceNode(url: nodeUrl)
                        
                        node?.load()
                        print(node!.childNodes)
                        completion(node)
                    }
                    print("file downloaded to \(destinationFileUrl.path)")
                } catch {
                    completion(nil)
                    print("cannot copy item\(error.localizedDescription)")
                }
                
            }else if  (FileManager.default.fileExists(atPath: nodeUrl.path)) {
                    let node = SCNReferenceNode(url: nodeUrl)
                    node?.load()
                    print(node!.childNodes)
                    completion(node)
                
                
            } else {
                completion(nil)
            }
            
            
        }
        
        downloadTask.resume()
        
        
    }
    
}
