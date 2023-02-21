//
//  ErrorvC.swift
//  Prueba
//
//  Created by Joel Ramírez Reyes on 18/02/23.
//

import Foundation
import UIKit

class ErrorvC: UIViewController {
    
    @IBOutlet weak var lblError: UILabel!
    
    var error: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblError.text = error
    }
}
