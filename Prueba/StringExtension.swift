//
// DateExtension.swift
//  Prueba
//
//  Created by Joel Ramírez on 19/02/23.
//

import Foundation

extension String {
    func convertIntoDateFormated(fromFormat: String? = "yyyy-MM-dd'T'HH:mm:ss", toFormat: String) -> String? {
        
        let dateFormatter = DateFormatter()
        //dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let lc = /*UserDefaults.standard.string(forKey: "AppleLanguage") ??*/ "es_MX"
        dateFormatter.locale = Locale(identifier: lc)
        dateFormatter.dateFormat = fromFormat
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        guard let date = dateFormatter.date(from: self) else { return nil }
        let today = Calendar.current.isDateInToday(date)
        
        dateFormatter.locale = Locale(identifier: lc)
        dateFormatter.dateFormat =  (today) ? "HH:mm" : toFormat
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: date).capitalized
    }
}
