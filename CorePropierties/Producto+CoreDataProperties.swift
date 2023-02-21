//
//  Producto+CoreDataProperties.swift
//  Prueba
//
//  Created by Joel Ramírez on 15/02/23.
//
//

import Foundation
import CoreData


extension Producto {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Producto> {
        return NSFetchRequest<Producto>(entityName: "Producto")
    }
    @NSManaged public var nombreProduct: String?
    @NSManaged public var claveProduct: String
    @NSManaged public var cantidadProduct: Int64
    @NSManaged public var precioCompra: Double
    @NSManaged public var total: Double
    @NSManaged public var fecha: Date
    
    
    
    

}

extension Producto : Identifiable {

}
