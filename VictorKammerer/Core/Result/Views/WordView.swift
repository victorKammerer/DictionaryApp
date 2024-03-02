//
//  WordView.swift
//  VictorKammerer
//
//  Created by Victor Kammerer on 04/02/24.
//

import SwiftUI
import AVKit

struct ResultView: View {
    
    let word: Word
    @StateObject private var vm: ResultViewModel
    @Binding var searchedWord: String
    @Binding var isVisible: Bool
    @State private var audioPressed = false
    @Environment(\.dismiss) private var dismiss
    @State private var isSearchPresented = false
    @State private var isResultPresented = true
    
    init(word: Word, searchedWord: Binding<String>, isVisible: Binding<Bool>) {
        self.word = word
        self._searchedWord = searchedWord
        self._vm = StateObject(wrappedValue: ResultViewModel(word: word))
        self._isVisible = isVisible
    }
    
    var body: some View {
        VStack (spacing: 20) {
            HStack {
                resultHeader
                Spacer()
            }
            
            ScrollView{
                
                resultContent
                
            }.scrollIndicators(.hidden)
            
            resultBottom
            
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    let genericWord = Word(word: "education", phonetics: [Phonetic(text: "/ˌedʒuˈkeɪʃn/", audio: "oi")], meanings: [Meaning(partOfSpeech: "uncountable, countable", definitions: [Definition(definition: "A process of teaching, training and learning, especially in schools, colleges or universities, to improve knowledge and develop skills", example: "oi")]), Meaning(partOfSpeech: "noun", definitions: [Definition(definition: "aaaaaaaa", example: "oi")])])
    return ResultView(word: genericWord, searchedWord: .constant(""), isVisible: .constant(true))
}

extension ResultView {
    
    var resultHeader: some View {
        VStack (alignment: .leading, spacing: 13) {
            Text(word.word.capitalized)
                .font(.system(size: 45, weight: .bold, design: .rounded))
                .foregroundStyle(Color.theme.black)
            
            HStack (spacing: 11) {
                AudioButtonView()
                    .onTapGesture {
                        audioPressed.toggle()
                        vm.playAudio()
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            withAnimation {
                                audioPressed = false
                            }
                        }
                    }
                
                
                Text(vm.phoneticText() ?? "")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.theme.black.opacity(0.4))
            }
        }
    }
    
    var resultContent: some View {
        VStack(spacing: 30) {
            ForEach(word.meanings.indices, id: \.self) { index in
                let meaning = word.meanings[index]
                VStack(alignment: .leading) {
                    HStack {
                        if let initialDef = meaning.definitions.first {
                            
                            Text("\(Text("\(index + 1))").foregroundStyle(Color.theme.black)) \(Text("[\(meaning.partOfSpeech)] ").foregroundStyle(Color.theme.black.opacity(0.5))) \(Text("\(initialDef.definition)").foregroundStyle(Color.theme.black)) ")
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .textCase(.lowercase)
                        }
                        Spacer()
                    }.padding(.vertical	)
                    
                    ForEach(meaning.definitions.dropFirst(), id: \.self) { definition in
                        Text("• \(definition.definition)")
                            .font(.system(size: 16, weight: .regular, design: .rounded))
                            .foregroundColor(Color.theme.black)
                    }
                }
            }
        }
    }
    
    var resultBottom: some View {
        VStack(alignment: .center) {
            Divider()
            
            HStack {
                Text("That’s it for “\(word.word)”!")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(Color.theme.black)
                Spacer()
            }.padding(.top, 35.5)
            
            HStack {
                Text("Try another search now!")
                    .font(.system(size: 16, weight: .regular, design: .rounded))
                    .foregroundColor(Color.theme.black)
                Spacer()
            }.padding(.bottom, 20)
            
            RectangleButtonView(buttonText: "NEW SEARCH") {
                DispatchQueue.main.async {
                    self.searchedWord = ""
                    isVisible = false
                }
                
            }
        }.padding(.vertical)
    }
}
