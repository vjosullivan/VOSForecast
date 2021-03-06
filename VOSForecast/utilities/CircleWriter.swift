//
//  CircleWriter.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 10/03/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit

class Circlewriter {

    // MARK: - Properties

    /// M_PI as a CGFloat
    let π = CGFloat(M_PI)

    let context: CGContext
    let radius: CGFloat
    let color: UIColor
    let font:   UIFont
    let textOrientation: TextOrientation

    // MARK: - Functions

    init(context: CGContext, radius: CGFloat, font: UIFont = UIFont.systemFont(ofSize: 16), color: UIColor = UIColor.white, textOrientation: TextOrientation = .auto) {

        self.context = context
        self.radius  = radius
        self.color  = color
        self.font    = font
        self.textOrientation = textOrientation
    }

    ///  Returns the angle (in radians) subtended by a chord.
    ///
    ///  - parameter chord:  The length of the chord
    ///  - parameter radius: The radius of the circle.
    ///
    ///  - returns: The angle (in radians)
    ///
    fileprivate func chordToArc(_ chord: CGFloat) -> CGFloat {

        return 2 * asin(chord / (2 * radius))
    }

    ///  Writes the given set of words in a circle.
    ///
    ///  - parameters:
    ///    - words:    An array of words to be written.
    ///    - lastWord: Where to position the last word in the text array.<br/>
    ///                Options are: on or before either the six or twelve o'clock position.
    ///
    func write(_ words: [String], lastWord: LastWord = .onTop) {

        let count: Double = Double(words.count)
        var offsetAngle: CGFloat
        switch lastWord {
        case .onTop:
            offsetAngle = (-π / 2.0)
        case .beforeTop:
            offsetAngle = (-π / 2.0) + (π / CGFloat(count))
        case .onBottom:
            offsetAngle = (-π * 3.0 / 2.0)
        case .beforeBottom:
            offsetAngle = (-π * 3.0 / 2.0) + (π / CGFloat(count))
        }
        var i: Double = count
        for word in words {
            i -= 2
            var angle = CGFloat(M_PI * i / count) + offsetAngle
            angle += (angle < -π) ? 2 * π : 0.0
            write(word, angle: angle)
        }
    }

    ///  Writes the given word on the circle, centred on the given angle
    ///
    ///  - parameters:
    ///    - text:  The text to be written.
    ///    - angle: The location of the text on the circle, in radians anti-clockwise from the 3 o'clock position.
    ///
    func write(_ str: String, angle: CGFloat) {

        let l = str.characters.count
        let attributes = [NSFontAttributeName: font]

        var characters: [String] = [] // This will be an array of single character strings, each character in str
        var arcs: [CGFloat] = [] // This will be the arcs subtended by each character
        var totalArc: CGFloat = 0 // ... and the total arc subtended by the string

        // Calculate the arc subtended by each letter and their total
        for i in 0 ..< l {
            characters += [String(str[str.characters.index(str.startIndex, offsetBy: i)])]
            arcs += [chordToArc(characters[i].size(attributes: attributes).width)]
            totalArc += arcs[i]
        }

        // Are we writing upright (right way up at 12 o'clock, upside down at 6 o'clock)
        // or anti-upright (right way up at 6 o'clock)?
        let direction: CGFloat
        switch textOrientation {
        case .auto:
            direction = (angle > 0.01 && angle <= π + 0.01) || angle <= -π ? -1 : 1
        case .upright:
            direction = -1
        case .inverted:
            direction = 1
        }
        let slantCorrection = direction * CGFloat(M_PI_2)

        // The centre of the first character will then be at
        // thetaI = theta - totalArc / 2 + arcs[0] / 2
        // But we add the last term inside the loop
        var angleI = angle - direction * totalArc / 2

        for i in 0 ..< l {
            angleI += direction * arcs[i] / 2
            // Call centerText with each character in turn.
            // Remember to add +/-90º to the slantAngle otherwise
            // the characters will "stack" round the arc rather than "text flow"
            centreText(characters[i], angle: angleI, slantAngle: angleI + slantCorrection)
            // The centre of the next character will then be at
            // thetaI = thetaI + arcs[i] / 2 + arcs[i + 1] / 2
            // but again we leave the last term to the start of the next loop...
            angleI += direction * arcs[i] / 2
        }
    }

    ///  Writes the given text at the specified polar co-ordinates and angle.
    ///
    ///  - parameters:
    ///    - text:       The text to be written.
    ///    - theta:      The angular position of the text.  The position is therefore defined as
    ///                  `x = r * cos(theta)`, `y = r * sin(theta)`.
    ///    - slantAngle: The angular slant of the text.
    ///
    func centreText(_ text: String, angle theta: CGFloat, slantAngle: CGFloat) {

        // Set the text attributes
        let attributes = [NSForegroundColorAttributeName: color, NSFontAttributeName: font]
        // Save the context
        context.saveGState()
        // Undo the inversion of the Y-axis (or the text goes backwards!)
        context.scaleBy(x: 1, y: -1)
        // Move the origin to the centre of the text (negating the y-axis manually)
        context.translateBy(x: radius * cos(theta), y: -(radius * sin(theta)))
        // Rotate the coordinate system
        context.rotate(by: -slantAngle)
        // Calculate the width of the text
        let offset = text.size(attributes: attributes)
        // Move the origin by half the size of the text
        context.translateBy (x: -offset.width / 2, y: -offset.height / 2) // Move the origin to the centre of the text (negating the y-axis manually)
        // Draw the text
        text.draw(at: CGPoint.zero, withAttributes: attributes)
        // Restore the context
        context.restoreGState()
    }
}

// MARK: - Associated enums
// MARK: LastWord

///  Describes the angular position of the final word in a list of words drawn on a circle.
///
///  - OnTop:        Centred on the twelve o'clock position.
///  - BeforeTop:    Left of the twelve o'clock position.
///  - OnBottom:     Centred on the six o'clock position.
///  - BeforeBottom: Right of the six o'clock position.
///
enum LastWord {
    /// Centres the final word at 12 o'clock.
    case onTop
    /// Centres the final word left of 12 o'clock.
    case beforeTop
    /// Centres the final word at 6 o'clock.
    case onBottom
    /// Centres the final word right of 6 o'clock.
    case beforeBottom
}

// MARK: TextOrientation

///  The way in which words are written around their circle.
///
///  - **Auto**:     Words are written "upright" with respect to viewer.
///  - **Upright**:  All words are written "upright" with respect to the surface of their circle.
///  - **Inverted**: All words are written "upside down" with respect to the surface of their circle.
///
enum TextOrientation {
    /// Words are written "upright" with respect to viewer.<br/>i.e. Words centred on or above the equator of the circle are written "upright" and words below the equator are "inverted".
    case auto
    /// All words are written "upright" with respect to the surface of the circle.
    case upright
    /// All words are written "upside down" with respect to the surface of the circle.
    case inverted
}


