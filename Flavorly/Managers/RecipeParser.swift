//
//  Untitled.swift
//  Flavourly
//
//  Created by Timea Bartha on 31/7/25.
//

import Foundation
import NaturalLanguage

struct ParsedRecipe {
    var title: String = ""
    var ingredients: [String] = []
    var instructions: [String] = []
}

class RecipeParser {
    private let ingredientTagger = NLTagger(tagSchemes: [.lexicalClass])
    private let measurementUnits = ["cup", "cups", "tsp", "tbsp", "oz", "g", "kg", "ml", "l", "lb", "pound", "pounds", "ounce", "ounces", "gram", "grams", "kilogram", "kilograms", "liter", "liters", "milliliter", "milliliters", "teaspoon", "teaspoons", "tablespoon", "tablespoons"]
    
    init() {
        // Initialize with empty string to set language for future text analysis
        let emptyString = ""
        ingredientTagger.string = emptyString
        ingredientTagger.setLanguage(.english, range: emptyString.startIndex..<emptyString.endIndex)
    }
    
    func parseRecipe(text: String) -> ParsedRecipe {
        var result = ParsedRecipe()
        let lines = text.components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        
        guard !lines.isEmpty else { return result }
        
        // Phase 1: Identify sections
        let sections = identifySections(lines: lines)
        
        // Phase 2: Parse each section
        if let titleSection = sections[.title] {
            result.title = parseTitle(lines: titleSection)
        }
        
        if let ingredientSection = sections[.ingredients] {
            result.ingredients = parseIngredients(lines: ingredientSection)
        }
        
        if let instructionSection = sections[.instruction] {
            result.instructions = parseInstructions(lines: instructionSection)
        }
        
        // Fallback if sections are empty
        if result.ingredients.isEmpty && result.instructions.isEmpty {
            let fallbackResult = fallbackParsing(lines: lines)
            if result.title.isEmpty {
                result.title = fallbackResult.title
            }
            result.ingredients = fallbackResult.ingredients
            result.instructions = fallbackResult.instructions
        }
        
        return result
    }
    
    private func identifySections(lines: [String]) -> [RecipeSection: [String]] {
        var sections = [RecipeSection: [String]]()
        var currentSection: RecipeSection = .unknown
        var foundFirstSection = false
        
        for line in lines {
            let lowerLine = line.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Check for section headers
            if lowerLine.contains("ingredient") || lowerLine.contains("what you need") || lowerLine.contains("shopping list") {
                currentSection = .ingredients
                foundFirstSection = true
                continue
            }
            
            if lowerLine.contains("instruction") || lowerLine.contains("direction") || lowerLine.contains("method") || lowerLine.contains("steps") || lowerLine.contains("preparation") {
                currentSection = .instruction
                foundFirstSection = true
                continue
            }
            
            // If we haven't found a section yet and this is not empty, it's likely a title
            if !foundFirstSection && !line.isEmpty && currentSection == .unknown {
                currentSection = .title
            }
            
            // Auto-detect section based on content if no explicit headers
            if currentSection == .unknown {
                if isLikelyIngredient(line) {
                    currentSection = .ingredients
                    foundFirstSection = true
                } else if isLikelyInstruction(line) {
                    currentSection = .instruction
                    foundFirstSection = true
                } else if sections[.title] == nil {
                    currentSection = .title
                }
            }
            
            if sections[currentSection] == nil {
                sections[currentSection] = []
            }
            
            sections[currentSection]?.append(line)
        }
        
        return sections
    }
    
    private func parseTitle(lines: [String]) -> String {
        return lines.first ?? "Imported Recipe"
    }
    
    private func parseIngredients(lines: [String]) -> [String] {
        return lines.compactMap { line in
            if isLikelyIngredient(line) {
                return cleanIngredientLine(line)
            }
            return nil
        }.filter { !$0.isEmpty }
    }
    
    private func isLikelyIngredient(_ text: String) -> Bool {
        let lowerText = text.lowercased()
        
        // Check for measurement units
        if measurementUnits.contains(where: { lowerText.contains($0) }) {
            return true
        }
        
        // Check for quantities (numbers or fractions)
        let quantityPattern = #"\d+([\/\.]\d+)?"#
        if text.range(of: quantityPattern, options: .regularExpression) != nil {
            return true
        }
        
        // NLP analysis
        ingredientTagger.string = text
        var hasNoun = false
        var hasMeasurement = false
        
        ingredientTagger.enumerateTags(in: text.startIndex..<text.endIndex,
                                     unit: .word,
                                     scheme: .lexicalClass,
                                     options: [.omitPunctuation, .omitWhitespace]) { tag, range in
            if tag == .noun {
                hasNoun = true
            }
            if measurementUnits.contains(String(text[range]).lowercased()) {
                hasMeasurement = true
            }
            return true
        }
        
        return hasNoun || hasMeasurement
    }
    
    private func isLikelyInstruction(_ text: String) -> Bool {
        let lowerText = text.lowercased()
        
        // Check if line starts with a number (step)
        if text.first?.isNumber == true {
            return true
        }
        
        // Contains action words
        let actionWords = ["mix", "stir", "bake", "cook", "heat", "add", "combine", "fold", "whisk", "beat", "chop", "dice", "slice", "melt", "boil", "simmer", "fry", "sauté", "roast", "grill", "blend", "pour", "serve", "garnish", "season", "taste", "adjust", "preheat", "remove", "drain", "cool", "chill", "refrigerate", "freeze", "place", "put", "set", "turn", "cover", "uncover"]
        
        return actionWords.contains(where: { lowerText.contains($0) })
    }
    
    private func parseInstructions(lines: [String]) -> [String] {
        var instructions = [String]()
        var currentInstruction = ""
        
        for line in lines {
            if line.isEmpty {
                continue
            }
            
            let cleanedLine = cleanInstructionLine(line)
            
            // Check if line starts with a number (step)
            if line.first?.isNumber == true || line.hasPrefix("Step") {
                if !currentInstruction.isEmpty {
                    instructions.append(currentInstruction.trimmingCharacters(in: .whitespacesAndNewlines))
                    currentInstruction = ""
                }
                currentInstruction = cleanedLine
            } else {
                // Continue current instruction or start new one
                if currentInstruction.isEmpty {
                    currentInstruction = cleanedLine
                } else {
                    currentInstruction += " " + cleanedLine
                }
            }
        }
        
        if !currentInstruction.isEmpty {
            instructions.append(currentInstruction.trimmingCharacters(in: .whitespacesAndNewlines))
        }
        
        return instructions.filter { !$0.isEmpty }
    }
    
    private func cleanIngredientLine(_ line: String) -> String {
        // Remove bullet points, dashes, numbers at start
        var cleaned = line.replacingOccurrences(of: "^[-•*\\d+.)\\s]+", with: "", options: .regularExpression)
        return cleaned.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private func cleanInstructionLine(_ line: String) -> String {
        // Remove step numbers at the beginning
        var cleaned = line.replacingOccurrences(of: "^(Step\\s*)?\\d+[.)\\s]+", with: "", options: .regularExpression)
        return cleaned.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    // Fallback parsing when section detection fails
    private func fallbackParsing(lines: [String]) -> ParsedRecipe {
        var result = ParsedRecipe()
        
        // Use first line as title
        result.title = lines.first ?? "Imported Recipe"
        
        // Try to separate ingredients from instructions based on content
        var ingredients = [String]()
        var instructions = [String]()
        var foundInstructionStart = false
        
        for (index, line) in lines.enumerated() {
            if index == 0 { continue } // Skip title
            
            if !foundInstructionStart && isLikelyIngredient(line) {
                ingredients.append(cleanIngredientLine(line))
            } else if isLikelyInstruction(line) {
                foundInstructionStart = true
                instructions.append(cleanInstructionLine(line))
            } else if foundInstructionStart {
                instructions.append(cleanInstructionLine(line))
            } else {
                // If unsure, add to ingredients if we haven't found instructions yet
                ingredients.append(cleanIngredientLine(line))
            }
        }
        
        result.ingredients = ingredients.filter { !$0.isEmpty }
        result.instructions = instructions.filter { !$0.isEmpty }
        
        return result
    }
}

enum RecipeSection {
    case title
    case ingredients
    case instruction
    case unknown
}

extension String {
    func containsAny(of substrings: [String]) -> Bool {
        for substring in substrings {
            if self.contains(substring) {
                return true
            }
        }
        return false
    }
}
