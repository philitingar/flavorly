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
    private let measurementUnits = ["cup", "cups", "tsp", "tbsp", "oz", "g", "kg", "ml", "l", "lb", "pound", "pounds", "ounce", "ounces", "gram", "grams", "kilogram", "kilograms", "liter", "liters", "milliliter", "milliliters", "teaspoon", "teaspoons", "tablespoon", "tablespoons", "clove", "cloves", "pinch", "dash", "slice", "slices", "piece", "pieces", "can", "cans", "jar", "jars", "packet", "packets", "bunch", "bunches", "head", "heads", "bottle", "bottles"]
    
    private let commonIngredients = ["flour", "sugar", "salt", "pepper", "oil", "butter", "eggs", "egg", "milk", "water", "onion", "onions", "garlic", "cheese", "chicken", "beef", "pork", "fish", "rice", "pasta", "bread", "tomato", "tomatoes", "potato", "potatoes", "carrot", "carrots", "celery", "herbs", "spices", "vanilla", "chocolate", "cream", "yogurt", "lemon", "lime", "apple", "apples", "banana", "bananas", "fresh", "dried", "chopped", "diced", "minced", "sliced", "ground", "whole", "half", "quarter", "cooking", "vegetable", "olive", "coconut", "almond", "peanut", "sesame", "canola", "sunflower", "avocado"]
    
    init() {
        let emptyString = ""
        ingredientTagger.string = emptyString
        ingredientTagger.setLanguage(.english, range: emptyString.startIndex..<emptyString.endIndex)
    }
    
    func parseRecipe(text: String) -> ParsedRecipe {
        var result = ParsedRecipe()
        
        // Split text into lines and clean them
        let lines = text.components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        
        guard !lines.isEmpty else { return result }
        
        // Phase 1: Find explicit section headers
        let sectionRanges = findSectionRanges(in: lines)
        
        // Phase 2: Parse based on found sections or use smart detection
        if let titleRange = sectionRanges.title {
            result.title = lines[titleRange].first ?? "Imported Recipe"
        } else {
            result.title = lines.first ?? "Imported Recipe"
        }
        
        if let ingredientRange = sectionRanges.ingredients {
            result.ingredients = Array(lines[ingredientRange])
                .filter { !$0.isEmpty }
                .map { cleanIngredientLine($0) }
        } else {
            // Smart ingredient detection with improved logic
            result.ingredients = smartParseIngredients(from: lines)
        }
        
        if let instructionRange = sectionRanges.instructions {
            result.instructions = parseInstructionsPreservingFormat(Array(lines[instructionRange]))
        } else {
            // Smart instruction detection
            result.instructions = smartParseInstructions(from: lines, excludingIngredientLines: Set(result.ingredients.map { $0.lowercased() }))
        }
        
        // Post-processing: Move misclassified items
        let (finalIngredients, finalInstructions) = postProcessClassification(
            ingredients: result.ingredients,
            instructions: result.instructions
        )
        
        result.ingredients = finalIngredients
        result.instructions = finalInstructions
        
        // Fallback if everything is empty
        if result.ingredients.isEmpty && result.instructions.isEmpty {
            let fallback = fallbackParsing(lines: lines)
            result.ingredients = fallback.ingredients
            result.instructions = fallback.instructions
        }
        
        return result
    }
    
    private func findSectionRanges(in lines: [String]) -> (title: Range<Int>?, ingredients: Range<Int>?, instructions: Range<Int>?) {
        var titleRange: Range<Int>?
        var ingredientRange: Range<Int>?
        var instructionRange: Range<Int>?
        
        var ingredientStart: Int?
        var instructionStart: Int?
        
        for (index, line) in lines.enumerated() {
            let lowerLine = line.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Look for ingredient section headers
            if lowerLine.contains("ingredient") || lowerLine.contains("what you need") ||
               lowerLine.contains("shopping list") || lowerLine.contains("you'll need") {
                ingredientStart = index + 1
                continue
            }
            
            // Look for instruction section headers
            if lowerLine.contains("instruction") || lowerLine.contains("direction") ||
               lowerLine.contains("method") || lowerLine.contains("steps") ||
               lowerLine.contains("preparation") || lowerLine.contains("how to") {
                
                // Close ingredient section if it was open
                if let start = ingredientStart, ingredientRange == nil {
                    ingredientRange = start..<index
                }
                
                instructionStart = index + 1
                continue
            }
        }
        
        // Close any open sections
        if let start = ingredientStart, ingredientRange == nil {
            let end = instructionStart ?? lines.count
            ingredientRange = start..<end
        }
        
        if let start = instructionStart, instructionRange == nil {
            instructionRange = start..<lines.count
        }
        
        // Title is everything before the first section or just the first line
        let firstSectionStart = min(ingredientStart ?? lines.count, instructionStart ?? lines.count)
        if firstSectionStart > 1 {
            titleRange = 0..<min(firstSectionStart - 1, 3) // Max 3 lines for title
        } else if firstSectionStart == lines.count {
            titleRange = 0..<1
        }
        
        return (titleRange, ingredientRange, instructionRange)
    }
    
    private func smartParseIngredients(from lines: [String]) -> [String] {
        var ingredients = [String]()
        var consecutiveNonIngredients = 0
        let maxConsecutiveNonIngredients = 2
        
        for (index, line) in lines.enumerated() {
            // Skip title (first line unless it's clearly an ingredient)
            if index == 0 && !isLikelyIngredient(line) {
                continue
            }
            
            // Skip if this is clearly an instruction
            if isDefinitelyInstruction(line) {
                consecutiveNonIngredients += 1
                // If we've seen multiple consecutive non-ingredients, we're probably in instructions now
                if consecutiveNonIngredients >= maxConsecutiveNonIngredients {
                    break
                }
                continue
            }
            
            // Check if this line is an ingredient
            if isLikelyIngredient(line) {
                ingredients.append(cleanIngredientLine(line))
                consecutiveNonIngredients = 0
            } else {
                // Even if it doesn't match our patterns, it might still be an ingredient
                // if it's in the first half of the recipe and not clearly an instruction
                let isInFirstHalf = index < lines.count / 2
                let couldBeIngredient = isInFirstHalf && !isDefinitelyInstruction(line) && !isLikelyLongText(line)
                
                if couldBeIngredient {
                    ingredients.append(cleanIngredientLine(line))
                    consecutiveNonIngredients = 0
                } else {
                    consecutiveNonIngredients += 1
                    if consecutiveNonIngredients >= maxConsecutiveNonIngredients {
                        break
                    }
                }
            }
        }
        
        return ingredients
    }
    
    private func smartParseInstructions(from lines: [String], excludingIngredientLines: Set<String>) -> [String] {
        var instructions = [String]()
        var startIndex = 0
        var foundInstructionStart = false
        
        // Find where instructions likely start
        for (index, line) in lines.enumerated() {
            let lowerLine = line.lowercased()
            
            // Skip if this line was already classified as an ingredient
            if excludingIngredientLines.contains(lowerLine) {
                continue
            }
            
            // Look for clear instruction indicators
            if isDefinitelyInstruction(line) || isLikelyLongText(line) {
                startIndex = index
                foundInstructionStart = true
                break
            }
        }
        
        // If no clear instructions found, start after ingredients section
        if !foundInstructionStart {
            // Find the last likely ingredient
            var lastIngredientIndex = -1
            for (index, line) in lines.enumerated() {
                if isLikelyIngredient(line) && !excludingIngredientLines.contains(line.lowercased()) {
                    lastIngredientIndex = index
                }
            }
            startIndex = max(lastIngredientIndex + 1, lines.count / 2)
        }
        
        // Parse instructions from start index
        let instructionLines = Array(lines.dropFirst(startIndex))
            .filter { !excludingIngredientLines.contains($0.lowercased()) }
        
        return parseInstructionsPreservingFormat(instructionLines)
    }
    
    private func parseInstructionsPreservingFormat(_ lines: [String]) -> [String] {
        var instructions = [String]()
        var currentInstruction = ""
        
        for line in lines {
            let trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmedLine.isEmpty { continue }
            
            // Check if this line starts a new instruction step
            if isNewInstructionStep(trimmedLine) {
                // Save previous instruction if exists
                if !currentInstruction.isEmpty {
                    instructions.append(currentInstruction.trimmingCharacters(in: .whitespacesAndNewlines))
                }
                // Start new instruction (preserve original formatting)
                currentInstruction = line
            } else {
                // Continue current instruction
                if currentInstruction.isEmpty {
                    currentInstruction = line
                } else {
                    currentInstruction += "\n" + line
                }
            }
        }
        
        // Add the last instruction
        if !currentInstruction.isEmpty {
            instructions.append(currentInstruction.trimmingCharacters(in: .whitespacesAndNewlines))
        }
        
        return instructions.filter { !$0.isEmpty }
    }
    
    private func isNewInstructionStep(_ line: String) -> Bool {
        let trimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Starts with number followed by period or parenthesis
        if trimmed.range(of: "^\\d+[.)\\s]", options: .regularExpression) != nil {
            return true
        }
        
        // Starts with bullet points
        if trimmed.hasPrefix("•") || trimmed.hasPrefix("-") || trimmed.hasPrefix("*") {
            return true
        }
        
        // Starts with "Step"
        if trimmed.lowercased().hasPrefix("step") {
            return true
        }
        
        // Starts with strong action verb that's clearly instructional
        let actionWords = ["preheat", "mix", "combine", "stir", "bake", "cook", "heat", "add", "fold", "whisk", "beat", "chop", "dice", "slice", "melt", "boil", "simmer", "fry", "sauté", "roast", "grill", "blend", "pour", "serve", "garnish", "season", "remove", "drain", "cool", "chill", "refrigerate", "freeze", "place", "put", "set", "turn", "cover", "uncover", "sprinkle", "arrange", "transfer", "bring", "reduce", "increase"]
        
        let firstWord = trimmed.components(separatedBy: .whitespaces).first?.lowercased() ?? ""
        return actionWords.contains(firstWord)
    }
    
    private func isLikelyIngredient(_ text: String) -> Bool {
        let lowerText = text.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Skip if it's clearly an instruction
        if isDefinitelyInstruction(text) {
            return false
        }
        
        // Skip if it's too long (likely an instruction)
        if isLikelyLongText(text) {
            return false
        }
        
        var score = 0
        
        // Strong indicators (high weight)
        if measurementUnits.contains(where: { lowerText.contains($0) }) {
            score += 3
        }
        
        // Has quantities (numbers or fractions)
        if text.range(of: "\\d+([/.]\\d+)?", options: .regularExpression) != nil {
            score += 2
        }
        
        // Contains common ingredient words
        let ingredientMatches = commonIngredients.filter { lowerText.contains($0) }.count
        score += min(ingredientMatches * 2, 4) // Cap at 4 points
        
        // Format indicators
        if lowerText.contains(",") && !lowerText.contains(".") {
            score += 1 // Ingredients often have commas for descriptors
        }
        
        // Contains descriptive words common in ingredients
        let descriptors = ["fresh", "dried", "chopped", "diced", "minced", "sliced", "ground", "whole", "crushed", "grated", "shredded", "fine", "coarse", "large", "small", "medium", "extra", "virgin", "organic", "raw", "cooked"]
        if descriptors.contains(where: { lowerText.contains($0) }) {
            score += 1
        }
        
        // Short lines are more likely to be ingredients
        if text.count < 50 {
            score += 1
        }
        
        // NLP analysis for nouns (ingredients are typically nouns)
        ingredientTagger.string = text
        var nounCount = 0
        
        ingredientTagger.enumerateTags(in: text.startIndex..<text.endIndex,
                                     unit: .word,
                                     scheme: .lexicalClass,
                                     options: [.omitPunctuation, .omitWhitespace]) { tag, range in
            if tag == .noun {
                nounCount += 1
            }
            return true
        }
        
        if nounCount > 0 {
            score += min(nounCount, 2) // Cap at 2 points for nouns
        }
        
        // Return true if score is high enough
        return score >= 3
    }
    
    private func isDefinitelyInstruction(_ text: String) -> Bool {
        let lowerText = text.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Starts with step numbers
        if text.range(of: "^\\d+[.)\\s]", options: .regularExpression) != nil {
            return true
        }
        
        // Starts with bullet points
        if lowerText.hasPrefix("•") || lowerText.hasPrefix("-") || lowerText.hasPrefix("*") {
            return true
        }
        
        // Starts with "step"
        if lowerText.hasPrefix("step") {
            return true
        }
        
        // Starts with strong action words that are clearly instructional
        let strongActionWords = ["preheat", "bake", "cook", "boil", "simmer", "fry", "roast", "grill", "serve", "garnish", "remove", "drain", "cool", "chill", "place", "arrange", "transfer", "bring", "reduce", "meanwhile", "while", "until", "when", "after", "before", "once", "then", "next", "finally"]
        
        let firstWord = lowerText.components(separatedBy: .whitespaces).first ?? ""
        if strongActionWords.contains(firstWord) {
            return true
        }
        
        // Contains instruction-specific phrases
        let instructionPhrases = ["degrees", "°f", "°c", "oven", "minutes", "hours", "until tender", "until golden", "until done", "stir occasionally", "mix well", "combine thoroughly"]
        
        if instructionPhrases.contains(where: { lowerText.contains($0) }) {
            return true
        }
        
        // Long sentences are more likely to be instructions
        return isLikelyLongText(text) && lowerText.contains(".")
    }
    
    private func isLikelyLongText(_ text: String) -> Bool {
        return text.count > 80 || text.components(separatedBy: .whitespaces).count > 12
    }
    
    private func cleanIngredientLine(_ line: String) -> String {
        var cleaned = line.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Remove bullet points or numbers at the beginning
        if let range = cleaned.range(of: "^[•*-]\\s*", options: .regularExpression) {
            cleaned.removeSubrange(range)
        }
        
        if let range = cleaned.range(of: "^\\d+[.)\\s]*", options: .regularExpression) {
            cleaned.removeSubrange(range)
        }
        
        return cleaned.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    // Post-processing to move misclassified items between ingredients and instructions
    private func postProcessClassification(ingredients: [String], instructions: [String]) -> ([String], [String]) {
        var finalIngredients = ingredients
        var finalInstructions = instructions
        var movedIndices: Set<Int> = []
        
        // Check ingredients that might actually be instructions
        for (index, ingredient) in ingredients.enumerated() {
            if isDefinitelyInstruction(ingredient) {
                finalInstructions.append(ingredient)
                movedIndices.insert(index)
            }
        }
        
        // Remove moved items from ingredients
        finalIngredients = finalIngredients.enumerated().compactMap { index, ingredient in
            movedIndices.contains(index) ? nil : ingredient
        }
        
        // Check instructions that might actually be ingredients
        var instructionsToMove: [String] = []
        var instructionsToKeep: [String] = []
        
        for instruction in instructions {
            if isLikelyIngredient(instruction) && !isDefinitelyInstruction(instruction) {
                instructionsToMove.append(cleanIngredientLine(instruction))
            } else {
                instructionsToKeep.append(instruction)
            }
        }
        
        finalIngredients.append(contentsOf: instructionsToMove)
        finalInstructions = instructionsToKeep
        
        return (finalIngredients, finalInstructions)
    }
    
    // Fallback parsing when smart detection fails
    private func fallbackParsing(lines: [String]) -> ParsedRecipe {
        var result = ParsedRecipe()
        
        result.title = lines.first ?? "Imported Recipe"
        
        // More intelligent fallback: look for transition point
        var transitionPoint = lines.count / 2
        
        // Find the first line that's definitely an instruction
        for (index, line) in lines.enumerated() {
            if index > 0 && isDefinitelyInstruction(line) {
                transitionPoint = index
                break
            }
        }
        
        let startIndex = min(1, lines.count - 1) // Skip title
        
        result.ingredients = Array(lines[startIndex..<transitionPoint])
            .filter { !$0.isEmpty }
            .map { cleanIngredientLine($0) }
        
        result.instructions = parseInstructionsPreservingFormat(Array(lines[transitionPoint...]))
        
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
