//
//  tempDatas.swift
//  NEMS
//
//  Created by User on 4/26/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

class LocalData {
    static let shared = LocalData()
    //google map api key: AIzaSyAsiyeO2Zws6WAUOc6YkoL8Nv3g4M-C6FM
    
    let json = """
    {
        "Location":[
        {"name":"1520 Stockton St S.F",
        "address":"1520 Stockton Street",
        "city":"San Francisco",
        "state":"CA",
        "zip":"94133",
        "phone":"415-391-9686",
        "clinicHours":"",
        "pharmacyHours":"",
        "description":"Address \\n1520 Stockton Street \\nSan Francisco, CA 94133 \\nPhone: 415-391-9686\\n\\nTransportation\\nSF MUNI Bus Lines: 8, 8AX, 8BX, 10, 12, 30, 39, 41, 45 Buses \\n\\nClinic Hours \\nMon - Fri 8:00 AM - 6:00 PM \\nSat 8:30 AM - 12:00 PM, 1:00 PM - 5:00 PM \\nClosed Sun \\n\\nPharmacy Hours \\nMon - Fri 8:00 AM - 6:00 PM \\nSat 8:30 AM - 12:00 PM, 1:00 PM - 5:00 PM\\nClosed Sun \\n",
        "image":"locationsStockton",
        "latitude":"37.799934",
        "longitude":"-122.408724"
        },
        {"name":"728 Pacific Avenue, 2nd Floor",
        "address":"728 Pacific Avenue, 2nd Floor",
        "city":"San Francisco",
        "state":"CA",
        "zip":"94133",
        "phone":"415-391-9686",
        "clinicHours":"",
        "pharmacyHours":"",
        "description":"Address \\n728 Pacific Avenue, 2nd Floor \\nSan Francisco, CA 94133 \\nPhone: 415-391-9686 \\n\\nTransportation\\nSF MUNI Bus Lines: 8X, 8AX, 8BX, 10, 12, 30, 45 Buses \\n\\nClinic Hours \\nMon, Tue, Wed, Fri \\n8:30 - 12:00 and 1:00 - 5:00 \\nClosed Thu, Sat and Sun",
        "transportation":"SF MUNI Bus Lines: 8X, 8AX, 8BX, 10, 12, 30, 45 Buses",
        "image":"locationsPacific",
        "latitude":"37.7968603",
        "longitude":"-122.407556"
        }
        ]
    }
    """.data(using: .utf8)!
       
}
