//
//  TableViewCell.swift
//  iOS2_Note_0.2(UIKit)
//
//  Created by Illia Wezarino on 06.02.2023.
//

import UIKit

class TableViewCell: UITableViewCell {

    static let identifier = "CustomCell"
    var titleOfNote = UILabel()
    var subtitleOfNote = UILabel()
    var locationLabel = UILabel()
    var dateOfNote = UILabel()
   
   override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
       super.init(style: style, reuseIdentifier: reuseIdentifier)
       setupCell()
   }
   
   required init?(coder: NSCoder) {
       super.init(coder: coder)
       fatalError("init(coder:) has not been implemented")
   }
   
   override func layoutSubviews() {
       super.layoutSubviews()
       setupLabel()
   }
   
}

extension TableViewCell {

   private func setupCell() {
       titleOfNote.font = UIFont.systemFont(ofSize: 18, weight: .bold)
       titleOfNote.textColor = #colorLiteral(red: 0.2, green: 0.6745720163, blue: 0.8588235294, alpha: 1)
       contentView.addSubview(titleOfNote)
       
       subtitleOfNote.font = UIFont.systemFont(ofSize: 17)
       subtitleOfNote.textColor = #colorLiteral(red: 0.4756370187, green: 0.4756369591, blue: 0.4756369591, alpha: 1)
       contentView.addSubview(subtitleOfNote)
       
       dateOfNote.font = UIFont.systemFont(ofSize: 14)
       dateOfNote.textColor = #colorLiteral(red: 0.4797647595, green: 0.4727987051, blue: 0.4989501834, alpha: 1)
       contentView.addSubview(dateOfNote)

       locationLabel.font = UIFont.systemFont(ofSize: 14)
       locationLabel.textColor = #colorLiteral(red: 0.4797647595, green: 0.4727987051, blue: 0.4989501834, alpha: 1)
       contentView.addSubview(locationLabel)
   }

   private func setupLabel() {
       titleOfNote.frame = CGRect(x: 30,
                                  y: 5,
                                  width: contentView.bounds.width - 40,
                                  height: contentView.bounds.height - 60)
       subtitleOfNote.frame = CGRect(x: 30,
                                     y: 30,
                                     width: contentView.bounds.width - 50,
                                     height: contentView.bounds.height - 60)
       dateOfNote.frame = CGRect(x: 30,
                                 y: 53,
                                 width: contentView.bounds.width - 50,
                                 height: contentView.bounds.height - 60)
       locationLabel.frame = CGRect(x: 30,
                                    y: 75,
                                    width: contentView.bounds.width - 50,
                                    height: contentView.bounds.height - 60)
   }
}
