//
//  FileReader.swift
//  iRecipe
//
//  Created by Guang Zheng Ang on 04/04/2021.
//

import Foundation

func readFile(url: URL) -> Data {
    print(url)
    var savedData:Data = Data()
    do {
     // Get the saved data
     savedData = try Data(contentsOf: url)
    } catch {
     // Catch any errors
     print("Unable to read the file")
    }
    return savedData
}

func writeFile(url: URL, recipeData: Recipe) {
    
    var dataString = "<row>\n"
    
    for element in recipeData.data {
        dataString.append("<recipe>\n<name>\(String(element.name))</name>\n<type>\(String(element.type))</type>\n<desc>\(String(element.desc))</desc>\n<imagePath>\(String(element.imagePath))</imagePath>\n<ingredients>\n")
        for each in element.ingredients {
            dataString.append("<ing>\(each)</ing>\n")
        }
        dataString.append("</ingredients>\n<instructions>\n")
        for each in element.instructions {
            dataString.append("<step>\(each)</step>\n")
        }
        dataString.append("</instructions>\n</recipe>\n")
    }
    dataString.append("</row>")
    
    
    guard let data = dataString.data(using: .utf8) else {
        print("Unable to convert string to data")
        return
    }
    do {
     try data.write(to: url)
     print("File saved: \(url.absoluteURL)")
    } catch {
     // Catch any errors
     print(error.localizedDescription)
    }
    
}
