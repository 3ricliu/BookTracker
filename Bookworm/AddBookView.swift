//
//  AddBookView.swift
//  Bookworm
//
//  Created by Eric Liu on 11/5/20.
//

import SwiftUI

struct AddBookView: View {
  @Environment(\.managedObjectContext) var moc
  @Environment(\.presentationMode) var presentationMode
  
  @State private var title = ""
  @State private var author = ""
  @State private var rating = 3
  @State private var genreType = 0
  @State private var review = ""
  
  let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller"]
  
  var body: some View {
    NavigationView {
      Form {
        Section {
          TextField("Name of Book", text: $title)
          TextField("Author's name", text: $author)
          
          Picker("Genre", selection: $genreType) {
            ForEach(0..<genres.count) {number in
              Text(genres[number])
            }
          }
        }
        
        RatingView(rating: $rating)
        TextField("Write a review", text: $review)
        
        Section {
          Button("Save") {
            let newBook = Book(context: self.moc)
            newBook.title = self.title
            newBook.author = self.author
            newBook.rating = Int16(self.rating)
            newBook.genre = self.genres[self.genreType]
            newBook.review = self.review
            
            try? self.moc.save()
            self.presentationMode.wrappedValue.dismiss()
          }
        }
      }
      .navigationBarTitle("Add Book")
    }
  }
}

struct AddBookView_Previews: PreviewProvider {
  static var previews: some View {
    AddBookView()
  }
}
