//
//  Recipe.swift
//  iRecipe
//
//  Created by Guang Zheng Ang on 03/04/2021.
//

import UIKit

class Recipe: NSObject {
    var data: [RecipeDetails] = []
    func addRecipeRow(row: RecipeDetails) {
        data += [row]
    }
    func printRecipe() {
        for element in data {
            element.printAll()
        }
    }
}

class RecipeDetails: NSObject {
    var name: String!
    var type: String!
    var desc: String!
    var imagePath: String!
    var ingredients: [String] = []
    var instructions: [String] = []
    
    override init() {
    }
    init(name:String, type:String , desc:String, imagePath:String, ingredients:[String], instructions:[String]) {
        self.name = name
        self.type = type
        self.desc = desc
        self.imagePath = imagePath
        self.ingredients = ingredients
        self.instructions = instructions
    }
    
    func printAll() {
        print("name: \(String(name))")
        print("type: \(String(type))")
        print("desc: \(String(desc))")
        print("imagePath: \(String(imagePath))")
        print("ingredients:")
        for each in ingredients {
            print(String(each))
        }
        print("instructions:")
        for each in instructions {
            print(String(each))
        }
    }
}
