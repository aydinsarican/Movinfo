//
//  MoviesTableViewCell.swift
//  Movinfo
//
//  Created by Aydn on 3.10.2019.
//  Copyright © 2019 aydinsarican. All rights reserved.
//

import UIKit
import SDWebImage

class MoviesTableViewCell: UITableViewCell {

    @IBOutlet var posterImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var yearLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCell(with info: Movie){
        let activityView = UIActivityIndicatorView()
        activityView.style = .medium
        
        posterImageView.image = UIImage()
        posterImageView.clipsToBounds = true
        posterImageView.addSubview(activityView)
        posterImageView.layer.cornerRadius = 5
        posterImageView.sd_setImage(with: URL(string: info.poster!), placeholderImage: UIImage(named: "posterPlaceholder.png"))
        posterImageView.contentMode = .scaleAspectFill
        
        nameLabel.numberOfLines = 0
        nameLabel.lineBreakMode = .byWordWrapping
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor = 0.8
        nameLabel.text = info.title
        
        yearLabel.numberOfLines = 1
        yearLabel.textColor = UIColor.gray
        yearLabel.text = info.year!
        
        typeLabel.numberOfLines = 1
        typeLabel.text = info.type!.capitalized
        typeLabel.textColor = UIColor.lightGray
        

    }
    
}
