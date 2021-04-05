//
//  ViewController.swift
//  iRecipe
//
//  Created by Guang Zheng Ang on 03/04/2021.
//

import UIKit

class ViewController: UIViewController,   UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, XMLParserDelegate{

    // MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var recipeTypeText: UITextField!
    
    var selectedRecipeType: String?
    var recipeType: [String] = [String]()
    
    var recipeList = Recipe()
    var recipeDetails = RecipeDetails()
    var currentContent = String()
    var currentIng: [String] = []
    var currentIns: [String] = []
    
    var filteredList = Recipe()
    var filteredListIndex:[NSInteger] = [NSInteger]()
    var selectedRow = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = URL(fileURLWithPath: "myFile", relativeTo: directoryURL).appendingPathExtension("xml")
        
        let savedData = readFile(url: fileURL)
        
        beginParsing(data: savedData)
        //recipeList.printRecipe()
        for element in recipeList.data {
            if !recipeType.contains(String(element.type!)) {
                recipeType.append(String(element.type!))
            }
        }
        selectedRecipeType = recipeType[0]
        recipeTypeText.text = selectedRecipeType
        for i in 0..<recipeList.data.count {
            if recipeList.data[i].type == selectedRecipeType {
                filteredList.addRecipeRow(row: recipeList.data[i])
                filteredListIndex.append(i)
            }
        }
        
        //recipeTypeText.text = recipeList.data[0].type
        //print(recipeList.data[0].name!)
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = true
        createPickerView()
        dismissPickerView()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Table View Delegates and Data sources
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredList.data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("creating table view")
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let row = indexPath.row
        let name = filteredList.data[row].name
        let type = filteredList.data[row].type
        let imagePath = filteredList.data[row].imagePath
        //Bridge data
        
        cell.textLabel?.text = name
        cell.detailTextLabel?.text = type
        if imagePath!.contains("name|") {
            let imageName = imagePath?.replacingOccurrences(of: "name|", with: "")
            cell.imageView?.image = UIImage(named: imageName!)
        } else if imagePath!.contains("url|") {
            let imageUrl = imagePath?.replacingOccurrences(of: "url|", with: "")
            cell.imageView?.imageFrom(url: URL(string: imageUrl!)!)
        } else if imagePath!.contains("file|") {
            let imageFileUrl = (imagePath?.replacingOccurrences(of: "file|", with: ""))!
            do {
                let data = try Data(contentsOf: URL(string: imageFileUrl)!)
                let image = UIImage(data: data)
                cell.imageView?.image = image
            } catch {
                print(error.localizedDescription)
            }
            
        } else {
            cell.imageView?.image = UIImage(named: "emptyImage")
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("cell tapped")
        let row = indexPath.row
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let vc = storyboard.instantiateViewController(withIdentifier: "RecipeDetailsController") as! RecipeDetailsController
        vc.recipeList = self.recipeList
        vc.recipeName = filteredList.data[row].name
        vc.recipeType = filteredList.data[row].type
        vc.recipeDesc = filteredList.data[row].desc
        vc.recipeImagePath = filteredList.data[row].imagePath
        vc.recipeIngredients = filteredList.data[row].ingredients
        vc.recipeInstructions = filteredList.data[row].instructions
        vc.recipeRow = filteredListIndex[row]
        vc.mainViewController = self

        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - XML Parsing Code
    func beginParsing(data: Data){
//        guard let myURL = URL(string:urlString) else {
//            print("URL not defined properly")
//            return
//        }
//        print("begin Parsing")
        let parser = XMLParser(data: data)
        parser.delegate = self
        recipeList = Recipe()
        if !parser.parse(){
            print("Data Errors Exist:")
            let error = parser.parserError!
            print("Error Description:\(error.localizedDescription)")
            print("Error reason:\(error)")
            print("Line number: \(parser.lineNumber)")
        }
        tableView.reloadData()
    }
    // MARK: XMLParser delegates
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String]) {
//        print("Beginning tag: <\(elementName)>")
        switch elementName {
        case "recipe":
            recipeDetails = RecipeDetails()
        case "name":
            currentContent = ""
        case "type":
            currentContent = ""
        case "desc":
            currentContent = ""
        case "imagePath":
            currentContent = ""
        case "ing":
            currentContent = ""
        case "step":
            currentContent = ""
        case "ingredients":
            currentIng = []
        case "instructions":
            currentIns = []
        default:
            return
        }
        currentContent = ""
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        currentContent += string
//        print("Added to \(currentContent)")
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
//        print("ending tag: </\(elementName)> with contents: \(currentContent)")
        switch elementName {
        case "recipe":
            recipeList.addRecipeRow(row: recipeDetails)
//            print("recipe has \(recipeDetails)")
        case "name":
            recipeDetails.name = String(currentContent)
        case "type":
            recipeDetails.type = String(currentContent)
        case "desc":
            recipeDetails.desc = String(currentContent)
        case "imagePath":
            recipeDetails.imagePath = String(currentContent)
        case "ing":
            currentIng.append(String(currentContent))
        case "step":
            currentIns.append(String(currentContent))
        case "ingredients":
            recipeDetails.ingredients.append(contentsOf: currentIng)
        case "instructions":
            recipeDetails.instructions.append(contentsOf: currentIns)
        default:
            return
        }
        
    }
    
    
    // MARK: Methods
    func createPickerView() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        recipeTypeText.inputView = pickerView
    }
    
    func dismissPickerView() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.action))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        recipeTypeText.inputAccessoryView = toolBar
    }
    func onRecipeCreated(recipe: RecipeDetails) {
        print("passed back to recipe created")
        recipeList.addRecipeRow(row: recipe)
        filteredList.data.removeAll()
        filteredListIndex.removeAll()
        for i in 0..<recipeList.data.count {
            if recipeList.data[i].type == selectedRecipeType {
                filteredList.addRecipeRow(row: recipeList.data[i])
                filteredListIndex.append(i)
            }
        }
        tableView.reloadData()
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = URL(fileURLWithPath: "myFile", relativeTo: directoryURL).appendingPathExtension("xml")
        writeFile(url: fileURL, recipeData: recipeList)
    }
    
    // MARK: Picker View delegates
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return recipeType.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return recipeType[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRecipeType = recipeType[row]
        recipeTypeText.text = selectedRecipeType
    }
    
    // MARK: Action
    @objc func action() {
        filteredList.data.removeAll()
        filteredListIndex.removeAll()
        for i in 0..<recipeList.data.count {
            if recipeList.data[i].type == selectedRecipeType {
                filteredList.addRecipeRow(row: recipeList.data[i])
                filteredListIndex.append(i)
            }
        }
        view.endEditing(true)
        tableView.reloadData()
    }
    
    @IBAction func goToAddRecipe(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let vc = storyboard.instantiateViewController(withIdentifier: "AddRecipeController") as! AddRecipeController
        vc.recipeList = self.recipeList
        vc.mainViewController = self
        

        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

