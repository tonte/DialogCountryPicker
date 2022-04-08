import Foundation
import UIKit

internal protocol CountryPickerViewDelegate {
    func didSelectCountry(
        name: String,
        dialCode: String,
        countryCode: String,
        flag: UIImage
    )
}

internal class CountryPickerView: UIView {
    var mainView: UIView!
    var instructionLabel: UILabel!
    var searchTextField: UITextField!
    var separatorView: UIView!
    var countryTableView: UITableView!
    var countries: [CountryPickerItem] = []
    var filteredCountries: [CountryPickerItem] = []
    var showDialCode = true
    var delegate: CountryPickerViewDelegate?

    override public init(frame: CGRect) {
        super.init(frame: frame)
        initializeView()
        addConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(
        countries: [CountryPickerItem] = [],
        showDialCode: Bool = true,
        delegate: CountryPickerViewDelegate
    ) {
        self.countries = countries
        filteredCountries = countries
        self.delegate = delegate
        countryTableView.reloadData()
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let searchText = textField.text else { return }
        filterText(searchText: searchText)
    }

    func filterText(searchText: String){
        let searchResults = countries
        // Strip out all the leading and trailing spaces.
        let whitespaceCharacterSet = CharacterSet.whitespaces
        let strippedString = searchText.trimmingCharacters(in: whitespaceCharacterSet)
        let searchItems = strippedString.components(separatedBy: " ") as [String]

        // Build all the "AND" expressions for each value in the searchString.
        let andMatchPredicates: [NSPredicate] = searchItems.map { searchString in
            var searchItemsPredicate = [NSPredicate]()
            let titleExpression = NSExpression(forKeyPath: "name")
            let searchStringExpression = NSExpression(forConstantValue: searchString)
            let titleSearchComparisonPredicate = NSComparisonPredicate(leftExpression: titleExpression, rightExpression: searchStringExpression, modifier: .direct, type: .contains, options: .caseInsensitive)
            searchItemsPredicate.append(titleSearchComparisonPredicate)

            let serviceNameExpression = NSExpression(forKeyPath: "dialCode")
            let serviceNameSearchComparisonPredicate = NSComparisonPredicate(leftExpression: serviceNameExpression, rightExpression: searchStringExpression, modifier: .direct, type: .contains, options: .caseInsensitive)
            searchItemsPredicate.append(serviceNameSearchComparisonPredicate)

            let orMatchPredicate = NSCompoundPredicate(orPredicateWithSubpredicates:searchItemsPredicate)
            return orMatchPredicate
        }
        // Match up the fields of the Product object.
        let finalCompoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: andMatchPredicates)
        let filteredResults = searchResults.filter { finalCompoundPredicate.evaluate(with: $0) }

        if strippedString.isEmpty == false{
            filteredCountries = filteredResults
            countryTableView.allowsSelection = true
        }
        else{
            filteredCountries = countries
            countryTableView.allowsSelection = true
        }
        countryTableView.reloadData()
    }
}

extension CountryPickerView {
    private func initializeView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .secondaryDark

        mainView = .init()
        mainView.translatesAutoresizingMaskIntoConstraints = false
        mainView.backgroundColor = .white
        addSubview(mainView)

        instructionLabel = .init()
        instructionLabel.translatesAutoresizingMaskIntoConstraints = false
        instructionLabel.textColor = .primaryDark
        instructionLabel.font = .regular(size: 18)
        mainView.addSubview(instructionLabel)

        searchTextField = .init()
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.addTarget(
            self,
            action: #selector(textFieldDidChange),
            for: .editingChanged
        )
        searchTextField.font = .regular(size: 14)
        mainView.addSubview(searchTextField)

        separatorView = .init()
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = .lightGray
        mainView.addSubview(separatorView)

        countryTableView = .init()
        countryTableView.delegate = self
        countryTableView.dataSource = self
        countryTableView.separatorStyle = .none
        countryTableView.register(
            CountryTableViewCell.self,
            forCellReuseIdentifier: CountryTableViewCell.identifier
        )
        mainView.addSubview(countryTableView)
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            mainView.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 16
            ),
            mainView.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -16
            ),
            mainView.heightAnchor.constraint(equalTo: mainView.widthAnchor, multiplier: 343/510),
            mainView.centerYAnchor.constraint(equalTo: centerYAnchor),
            mainView.centerXAnchor.constraint(equalTo: centerXAnchor),
            mainView.topAnchor.constraint(
                greaterThanOrEqualTo: safeAreaLayoutGuide.topAnchor
            ),
            mainView.bottomAnchor.constraint(
                lessThanOrEqualTo: safeAreaLayoutGuide.bottomAnchor
            )
        ])

        NSLayoutConstraint.activate([
            instructionLabel.leadingAnchor.constraint(
                equalTo: mainView.leadingAnchor,
                constant: 26
            ),
            instructionLabel.topAnchor.constraint(
                equalTo: mainView.topAnchor,
                constant: 20
            ),
            instructionLabel.trailingAnchor.constraint(
                lessThanOrEqualTo: mainView.trailingAnchor,
                constant: 20
            )
        ])

        NSLayoutConstraint.activate([
            searchTextField.heightAnchor.constraint(equalToConstant: 26),
            searchTextField.topAnchor.constraint(
                equalTo: instructionLabel.bottomAnchor,
                constant: 10
            ),
            searchTextField.leadingAnchor.constraint(
                equalTo: mainView.leadingAnchor,
                constant: 26
            ),
            searchTextField.trailingAnchor.constraint(
                equalTo: mainView.trailingAnchor,
                constant: -26
            ),
        ])

        NSLayoutConstraint.activate([
            separatorView.heightAnchor.constraint(
                equalToConstant: 1
            ),
            separatorView.topAnchor.constraint(
                equalTo: searchTextField.bottomAnchor,
                constant: 10
            ),
            separatorView.leadingAnchor.constraint(
                equalTo: mainView.leadingAnchor,
                constant: 26
            ),
            separatorView.trailingAnchor.constraint(
                equalTo: mainView.trailingAnchor,
                constant: -26
            ),
        ])

        NSLayoutConstraint.activate([
            countryTableView.leadingAnchor.constraint(
                equalTo: mainView.leadingAnchor,
                constant: 26
            ),
            countryTableView.trailingAnchor.constraint(
                equalTo: mainView.trailingAnchor,
                constant: -26
            ),
            countryTableView.bottomAnchor.constraint(
                equalTo: mainView.bottomAnchor,
                constant: -10
            ),
            countryTableView.topAnchor.constraint(
                equalTo: separatorView.bottomAnchor,
                constant: 10
            )
        ])
    }
}

extension CountryPickerView: UITableViewDelegate, UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 42
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCountries.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CountryTableViewCell.identifier,
            for: indexPath
        ) as? CountryTableViewCell else {
            fatalError("UITableView must be downcasted to CountryTableViewCell")
        }
        let index = indexPath.row
        let country = filteredCountries[index]
        var dialCode = ""
        if(showDialCode) {
            dialCode = country.dialCode
        }
        cell.setup(
            flag: country.flag,
            name: country.name,
            dialCode: dialCode
        )
        return cell
    }

    public func tableView(
        _ tableView: UITableView,
        willSelectRowAt indexPath: IndexPath
    ) -> IndexPath? {
        let selectedCountryItem = filteredCountries[indexPath.row]
        let bundle = Bundle(for: CountryPickerViewController.classForCoder())
        let flag:UIImage? = UIImage(
            named: selectedCountryItem.flag,
            in: bundle, compatibleWith: nil
        )
        if let flagImage = flag {
            delegate?.didSelectCountry (
                name: selectedCountryItem.name,
                dialCode: selectedCountryItem.dialCode,
                countryCode: selectedCountryItem.countryCode,
                flag: flagImage
            )
        }
        return nil
    }
}

