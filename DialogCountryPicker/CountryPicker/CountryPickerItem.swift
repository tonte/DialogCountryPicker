import Foundation

internal class CountryPickerItem: NSObject{
    @objc var name: String = ""
    var flag: String = ""
    @objc var dialCode: String = ""
    var countryCode: String = ""
    
    init(
        name: String,
        flag: String,
        dialCode: String,
        countryCode: String
    ) {
        self.name = name
        self.flag = flag
        self.dialCode = dialCode
        self.countryCode = countryCode
    }
}
