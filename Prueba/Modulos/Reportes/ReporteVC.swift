//
//  ReporteVC.swift
//  Prueba
//
//  Created by Jimena Reyes Reyes on 20/02/23.
//

import Foundation
import UIKit

class ReporteVC: UIViewController {
    
    @IBOutlet weak var tableReport: UITableView!
    @IBOutlet weak var totalLbl: UILabel!
    
    static var granTotal = 0
    //Referencia al Managed object context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //Cambiar a variable de tipo Producto sin datos iniciales
    private var reporte: [ReporteVentas]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUP()
        retriveData()
    }
    
    
    //MARK: - FUNCTIONS
    private func setUP () {
        tableReport.register(UINib(nibName: "CompraCell", bundle: nil), forCellReuseIdentifier: "buyCell")
        tableReport.dataSource = self
        tableReport.delegate = self
    }
    
    //Recuperar datos de BD
    private func retriveData () {
        do {
            self.reporte = try context.fetch(ReporteVentas.fetchRequest())
            DispatchQueue.main.async {
                self.tableReport.reloadData()
                self.totalLbl.text = "Total de ventas: \(ReporteVC.granTotal)"
            }
            
        } catch {
            print("Error al cargar los datos")
        }
    }
    
    @IBAction func reporteAction(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}

extension ReporteVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        reporte?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "buyCell") as! CompraCell
        cell.lblClave.text = "Clave: \(reporte?[indexPath.row].claveVenta ?? "Clave dum")"
        cell.lblNaem.text = "producto: \(reporte?[indexPath.row].nombreProducto ?? "Nombre dum")"
       
        cell.totalLbl.text = "Total: \(reporte?[indexPath.row].total ?? 0)"
        
        ReporteVC.granTotal += Int(reporte?[indexPath.row].total ?? 0)
        cell.lblCantidad.isHidden = true
        cell.dateLbl.isHidden = true
        cell.lblPrecio.isHidden = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let actionDelete = UIContextualAction(style: .destructive, title: "Eliminar") { action, view, completionHandler in
            let productoEliminar = self.reporte![indexPath.row]
            self.context.delete(productoEliminar)
            try! self.context.save()
            
            self.retriveData()
            
        }
        
        return UISwipeActionsConfiguration(actions: [actionDelete])
    }
    
    
}
