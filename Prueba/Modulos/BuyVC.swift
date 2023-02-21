//
//  BuyVC.swift
//  Prueba
//
//  Created by Jimena Reyes Reyes on 19/02/23.
//

import Foundation
import UIKit

class BuyVC: UIViewController {
    
    @IBOutlet weak var claveProducto: UITextField!
    @IBOutlet weak var nombreProducto: UITextField!
    @IBOutlet weak var precioCompra: UITextField!
    @IBOutlet weak var cantidadCompra: UITextField!
    
    //Referencia al Managed object context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "COMPRAS"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    //MARK: - Functions
    
    private func reloadTexts() {
        claveProducto.text = ""
        nombreProducto.text = ""
        precioCompra.text = ""
        cantidadCompra.text = ""
    }
    
    @IBAction func agregarCarrito(_ sender: Any) {
        guard let clave = claveProducto.text,
              let nombre = nombreProducto.text,
              let precio = precioCompra.text,
              let cantidad = cantidadCompra.text
        else {
            print("Error: No puede quedar ningun campo vacío")
            return
        }
        
        let newProduct = Producto(context: self.context)
        newProduct.claveProduct = clave
        newProduct.nombreProduct  = nombre
        newProduct.precioCompra = Double(precio) ?? 0.0
        newProduct.cantidadProduct = Int64(cantidad) ?? 0
        //Guardar información
        try! self.context.save()
        
        reloadTexts()
    }
}
