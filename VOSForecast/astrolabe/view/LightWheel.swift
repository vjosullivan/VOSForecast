//
//  LightWheel.swift
//  VOSForecast
//
//  Created by Vincent O'Sullivan on 29/03/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import UIKit

class LightWheel: UIView {

    let rd: CGFloat = 400.0
    let r: CGRect
    let lineWidth: CGFloat
    let colors: LightWheelColors
    let times: LightTimes

    init(frame: CGRect, times: LightTimes, lineWidth: CGFloat, colors: LightWheelColors) {
        r = frame //              = CGRectMake(50, 50, 900, 900)
        self.colors    = colors
        self.times     = times
        self.lineWidth = lineWidth
        super.init(frame: frame)
        backgroundColor = UIColor.white
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {

        // Setup graphics context
        let ctx = UIGraphicsGetCurrentContext()

        // clear context
        ctx?.clear(rect)

        drawArc(ctx!, startTime: times.night,                endTime: times.morningAstroTwilight, strokeColor: colors.nightColor)
        drawArc(ctx!, startTime: times.morningAstroTwilight, endTime: times.morningNavalTwilight, strokeColor: colors.astroColor)
        drawArc(ctx!, startTime: times.morningNavalTwilight, endTime: times.morningCivilTwilight, strokeColor: colors.navalColor)
        drawArc(ctx!, startTime: times.morningCivilTwilight, endTime: times.sunrise,              strokeColor: colors.civilColor)
        drawArc(ctx!, startTime: times.sunrise,              endTime: times.morningGoldenHour,    strokeColor: colors.goldenHourColor)
        drawArc(ctx!, startTime: times.morningGoldenHour,    endTime: times.eveningGoldenHour,    strokeColor: colors.dayColor)
        drawArc(ctx!, startTime: times.eveningGoldenHour,    endTime: times.sunset,               strokeColor: colors.goldenHourColor)
        drawArc(ctx!, startTime: times.sunset,               endTime: times.eveningNavalTwilight, strokeColor: colors.civilColor)
        drawArc(ctx!, startTime: times.eveningNavalTwilight, endTime: times.eveningAstroTwilight, strokeColor: colors.navalColor)
        drawArc(ctx!, startTime: times.eveningAstroTwilight, endTime: times.night,                strokeColor: colors.astroColor)
    }

    func drawArc(_ context: CGContext, startTime: Double, endTime: Double, strokeColor: UIColor) {
        strokeColor.setStroke()
        strokeColor.setFill()
        context.setLineWidth(1.0)
        context.setLineCap(CGLineCap.butt)
        context.setFillColor(strokeColor.cgColor)
        let arc = CGMutablePath()

        let radius = min(r.midX - r.minX, r.midY - r.minY) - lineWidth / 2.0 - max(r.minX, r.minY)
        let path = CGMutablePath()
        path.addArc(center: CGPoint(x: r.midX, y: r.midY), radius: radius, startAngle: CGFloat(M_PI_2 + 4 * startTime * M_PI_2), endAngle: CGFloat(M_PI_2 + 4 * endTime * M_PI_2), clockwise: false)
        let strokedArc = CGPath(__byStroking: arc, transform: nil,
                                                        lineWidth: lineWidth,
                                                        lineCap: CGLineCap.butt,
                                                        lineJoin: CGLineJoin.miter,
                                                        miterLimit: 1)
        context.addPath(strokedArc!)
        context.fillPath();

        context.strokePath()
    }
}

struct LightWheelColors {
    let nightColor: UIColor
    let astroColor: UIColor
    let navalColor: UIColor
    let civilColor: UIColor
    let goldenHourColor:  UIColor
    let dayColor:   UIColor
}

struct LightTimes {
    let morningAstroTwilight: Double
    let morningNavalTwilight: Double
    let morningCivilTwilight: Double
    let sunrise:              Double
    let morningGoldenHour:    Double
    let eveningGoldenHour:    Double
    let sunset:               Double
    let eveningNavalTwilight: Double
    let eveningAstroTwilight: Double
    let night:                Double
}

//let wheelColors = LightWheelColors(nightColor: UIColor(red: 0.0, green: 0.0,  blue: 0.28, alpha: 1.0),
//                                   astroColor: UIColor(red: 0.1, green: 0.05, blue: 0.32, alpha: 1.0),
//                                   navalColor: UIColor(red: 0.2, green: 0.1,  blue: 0.36, alpha: 1.0),
//                                   civilColor: UIColor(red: 0.4, green: 0.2,  blue: 0.40, alpha: 1.0),
//                                   goldenHourColor: UIColor(red: 1.0, green: 0.75, blue: 0.50, alpha: 1.0),
//                                   dayColor: UIColor(red: 1.0, green: 1.0,  blue: 0.50, alpha: 1.0))
//
//let times = LightTimes(
//    morningAstroTwilight:  3.7 / 24.0,
//    morningNavalTwilight:  4.1 / 24.0,
//    morningCivilTwilight:  4.7 / 24.0,
//    sunrise:               5.5 / 24.0,
//    morningGoldenHour:     6.5 / 24.0,
//    eveningGoldenHour:    18.0 / 24.0,
//    sunset:               19.0 / 24.0,
//    eveningNavalTwilight: 20.0 / 24.0,
//    eveningAstroTwilight: 21.0 / 24.0,
//    night:                22.0 / 24.0
//)
//
//let paper = LightWheel(frame: CGRectMake(0, 0, 400, 400), times: times, lineWidth: 20.0, colors: wheelColors)
