//
//  CompraCell.swift
//  Prueba
//
//  Created by Jimena Reyes Reyes on 18/02/23.
//

import UIKit

class CompraCell: UITableViewCell {
    
    @IBOutlet weak var lblClave: UILabel!
    @IBOutlet weak var lblNaem: UILabel!
    @IBOutlet weak var lblPrecio: UILabel!
    @IBOutlet weak var lblCantidad: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var totalLbl: UILabel!
    @IBOutlet weak var altaLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
