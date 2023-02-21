//
//  ReporteVentas+CoreDataProperties.swift
//  Prueba
//
//  Created by Jimena Reyes Reyes on 20/02/23.
//
//

import Foundation
import CoreData


extension ReporteVentas {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ReporteVentas> {
        return NSFetchRequest<ReporteVentas>(entityName: "ReporteVentas")
    }

    @NSManaged public var claveVenta: String?
    @NSManaged public var nombreProducto: String?
    @NSManaged public var cantidadVenta: Int64
    @NSManaged public var total: Double
    @NSManaged public var totalVentas: Double

}

extension ReporteVentas : Identifiable {

}
