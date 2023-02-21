//
//  InventarioViewController.swift
//  Prueba
//
//  Created by Joel Ramírez on 17/02/23.
//
import Foundation
import UIKit
import CoreData

class InventarioViewController: UIViewController {

    
    @IBOutlet weak var tableInventario: UITableView!
    
    //Referencia al Managed object context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //Cambiar a variable de tipo Producto sin datos iniciales
    private var productos: [Producto]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "INVENTARIO"
        setUP()
        retriveData()
    }
    
    
    //MARK: - FUNCTIONS
    private func setUP () {
        tableInventario.register(UINib(nibName: "CompraCell", bundle: nil), forCellReuseIdentifier: "buyCell")
        tableInventario.dataSource = self
        tableInventario.delegate = self
    }
    
    //Recuperar datos de BD
    private func retriveData () {
        do {
            self.productos = try context.fetch(Producto.fetchRequest())
            DispatchQueue.main.async {
                self.tableInventario.reloadData()
            }
            
        } catch {
            print("Error al cargar los datos")
        }
    }
}

extension InventarioViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        productos?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let total: Double =  Double((productos?[indexPath.row].cantidadProduct ?? 0)) * ((productos?[indexPath.row].precioCompra ?? 0))
        let date = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "YY/MM/dd"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "buyCell") as! CompraCell
        cell.lblClave.text = "Clave: \(productos?[indexPath.row].claveProduct ?? "Clave dum")"
        cell.lblNaem.text = "producto: \(productos?[indexPath.row].nombreProduct ?? "Nombre dum")"
        cell.lblCantidad.text = "Cantidad: \(productos?[indexPath.row].cantidadProduct ?? 0)"
        cell.lblPrecio.text = "Precio: \(productos?[indexPath.row].precioCompra ?? 0)"
        cell.dateLbl.text = "Fecha: \(dateFormat.string(from:  date))"
        //productos?[indexPath.row].fecha ??
        cell.totalLbl.text = "Total: \(total)"
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let actionDelete = UIContextualAction(style: .destructive, title: "Eliminar") { action, view, completionHandler in
            let productoEliminar = self.productos![indexPath.row]
            self.context.delete(productoEliminar)
            try! self.context.save()
            
            self.retriveData()
            
        }
        
        return UISwipeActionsConfiguration(actions: [actionDelete])
    }
    
    
}
