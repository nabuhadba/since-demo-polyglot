import UIKit

/// The card at the bottom of the driver app's map: next stop, address, and the scan button.
public final class StopCardView: UIView {
    private let titleLabel = UILabel()
    private let addressLabel = UILabel()
    public let scanButton = UIButton(type: .system)

    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 16
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        addressLabel.font = .preferredFont(forTextStyle: .subheadline)
        addressLabel.numberOfLines = 2
        scanButton.setTitle("Scan package", for: .normal)

        let stack = UIStackView(arrangedSubviews: [titleLabel, addressLabel, scanButton])
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) is not used") }

    public func show(_ stop: RoutePackage.Stop) {
        titleLabel.text = "Stop \(stop.sequence) · \(stop.shipmentID)"
        addressLabel.text = stop.address
    }
}
