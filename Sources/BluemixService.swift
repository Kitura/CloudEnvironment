import Foundation


public enum BluemixServiceType {
    case cloudant
    case mongodb
    case redis
    case postgresql
    case other
}

public struct BluemixService {

    var host        : String?
    var username    : String?
    var password    : String?
    var type        : BluemixServiceType?
    var database    : String?
    var port        : Int?
    var url         : String?
    var certificate : String?

}
