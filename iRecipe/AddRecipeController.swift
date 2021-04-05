//
//  AddRecipeController.swift
//  iRecipe
//
//  Created by Guang Zheng Ang on 04/04/2021.
//

import UIKit

class AddRecipeController: UIViewController, UITableViewDataSource, UITableViewDelegate, 	UITextFieldDelegate,  UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    // MARK: AddRecipeController parameters
    var recipeList:Recipe = Recipe()
    var is_edit:BooleanLiteralType = false
    var editingRecipeName:String = ""
    var editingRecipeImagePath:String = ""
    var editingRecipeImage:UIImage = UIImage()
    var editingRecipeType:String = ""
    var editingRecipeDesc:String = ""
    var editingRecipeIngredient:[String] = [String]()
    var editingRecipeInstruction:[String] = [String]()
    
    var mainViewController:ViewController?
    var recipeDetailController:RecipeDetailsController?
    
    // MARK: Properties
    @IBOutlet weak var ingredientsTableView: UITableView!
    @IBOutlet weak var instructionTableView: UITableView!
    var ingredientsCount = 1
    var instructionCount = 1
    var imageChanged:BooleanLiteralType = false
    @IBOutlet weak var ingredientsTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var instructionsTableViewHeightConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var recipeImage: UIImageView! {
        didSet {
            recipeImage.isUserInteractionEnabled = true
        }
    }
    @IBOutlet weak var recipeName: UITextField!
    @IBOutlet weak var recipeType: UITextField!
    @IBOutlet weak var recipeDescription: UITextField!
    var ingredientsList:[UITextField] = [UITextField]()
    var instructionsList:[UITextField] = [UITextField]()
    
    var recipeTypeList: [String] = [String]()
    var selectedRecipeType: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if is_edit {
            print("load edit data")
            recipeName.text = editingRecipeName
            recipeImage.image = editingRecipeImage
            recipeType.text = editingRecipeType
            recipeDescription.text = editingRecipeDesc
            ingredientsCount = editingRecipeIngredient.count
            instructionCount = editingRecipeInstruction.count
            ingredientsList.removeAll()
            for i in 0..<editingRecipeIngredient.count {
                ingredientsList.append(UITextField())
                ingredientsList[i].text = editingRecipeIngredient[i]
            }
            instructionsList.removeAll()
            for i in 0..<editingRecipeInstruction.count {
                instructionsList.append(UITextField())
                instructionsList[i].text = editingRecipeInstruction[i]
            }
        }
        ingredientsTableView.delegate = self
        ingredientsTableView.dataSource = self
        ingredientsTableView.tableFooterView = UIView()
        instructionTableView.delegate = self
        instructionTableView.dataSource = self
        instructionTableView.tableFooterView = UIView()
        for each in recipeList.data {
            if !recipeTypeList.contains(each.type) {
                recipeTypeList.append(each.type)
            }
        }
        createPickerView()
        dismissPickerView()
        
        
    }
    
    // MARK: Table View delegates and data source
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == ingredientsTableView {
            return ingredientsCount
        } else if tableView == instructionTableView {
            return instructionCount
        }
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == ingredientsTableView {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TextInputTableViewCell", for: indexPath) as! TextInputTableViewCell
            if indexPath.row > (ingredientsList.count - 1) {
                ingredientsList.append(cell.getTextInput())
            }
//            ingredientsList[indexPath.row] = cell.getTextInput()
            cell.configure(text: ingredientsList[indexPath.row].text, placeholder: "Enter ingredient")
            
                return cell
        } else if tableView == instructionTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextInputTableViewCell2", for: indexPath) as! TextInputTableViewCell2
            if indexPath.row > (instructionsList.count - 1) {
                instructionsList.append(cell.getTextInput())
            }
            cell.configure(text: instructionsList[indexPath.row].text, placeholder: "Enter step")
            
            return cell
        }
        return UITableViewCell()
    }
    
    // MARK: TextField delegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    // MARK: Methods
    func createPickerView() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        recipeType.inputView = pickerView
    }
    
    func dismissPickerView() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.action))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        recipeType.inputAccessoryView = toolBar
    }
    
    // MARK: Picker View delegates
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return recipeTypeList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return recipeTypeList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRecipeType = recipeTypeList[row]
        recipeType.text = selectedRecipeType
    }
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        print("Image picker dismissed")
        dismiss(animated: true, completion: nil)
    }
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        print("Image selected from library")
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
                fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
            }
            
            // Set photoImageView to display the selected image.
            recipeImage.image = selectedImage
            
            // Dismiss the picker.
            dismiss(animated: true, completion: nil)
    }
    
    // MARK: Action
    @IBAction func addIngredient(_ sender: UIButton) {
        ingredientsCount = ingredientsCount + 1
        ingredientsTableView.reloadData()
        ingredientsTableViewHeightConstraint.constant = ingredientsTableView.contentSize.height
        
    }
    @IBAction func addInstruction(_ sender: UIButton) {
        instructionCount = instructionCount + 1
        instructionTableView.reloadData()
        instructionsTableViewHeightConstraint.constant = instructionTableView.contentSize.height
    }
    @IBAction func doneAddRecipe(_ sender: UIBarButtonItem) {
        for i in 0..<ingredientsTableView.visibleCells.count {
            let temp = ingredientsTableView.visibleCells[i] as! TextInputTableViewCell
            ingredientsList[i] = temp.getTextInput()
            
        }
        for i in 0..<instructionTableView.visibleCells.count {
            let temp = instructionTableView.visibleCells[i] as! TextInputTableViewCell2
            instructionsList[i] = temp.getTextInput()
            
        }
        var tempIngList:[String] = [String]()
        var tempInsList:[String] = [String]()
        for each in ingredientsList {
            print(each.text!)
            tempIngList.append(each.text!)
        }
        for each in instructionsList {
            print(each.text!)
            tempInsList.append(each.text!)
        }
        var finalImagePath:String = ""
        if imageChanged {
            let image:UIImage = recipeImage.image!
            let data = image.pngData()!
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyyMMdd_HHmmss"
            let nameDate:String = formatter.string(from: date)
            let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            var imgFileName: String = (recipeName.text?.replacingOccurrences(of: " ", with: ""))!
            imgFileName.append(nameDate)
            let imageURL = URL(fileURLWithPath: imgFileName, relativeTo: directoryURL).appendingPathExtension("png")
            do {
                try data.write(to: imageURL)
                print("written to path: \(imageURL.absoluteString)")
            } catch {
                print(error.localizedDescription)
            }
            finalImagePath = "file|\(imageURL.absoluteString)"
        } else {
            finalImagePath = editingRecipeImagePath
        }
        
        let newRecipe =  RecipeDetails(name: recipeName.text!, type: recipeType.text!, desc: recipeDescription.text!, imagePath: finalImagePath, ingredients: tempIngList, instructions: tempInsList)
        
        if is_edit {
            recipeDetailController?.onEditRecipeDone(recipe: newRecipe)
        } else {
            mainViewController?.onRecipeCreated(recipe: newRecipe)
        }
        
        self.navigationController?.popViewController(animated: true)
        
    }
    @objc func action() {
        view.endEditing(true)
    }
    @IBAction func selectRecipeImage(_ sender: UITapGestureRecognizer) {
        print("Image View Tapped")
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }
}
