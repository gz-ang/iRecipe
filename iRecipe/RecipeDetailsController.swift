//
//  RecipeDetailsController.swift
//  iRecipe
//
//  Created by Guang Zheng Ang on 04/04/2021.
//

import UIKit

class RecipeDetailsController: UIViewController {
    
    var mainViewController:ViewController?
    var recipeList:Recipe = Recipe()
    var recipeName:String = ""
    var recipeImagePath:String = ""
    var recipeDesc:String = ""
    var recipeType:String = ""
    var recipeIngredients:[String] = [String]()
    var recipeInstructions:[String] = [String]()
    var recipeRow:NSInteger = 0
    
    // MARK: Properties
    @IBOutlet weak var mealName: UILabel!
    @IBOutlet weak var mealDescription: UILabel!
    @IBOutlet weak var mealIngredients: UILabel!
    @IBOutlet weak var mealInstructions: UILabel!
    @IBOutlet weak var mealImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mealName.text = recipeName
        mealDescription.text = (mealDescription.text ?? "") + "\n\(recipeDesc)"
        for each in recipeIngredients {
            mealIngredients.text = (mealIngredients.text ?? "") + "\n - \(each)"
            
        }
        for i in 0..<recipeInstructions.count {
            mealInstructions.text = (mealInstructions.text ?? "") + "\n \(i+1). \(recipeInstructions[i])"
            
        }
        if recipeImagePath.contains("name|") {
            let imageName = recipeImagePath.replacingOccurrences(of: "name|", with: "")
            mealImage.image = UIImage(named: imageName)
        } else if recipeImagePath.contains("url|") {
            let imageUrl = recipeImagePath.replacingOccurrences(of: "url|", with: "")
            mealImage.imageFrom(url: URL(string: imageUrl)!)
        } else  if recipeImagePath.contains("file|") {
            let imageFileUrl = (recipeImagePath.replacingOccurrences(of: "file|", with: ""))
            do {
                let data = try Data(contentsOf: URL(string: imageFileUrl)!)
                let image = UIImage(data: data)
                mealImage.image = image
            } catch {
                print(error.localizedDescription)
            }
            
        } else {
            mealImage.image = UIImage(named: "emptyImage")
        }
    }
    
    // MARK: Methods
    func onEditRecipeDone(recipe: RecipeDetails) {
        
        print("Recipe edit done")
        recipeList.data[recipeRow] = recipe
        
        mealName.text = recipe.name
        mealDescription.text = "Description\n\(String(recipe.desc))"
        mealIngredients.text = "Ingredients"
        for each in recipe.ingredients {
            mealIngredients.text = (mealIngredients.text ?? "") + "\n - \(each)"
            
        }
        mealInstructions.text = "Instructions"
        for i in 0..<recipe.instructions.count {
            mealInstructions.text = (mealInstructions.text ?? "") + "\n \(i+1). \(recipe.instructions[i])"
            
        }
        if recipe.imagePath.contains("name|") {
            let imageName = recipe.imagePath.replacingOccurrences(of: "name|", with: "")
            mealImage.image = UIImage(named: imageName)
        } else if recipe.imagePath.contains("url|") {
            let imageUrl = recipe.imagePath.replacingOccurrences(of: "url|", with: "")
            mealImage.imageFrom(url: URL(string: imageUrl)!)
        } else  if recipe.imagePath.contains("file|") {
            let imageFileUrl = (recipe.imagePath.replacingOccurrences(of: "file|", with: ""))
            do {
                let data = try Data(contentsOf: URL(string: imageFileUrl)!)
                let image = UIImage(data: data)
                mealImage.image = image
            } catch {
                print(error.localizedDescription)
            }
            
        } else {
            mealImage.image = UIImage(named: "emptyImage")
        }
        
        mainViewController?.recipeList = recipeList
        
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = URL(fileURLWithPath: "myFile", relativeTo: directoryURL).appendingPathExtension("xml")
        writeFile(url: fileURL, recipeData: recipeList)
    }
    
    // MARK: Action
    @IBAction func goToEditRecipe(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let vc = storyboard.instantiateViewController(withIdentifier: "AddRecipeController") as! AddRecipeController
        vc.recipeList = self.recipeList
        vc.recipeDetailController = self
        vc.is_edit = true
        vc.editingRecipeName = recipeName
        vc.editingRecipeImagePath = recipeImagePath
        vc.editingRecipeImage = mealImage.image!
        vc.editingRecipeDesc = recipeDesc
        vc.editingRecipeType = recipeType
        vc.editingRecipeIngredient = recipeIngredients
        vc.editingRecipeInstruction = recipeInstructions
        
        

        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
