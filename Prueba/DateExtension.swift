//
//  DateExtension.swift
//  Prueba
//
//  Created by Joel Ramírez on 19/02/23.
//

import Foundation

extension Date {
    func convertDateString() -> String {
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let myString = formatter.string(from: self) // string purpose I add here
        // convert your string to date
        let yourDate = formatter.date(from: myString)
        //then again set the date format whhich type of output you need
        formatter.dateFormat = "dd-MMM-yyyy"
        // again convert your date to string
        let myStringDate = formatter.string(from: yourDate!)

        return myStringDate
    }
}
