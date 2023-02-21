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
    var setCantidad = false
    var cantidadTotal = 1
    var ventaCantidad = 0
    
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
                self.TotalVentasLbl.text = "Gran Total: \(self.cantidadTotal)"
            }
            ReporteVC.granTotal = cantidadTotal
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
        let total: Double =  Double((self.ventaCantidad)) * ((productosVenta?[indexPath.row].precioVenta ?? 0))
        let date = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "YY/MM/dd"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "buyCell") as! CompraCell
        cell.lblClave.text = "Clave: \(productosVenta?[indexPath.row].claveProduct ?? "Clave dum")"
        cell.lblNaem.text = "producto: \(productosVenta?[indexPath.row].nombreProduct ?? "Nombre dum")"
      
        cell.lblPrecio.text = "Precio: \(productosVenta?[indexPath.row].precioVenta ?? 0)"
        cell.dateLbl.text = "Fecha: \(dateFormat.string(from:  date))"
        //productos?[indexPath.row].fecha ??
        if setCantidad == true {
            cell.lblCantidad.isHidden = false
            cell.lblCantidad.text = "Cantidad: \(self.ventaCantidad)"
            cell.totalLbl.isHidden = false
            cell.totalLbl.text = "Total de Articulo: \(total)"
        }else{
            cell.lblCantidad.isHidden = true
            cell.totalLbl.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Cantidad a vender", message: "Ingrese la cantidad de producto a vender", preferredStyle: .alert)
        alert.addTextField()
        let botonAlert = UIAlertAction(title: "Cantidad", style: .default) { (action) in
            
            let textField = alert.textFields![0]
            let cantidad = Int64(textField.text ?? "0")
            self.setCantidad = true
           
            if cantidad ?? 0 > self.productosVenta?[indexPath.row].cantidadProduct ?? 1 {
                self.errorMessage = "ERROR: Necesitas dar de alta más \(self.productosVenta?[indexPath.row].nombreProduct ?? "Producto seleccionado")"
                self.performSegue(withIdentifier: "errorSegue", sender: nil)
            } else {
                self.cantidadTotal += Int(self.productosVenta?[indexPath.row].precioVenta ?? 0)
                let nuevaVenta = ReporteVentas(context: self.context)
                nuevaVenta.nombreProducto = self.productosVenta?[indexPath.row].nombreProduct
                nuevaVenta.totalVentas = Double(self.cantidadTotal)
                nuevaVenta.claveVenta = self.productosVenta?[indexPath.row].claveProduct
                nuevaVenta.total = Double(self.ventaCantidad)
                nuevaVenta.cantidadVenta = self.productosVenta?[indexPath.row].cantidadProduct ?? 0
                
                let nuevoStock = (self.productosVenta?[indexPath.row].cantidadProduct ?? 0) - (cantidad ?? 0)
                self.ventaCantidad = Int(cantidad ?? 0)
                self.productosVenta?[indexPath.row].cantidadProduct = nuevoStock
                try! self.context.save()
                self.retriveData()
            }
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
