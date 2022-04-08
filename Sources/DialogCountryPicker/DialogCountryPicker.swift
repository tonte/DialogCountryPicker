import Foundation
import UIKit

open class DialogCountryPicker{

    public init() {}

    public func show(
        filteredCountries: [String] = [],
        showDialCode: Bool = true,
        viewControllerToPresentOn: UIViewController,
        onCountrySelectAction: ((String, String, String, UIImage) -> Void)?
    ) {
        let dialogCountryPicker = CountryPickerViewController()
        dialogCountryPicker.setup(filteredCountries: filteredCountries, showDialCode: showDialCode, onSelectAction: onCountrySelectAction)
        viewControllerToPresentOn.present(dialogCountryPicker, animated: true, completion: nil)
    }
    
}
