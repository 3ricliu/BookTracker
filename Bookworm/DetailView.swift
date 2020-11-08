//
//  DetailView.swift
//  Bookworm
//
//  Created by Eric Liu on 11/6/20.
//

import SwiftUI
import CoreData

struct DetailView: View {
  let book: Book
  
  @Environment(\.managedObjectContext) var moc
  @Environment(\.presentationMode)var presentationMode
  @State private var showingDeleteAlert = false
  
  var body: some View {
    GeometryReader { geometry in
      VStack {
        ZStack(alignment: .bottomTrailing) {
          Image(self.book.genre ?? "Random")
            .frame(maxWidth: geometry.size.width)
          
          Text(self.book.genre?.uppercased() ?? "FANTASY")
            .font(.caption)
            .fontWeight(.black)
            .padding(8)
            .foregroundColor(.white)
            .background(Color.black.opacity(0.75))
            .clipShape(Capsule())
            .offset(x: -5, y: -5)
        }
        
        Text(self.book.author ?? "Unknown author")
          .font(.title)
          .foregroundColor(.secondary)
        
        Text("Finished: \(getDate())")
          .font(.caption)
          .foregroundColor(.secondary)
          
        
        Text(self.book.review ?? "No Review")
          .padding()
        
        RatingView(rating: .constant(Int(self.book.rating)))

        Spacer()
      }
    }
    .navigationBarTitle(Text(book.title ?? "Unknown Book"), displayMode: .inline)
    .alert(isPresented: $showingDeleteAlert) {:
      Alert(title: Text("Delete Book"), message: Text("Are you sure?"), primaryButton: .destructive(Text("Delete")) {
        self.deleteBook()
      }, secondaryButton: .cancel())
    }
    .navigationBarItems(trailing: Button(action: {
      self.showingDeleteAlert = true
    }) {
      Image(systemName: "trash")
    })
  }
  
  func deleteBook() {
    moc.delete(book)
    presentationMode.wrappedValue.dismiss()
  }
  
  func getDate() -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    return formatter.string(from: self.book.date ?? Date())
  }
}


struct DetailView_Previews: PreviewProvider {
  
  static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
  static var previews: some View {
    let book = Book(context: moc)
    book.title = "Test book"
    book.author = "Test author"
    book.genre = "Fantasy"
    book.rating = 4
    book.review = "This was a great book!"
    book.date = Date()
    return NavigationView {
      DetailView(book: book)
    }
  }
}
