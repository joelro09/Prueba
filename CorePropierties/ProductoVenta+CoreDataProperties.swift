//
//  ProductoVenta+CoreDataProperties.swift
//  Prueba
//
//  Created by Jimena Reyes Reyes on 19/02/23.
//
//

import Foundation
import CoreData


extension ProductoVenta {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductoVenta> {
        return NSFetchRequest<ProductoVenta>(entityName: "ProductoVenta")
    }

    @NSManaged public var claveProduct: String?
    @NSManaged public var nombreProduct: String?
    @NSManaged public var cantidadProduct: Int64
    @NSManaged public var precioVenta: Double
    @NSManaged public var total: Double
    @NSManaged public var fecha: Date?

}

extension ProductoVenta : Identifiable {

}
