import Foundation


public enum BluemixServiceType {
    case cloudant
    case mongodb
    case redis
    case postgresql
    case other
}

public protocol BluemixService {
    
    var label    : String { get }
    var name     : String { get }
    var tags     : [String] { get }
}

public struct CloudantService: BluemixService {
    
    public var host        : String
    public var username    : String
    public var password    : String
    public var port        : Int
    public var url         : String
    
    public var label   : String = "cloudantNoSQLDB"
    public var name    : String = ""
    public var tags    : [String] = []
    
}
