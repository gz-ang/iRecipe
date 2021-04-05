//
//  Extensions.swift
//  iRecipe
//
//  Created by Guang Zheng Ang on 04/04/2021.
//

import Foundation
import UIKit

extension UIImageView{
  func imageFrom(url:URL){
    DispatchQueue.global().async { [weak self] in
      if let data = try? Data(contentsOf: url){
        if let image = UIImage(data:data){
          DispatchQueue.main.async{
            self?.image = image
          }
        }
      }
    }
  }
}


