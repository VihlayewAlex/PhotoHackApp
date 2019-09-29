//
//  NLPService.swift
//  PhotoHackApp
//
//  Created by Yaroslav Zarechnyy on 9/29/19.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation
import NaturalLanguage

class NLPService {

    static let shared = NLPService()
    
    private init() {}
    
    fileprivate func getNames(_ text: String) -> [String] {
        let tagger = NSLinguisticTagger(tagSchemes:[.tokenType, .language, .lexicalClass, .nameType, .lemma], options: 0)
        let options: NSLinguisticTagger.Options = [.omitPunctuation, .omitWhitespace, .joinNames]
        
        tagger.string = text
        
        let range = NSRange(location: 0, length: text.utf16.count)
        var locationList = [String]()
        let tags: [NSLinguisticTag] = [.placeName]
        if let lang = tagger.dominantLanguage {
            if lang == "und" {
                let orthography = NSOrthography.defaultOrthography(forLanguage: "ru")
                tagger.setOrthography(orthography, range: range)
                
//                POStagger.setLanguage(NLLanguage(rawValue: "ru"), range: range)
            }
        }
        tagger.enumerateTags(in: range, unit: .word, scheme: .nameType, options: options) { tag, tokenRange, stop in
            if let tag = tag, tags.contains(tag) {
                let name = (text as NSString).substring(with: tokenRange)
                locationList.append(name)
            }
        }
        return locationList
    }
    
    fileprivate func getVerbs(_ text: String) -> [String] {
        
        var verbs = [String]()
        let tagger = NSLinguisticTagger(tagSchemes:[.tokenType, .language, .lexicalClass, .nameType, .lemma], options: 0)
        let options: NSLinguisticTagger.Options = [.omitPunctuation, .omitWhitespace, .joinNames]
        
        tagger.string = text
        let range = NSRange(location: 0, length: text.utf16.count)

        tagger.enumerateTags(in: range, unit: .word, scheme: .lexicalClass, options: options) { tag, tokenRange, _ in
            if let tag = tag {
                let word = (text as NSString).substring(with: tokenRange)
                if tag.rawValue == "Verb" {
                    verbs.append(word)
                }
            }
        }
        return verbs
    }
    
    fileprivate func getNouns(_ text: String) -> [String] {
        
        var nouns = [String]()
        let tagger = NSLinguisticTagger(tagSchemes:[.tokenType, .language, .lexicalClass, .nameType, .lemma], options: 0)
        let options: NSLinguisticTagger.Options = [.omitPunctuation, .omitWhitespace, .joinNames]
        
        tagger.string = text
        let range = NSRange(location: 0, length: text.utf16.count)
        
        tagger.enumerateTags(in: range, unit: .word, scheme: .lexicalClass, options: options) { tag, tokenRange, _ in
            if let tag = tag {
                let word = (text as NSString).substring(with: tokenRange)
                if tag.rawValue == "Noun" {
                    nouns.append(word)
                }
            }
        }
        return nouns
    }

    func getKeyWords(_ text: String) -> [String] {
        
        let names = getNames(text)
        let nouns = getNouns(text)
        let verbs = getVerbs(text)
        
        var wordsToReturn = [String]()
        if names.count != 0 {
            wordsToReturn.append(contentsOf: names)
        }
        
        if nouns.count != 0 {
            wordsToReturn.append(contentsOf: nouns)
        }
        
        if verbs.count != 0 {
            wordsToReturn.append(contentsOf: verbs)
        }
       
        return wordsToReturn
    }
}
