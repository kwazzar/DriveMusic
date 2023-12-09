//
//  Library.swift
//  DriveMusic
//
//  Created by Quasar on 07.12.2023.
//

import SwiftUI
// MARK: - 1109
struct Library: View {
    var body: some View {
        NavigationStack {
            VStack {
                GeometryReader { geometry in
                    HStack(spacing: 20) {
                        Button {
                            print("12321325")
                        } label: {
                            Image(systemName: "play.fill")
                                .frame(width: geometry.size.width / 2 - 10, height: 50)
                                .tint(Color(hexValue: "#FD2D55"))
                                .background(Color.init(hexValue: "#D3D3D3"))
                                .cornerRadius(10)
                        }
                        Button {
                            print("1234567")

                        } label: {
                            Image(systemName: "arrow.2.circlepath")
                                .frame(width: geometry.size.width / 2 - 10, height: 50)
                                .tint(Color(hexValue: "#FD2D55"))
                                .background(Color.init(hexValue: "#D3D3D3"))
                                .cornerRadius(10)
                        }
                    }
                }.padding().frame(height: 60)
                Divider().padding(.leading).padding(.trailing)
                List {
                    LibraryCell()
                    Text("Second")
                    Text("Third")
                }
            }  .navigationTitle("Library")
        }
    }
}

struct LibraryCell: View {
    var body: some View {
        HStack {
            Image("Metz cover").resizable().frame(width: 50, height: 50).cornerRadius(5)
            HStack {
                Text("Track Name")
                Text("Artist Name")
            }
        }
    }
}

struct Library_Previews: PreviewProvider {
    static var previews: some View {
        Library()
    }
}
