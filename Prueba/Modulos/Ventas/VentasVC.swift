//
//  VentasVC.swift
//  Prueba
//
//  Created by Joel Ramírez on 18/02/23.
//

import Foundation
import UIKit

class VentasVC: UIViewController {
    
    @IBOutlet weak var tableVentas: UITableView!
    @IBOutlet weak var TotalVentasLbl: UILabel!
    
    //Referencia al Managed object context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var errorMessage = ""
    var isSelected = false
    var precioTotal = 1
    var cantidad = 0
    var indexPath: Int?
    
    //Cambiar a variable de tipo Producto sin datos iniciales
    private var productosVenta: [ProductoVenta]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUP()
        retriveData()
    }
    
    
    //MARK: - FUNCTIONS
    private func setUP () {
        title = "PRODUCTOS EN VENTA"
        tableVentas.register(UINib(nibName: "CompraCell", bundle: nil), forCellReuseIdentifier: "buyCell")
        tableVentas.dataSource = self
        tableVentas.delegate = self
    }
    
    //Recuperar datos de BD
    private func retriveData () {
        do {
            self.productosVenta = try context.fetch(ProductoVenta.fetchRequest())
            DispatchQueue.main.async {
                self.tableVentas.reloadData()
                self.TotalVentasLbl.text = "Gran Total: \(self.precioTotal)"
            }
            ReporteVC.granTotal = precioTotal
        } catch {
            print("Error al cargar los datos")
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ErrorvC {
            vc.error = errorMessage
        }
    }
    
    @IBAction func venderAction(_ sender: Any) {
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}

extension VentasVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        productosVenta?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let date = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "YY/MM/dd"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "buyCell") as! CompraCell
        let producto = productosVenta?[indexPath.row]
        let productoSelected = productosVenta?[self.indexPath ?? 0]
        
        
        if isSelected == true {
            if indexPath.row == self.indexPath {
                let total: Double =  Double(self.cantidad) * ((productoSelected?.precioVenta ?? 0))
                cell.lblClave.text = "Clave: \(productoSelected?.claveProduct ?? "Clave dum")"
                cell.lblNaem.text = "producto: \(productoSelected?.nombreProduct ?? "Nombre dum")"
                cell.lblCantidad.text = "Cantidad Disponible: \(self.cantidad)"
                productoSelected?.precioVenta = Double(self.cantidad)
                cell.lblPrecio.text = "Precio: \(productoSelected?.precioVenta ?? 0)"
                cell.dateLbl.text = "Fecha: \(dateFormat.string(from:  date))"
                productoSelected?.total = total
                cell.totalLbl.text = "Total de Articulo: \(total)"
            }
            //isSelected.toggle()
            
        } else {
            let total: Double =  Double((producto?.cantidadProduct ?? 0)) * ((producto?.precioVenta ?? 0))
            cell.lblClave.text = "Clave: \(producto?.claveProduct ?? "Clave dum")"
            cell.lblNaem.text = "producto: \(producto?.nombreProduct ?? "Nombre dum")"
            cell.lblCantidad.text = "Cantidad Disponible: \(producto?.cantidadProduct ?? 0)"
            cell.lblPrecio.text = "Precio: \(producto?.precioVenta ?? 0)"
            cell.dateLbl.text = "Fecha: \(dateFormat.string(from:  date))"
            producto?.total = total
            cell.totalLbl.text = "Total de Articulo: \(total)"
            self.precioTotal += Int(producto?.total ?? 0)
        }
         return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Cantidad a vender", message: "Ingrese la cantidad de producto a vender", preferredStyle: .alert)
        alert.addTextField()
        let botonAlert = UIAlertAction(title: "Cantidad", style: .default) { (action) in
            
            let textField = alert.textFields![0]
            let cantidad = Int64(textField.text ?? "0")
            
            self.indexPath = indexPath.row
            //self.isSelected = true
            self.precioTotal = 1
            
            if cantidad ?? 0 > self.productosVenta?[indexPath.row].cantidadProduct ?? 1 {
                self.errorMessage = "ERROR: Necesitas dar de alta más \(self.productosVenta?[indexPath.row].nombreProduct ?? "Producto seleccionado")"
                self.performSegue(withIdentifier: "errorSegue", sender: nil)
            } else {
                self.cantidad = Int(cantidad ?? 0)
                let nuevaVenta = ReporteVentas(context: self.context)
                nuevaVenta.claveVenta = self.productosVenta?[indexPath.row].claveProduct
                nuevaVenta.nombreProducto = self.productosVenta?[indexPath.row].nombreProduct
                nuevaVenta.total = self.productosVenta?[indexPath.row].total ?? 0
                nuevaVenta.cantidadVenta = self.productosVenta?[indexPath.row].cantidadProduct ?? 0
                
                let nuevoStock = (self.productosVenta?[indexPath.row].cantidadProduct ?? 0) - (cantidad ?? 0)
                self.productosVenta?[indexPath.row].cantidadProduct = nuevoStock
                try! self.context.save()
            }
            self.retriveData()
        }
        
        alert.addAction(botonAlert)
        self.present(alert, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let actionDelete = UIContextualAction(style: .destructive, title: "Eliminar") { action, view, completionHandler in
            let productoEliminar = self.productosVenta![indexPath.row]
            self.context.delete(productoEliminar)
            try! self.context.save()
            
            self.retriveData()
            
        }
        
        return UISwipeActionsConfiguration(actions: [actionDelete])
    }
    
    
}
