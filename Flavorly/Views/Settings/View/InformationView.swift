//
//  InformationView.swift
//  Flavourly
//
//  Created by Timea Bartha on 15/5/25.
//

import SwiftUI

struct InformationView: View {
    @Environment(\.presentationMode) var presentationMode
        @EnvironmentObject var themeManager: ThemeManager

        var body: some View {
            ZStack {
                themeManager.currentTheme.appBackgroundColor.edgesIgnoringSafeArea(.all)
                ScrollView {
                    VStack(alignment: .leading, spacing: 25) {
                        InfoBoxContainer {
                            SectionTitle("about.flavourly")
                            InfoPoint(
                                icon: "info.circle",
                                text: LocalizedStringKey("about.one")
                            )
                            InfoPoint(
                                icon: "lock.shield",
                                text: LocalizedStringKey("about.two")
                            )
                            InfoPoint(
                                icon: "book",
                                text: LocalizedStringKey("about.three")
                            )
                            InfoPoint(
                                icon: "globe",
                                text: LocalizedStringKey("about.four")
                            )
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical)
                    .padding(.bottom, 50)
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("about.flavourly.one")
                            .foregroundColor(themeManager.currentTheme.viewTitleColor)
                            .font(.title2)
                            .bold()
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            HStack {
                                Image(systemName: "chevron.left").bold()
                                    .font(.system(size: 13))
                                    .foregroundColor(themeManager.currentTheme.addButtonColor)
                            }
                        }
                    }
                }
            }
        }
    }
