import UIKit

internal class CountryTableViewCell: UITableViewCell {
    static let identifier = "DialogCountryPickerTableViewCell"
    private var flagView: UIImageView!
    private var nameLabel: UILabel!
    private var dialCodeLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        createViews()
    }

    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        createViews()
    }

    func createViews() {
        initializeView()
        addConstraints()
    }

    func setup(flag: String, name: String, dialCode: String){
        let bundle = Bundle(for: CountryPickerViewController.classForCoder())
        flagView.image = UIImage(
            named: flag,
            in: bundle,
            compatibleWith: nil
        )
        nameLabel.text = name
        dialCodeLabel.text = dialCode
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

extension CountryTableViewCell {
    func initializeView() {
        translatesAutoresizingMaskIntoConstraints = false
        flagView = .init()
        flagView.translatesAutoresizingMaskIntoConstraints = false
        flagView.contentMode = .scaleAspectFit
        addSubview(flagView)

        nameLabel = .init()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = .regular(size: 14)
        nameLabel.lineBreakMode = .byTruncatingTail
        nameLabel.textColor = .primaryDark
        nameLabel.setContentHuggingPriority(
            .init(rawValue: 251),
            for: .horizontal
        )
        addSubview(nameLabel)

        dialCodeLabel = .init()
        dialCodeLabel.textColor = .primaryDark
        dialCodeLabel.translatesAutoresizingMaskIntoConstraints = false
        dialCodeLabel.font = .regular(size: 14)
        dialCodeLabel.setContentHuggingPriority(
            .init(rawValue: 251),
            for: .horizontal
        )
        addSubview(dialCodeLabel)

    }

    func addConstraints() {
        NSLayoutConstraint.activate([
            flagView.leftAnchor.constraint(equalTo: leftAnchor),
            flagView.widthAnchor.constraint(equalToConstant: 24.0),
            flagView.heightAnchor.constraint(equalToConstant: 16.0),
            flagView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(
                equalTo: flagView.trailingAnchor,
                constant: 10
            ),
            nameLabel.trailingAnchor.constraint(
                greaterThanOrEqualTo: dialCodeLabel.leadingAnchor,
                constant: -20
            ),
            nameLabel.topAnchor.constraint(
                greaterThanOrEqualTo: topAnchor,
                constant: 2
            ),
            nameLabel.bottomAnchor.constraint(
                lessThanOrEqualTo: bottomAnchor,
                constant: 2
            ),
            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        NSLayoutConstraint.activate([
            dialCodeLabel.trailingAnchor.constraint(
                equalTo: trailingAnchor, constant: -10
            ),
            dialCodeLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            dialCodeLabel.leadingAnchor.constraint(
                greaterThanOrEqualTo: nameLabel.trailingAnchor,
                constant: 20
            )
        ])
    }
}

