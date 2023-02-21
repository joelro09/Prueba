//
//  AltasVC.swift
//  Prueba
//
//  Created by Joel Ramirez on 17/02/23.
//

import Foundation
import UIKit
import CoreData

class AltasVC: UIViewController {
    
    @IBOutlet weak var tableAltas: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var errorMessage = ""
    
    //private var productosVenta: [ProductoVenta]?
    //Producto de compras
    private var productos: [Producto]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUP()
        retriveData()
    }
    
    private func setUP(){
        title = "ALTA DE PRODUCTOS"
        tableAltas.register(UINib(nibName: "CompraCell", bundle: nil), forCellReuseIdentifier: "buyCell")
        tableAltas.dataSource = self
        tableAltas.delegate = self
      
    }
    
    private func retriveData() {
        do {
            self.productos = try context.fetch(Producto.fetchRequest())
            DispatchQueue.main.async {
                self.tableAltas.reloadData()
            }
            
        } catch {
            print("Error al cargar los datos")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ErrorvC {
            vc.error = errorMessage
        }
    }
    
}

extension AltasVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        productos?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "buyCell") as! CompraCell
        cell.lblClave.text = "Clave: \(productos?[indexPath.row].claveProduct ?? "Clave dum")"
        cell.lblNaem.text = "Producto: \(productos?[indexPath.row].nombreProduct ?? "Nombre dum")"
        cell.lblCantidad.text = "Cantidad disponible: \(productos?[indexPath.row].cantidadProduct ?? 0)"
        cell.altaLbl.isHidden = false
        cell.lblPrecio.isHidden = true
        cell.dateLbl.isHidden = true
        //productos?[indexPath.row].fecha ??
        cell.totalLbl.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*
        do{
            self.productosVenta = try context.fetch(ProductoVenta.fetchRequest())
        }catch{
            print("Error al cargar los datos de la BD ventas")
        }*/
        
        //Crear alerta para que el admin ingrese cuantos productos dará de alta
        let alert = UIAlertController(title: "Cantidad ", message: "Ingrese la cantidad de producto deseado: ", preferredStyle: .alert)
        alert.addTextField()
        let botonAlerta = UIAlertAction(title: "Dar de Alta", style: .default) { (action) in
            let textField = alert.textFields![0]
            
            let cantidad = Int64(textField.text ?? "0")
            //Evaluar si los productos a dar de alta son igual al stock
            
            if cantidad ?? 0 > self.productos?[indexPath.row].cantidadProduct ?? 1 {
                self.errorMessage = "ERROR: Necesitas comprar más \(self.productos?[indexPath.row].nombreProduct ?? "Producto seleccionado")"
                self.performSegue(withIdentifier: "errorSegue", sender: nil)
                //print("Necesitas comprar más \(self.productos?[indexPath.row].nombreProduct ?? "Producto seleccionado")")
            }else {
                let nuevaCantidadVentas = ProductoVenta(context: self.context)
                nuevaCantidadVentas.claveProduct =  self.productos?[indexPath.row].claveProduct
                nuevaCantidadVentas.nombreProduct =  self.productos?[indexPath.row].nombreProduct
                //Se le suma al precio de venta de acuerdo al porcentaje solicitado por la empresa
                nuevaCantidadVentas.precioVenta =  (self.productos?[indexPath.row].precioCompra ?? 0.0) + 10.0
                
                
                nuevaCantidadVentas.cantidadProduct = cantidad ?? 0
                let nuevoStock = (self.productos?[indexPath.row].cantidadProduct ?? 0) - (cantidad ?? 0)
                self.productos?[indexPath.row].cantidadProduct = nuevoStock
                try! self.context.save()
            }      
        }
        
        alert.addAction(botonAlerta)
        self.present(alert, animated: true)
        
    }
    
}
