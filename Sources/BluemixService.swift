import Foundation


public enum BluemixServiceType {
    case cloudant
    case mongodb
    case other
}

public struct BluemixService {

    var host        : String?
    var username    : String?
    var password    : String?
    var type        : BluemixServiceType?
    var database    : String?
    var port        : Int?
    var uri         : String?
        
}
