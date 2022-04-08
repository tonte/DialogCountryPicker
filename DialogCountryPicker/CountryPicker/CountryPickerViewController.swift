import Foundation
import UIKit

internal class CountryPickerViewController: UIViewController {
    var filteredCountries : [String] = []
    var showDialCode: Bool = true
    var onSelectAction: ((String, String, String, UIImage) -> Void)?
    let viewModel = CountryPickerViewModel()
    var countryPickerView = CountryPickerView()

    override func viewDidLoad() {
        self.createViews()
    }

    private func createViews() {
        initializeView()
        addConstraints()
    }

    func setup(
        filteredCountries : [String] = [],
        showDialCode: Bool = true,
        onSelectAction: ((String, String, String, UIImage) -> Void)?
    ) {
        self.filteredCountries = filteredCountries
        self.showDialCode = showDialCode
        self.onSelectAction = onSelectAction
        countryPickerView.setup(
            countries: viewModel.fetchCountryList(filteredCountries),
            showDialCode: showDialCode,
            delegate: self
        )
    }
}

extension CountryPickerViewController {
    func initializeView() {
        view.translatesAutoresizingMaskIntoConstraints = false
        countryPickerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(countryPickerView)
    }

    func addConstraints() {
        NSLayoutConstraint.activate([
            countryPickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            countryPickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            countryPickerView.topAnchor.constraint(equalTo: view.topAnchor),
            countryPickerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension CountryPickerViewController: CountryPickerViewDelegate {
    func didSelectCountry(
        name: String,
        dialCode: String,
        countryCode: String,
        flag: UIImage
    ) {
        onSelectAction?(name, dialCode, countryCode, flag)
    }


}
