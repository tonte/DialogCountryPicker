import Foundation
internal class CountryPickerViewModel {
    func fetchCountryList(
        _ filteredCountryList: [String]
    ) -> [CountryPickerItem] {
        var countries: [CountryPickerItem] = []
        let locale = Locale.current
        let CallingCodes = { () -> [[String: String]] in
            let resourceBundle = Bundle(for: CountryPickerViewController.classForCoder())
            guard let path = resourceBundle.path(forResource: "CallingCodes", ofType: "plist") else { return [] }
            return NSArray(contentsOfFile: path) as! [[String: String]]
        }()

        var availableCountryCodes: [String] = []
        if filteredCountryList.isEmpty {
            availableCountryCodes = Locale.isoRegionCodes
        } else {
            availableCountryCodes = Locale.isoRegionCodes.filter { filteredCountryList.map{ $0.lowercased() }.contains($0.lowercased()) }
        }
        for countryCode in availableCountryCodes {
            let displayName = (locale as NSLocale).displayName(forKey: NSLocale.Key.countryCode, value: countryCode)
            let countryData = CallingCodes.filter { $0["code"] == countryCode }
            if countryData.count > 0, let dialCode = countryData[0]["dial_code"] {
                let country = CountryPickerItem(
                    name: displayName!,
                    flag: countryCode.lowercased(),
                    dialCode: dialCode,
                    countryCode: countryCode
                )
                countries.append(country)
            }
        }
        return countries
    }
}
