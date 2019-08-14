import AVFoundation
//  Created by Marlon Monroy on 3/3/18.
//  Copyright © 2018 Self-in. All rights reserved.

import UIKit
import Accelerate

class CroppingFrame: UIView {
    let mover = UIView()
    var viewBounds  = CGRect()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)// calls designated initializer
        layer.borderWidth = 2
        layer.borderColor = UIColor.white.cgColor
        setup()
      
    }
    
    func setup() {
        let move = UIPanGestureRecognizer(target: self, action: #selector(move(gesture:)))
        addGestureRecognizer(move)
        var sizing = UIPanGestureRecognizer()
        switch UIDevice.current.orientation {
        case .landscapeLeft, .landscapeRight:
            viewBounds = CGRect(x: 0 , y: 0, width: UIScreen.main.bounds.height - 60, height: UIScreen.main.bounds.height - 60)
             sizing = UIPanGestureRecognizer(target: self, action: #selector(resizeHorizontal(gesture:)))
            mover.frame = CGRect(x: bounds.width - 15 , y: bounds.height / 2 - 25, width: 15, height: 50)
        case .portrait , .portraitUpsideDown, .faceDown, .faceUp:
            viewBounds = CGRect(x: 0 , y: 0, width: UIScreen.main.bounds.width - 60, height: UIScreen.main.bounds.width - 60)
             sizing = UIPanGestureRecognizer(target: self, action: #selector(resize(gesture:)))
            mover.frame = CGRect(x: bounds.width / 2 - 25, y: bounds.height - 15, width: 50, height: 15)
        default:break
        }
        mover.addGestureRecognizer(sizing)
        mover.layer.cornerRadius = 2
        mover.backgroundColor = .white
        addSubview(mover)
        layer.cornerRadius = 10
        clipsToBounds = true
    }
    
    func handleDeviceOrientation() {
        mover.removeFromSuperview()
        switch UIDevice.current.orientation {
        case .landscapeLeft, .landscapeRight:
        let sizing = UIPanGestureRecognizer(target: self, action: #selector(resizeHorizontal(gesture:)))
        setupMover(frame: CGRect(x: viewBounds.width - 15 , y: viewBounds.height / 2 - 25, width: 15, height: 50), gesture: sizing)
        case .portrait , .portraitUpsideDown, .faceDown, .faceUp:
         let sizing = UIPanGestureRecognizer(target: self, action: #selector(resize(gesture:)))
         setupMover(frame: CGRect(x: viewBounds.width / 2 - 25, y: viewBounds.height - 15, width: 50, height: 15), gesture: sizing)
        default:break
        }
    }
    
    func setupMover(frame : CGRect, gesture : UIPanGestureRecognizer) {
        mover.frame = frame
        mover.addGestureRecognizer(gesture)
        mover.layer.cornerRadius = 2
        mover.backgroundColor = .white
        addSubview(mover)
    }

    @objc func move(gesture: UIPanGestureRecognizer) {
        guard let parent = gesture.view?.superview else { return }
        guard let view = gesture.view else { return }
        let parentSize = parent.bounds.size
        let viewSize = view.bounds.size
        let translation = gesture.translation(in: self)
        var center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
        var reset = CGPoint(x: translation.x, y: translation.y)
        if center.x - viewSize.width / 2 < 0 {
            center.x = viewSize.width / 2
        } else if center.x + viewSize.width / 2 > parentSize.width {
            center.x = parentSize.width - viewSize.width / 2
        } else {
            reset.x = 0
        }

        if center.y - viewSize.height / 2 < 0 {
            center.y = viewSize.height / 2
        } else if center.y + viewSize.height / 2 > parentSize.height {
            center.y = parentSize.height - viewSize.height / 2
        } else {
            reset.y = 0
        }
        view.center = center
        gesture.setTranslation(CGPoint(x: 0, y: 0), in: self)
    }

    @objc func resize(gesture: UIPanGestureRecognizer) {
        if gesture.state == .began || gesture.state == .changed {
            guard let view = gesture.view else { return }
            let translation = gesture.translation(in: self)
            if frame.size.height + translation.y + self.frame.origin.y  <= superview?.frame.height ?? 55  {
                let newFrame = CGRect(origin: frame.origin, size: CGSize(width: frame.size.width, height: frame.size.height + translation.y))
                view.superview?.frame.size.height = max(newFrame.height, 300)
                view.frame = CGRect(x: bounds.width / 2 - 25, y: bounds.height - 15, width: 50, height: 15)
                gesture.setTranslation(.zero, in: self)
            }
        }
    }
    
    @objc func resizeHorizontal(gesture: UIPanGestureRecognizer) {
        if gesture.state == .began || gesture.state == .changed {
            guard let view = gesture.view else { return }
            let translation = gesture.translation(in: self)
            if frame.size.width + translation.x + self.frame.origin.x  <= superview?.frame.width ?? 55  {
                let newFrame = CGRect(origin: frame.origin, size: CGSize(width: frame.size.width + translation.x , height: frame.size.height ))
                view.superview?.frame.size.width = max(newFrame.width, 300)
                view.frame = CGRect(x: bounds.width - 15 , y: bounds.height / 2 - 25, width: 15, height: 50)
                gesture.setTranslation(.zero, in: self)
            }
        }
    }
}

internal class CropOverlay: UIView {
    var outerLines = [UIView]()
    var horizontalLines = [UIView]()
    var verticalLines = [UIView]()

    var topLeftCornerLines = [UIView]()
    var topRightCornerLines = [UIView]()
    var bottomLeftCornerLines = [UIView]()
    var bottomRightCornerLines = [UIView]()

    var cornerButtons = [UIButton]()

    let cornerLineDepth: CGFloat = 3
    let cornerLineWidth: CGFloat = 22.5
    var cornerButtonWidth: CGFloat {
        return cornerLineWidth * 2
    }

    let lineWidth: CGFloat = 1

    let outterGapRatio: CGFloat = 1 / 3
    var outterGap: CGFloat {
        return cornerButtonWidth * outterGapRatio
    }

    var isResizable: Bool = false
    var isMovable: Bool = false
    var minimumSize: CGSize = CGSize.zero

    internal override init(frame: CGRect) {
        super.init(frame: frame)
        createLines()
    }

    internal required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createLines()
    }

    override func layoutSubviews() {
        for i in 0 ..< outerLines.count {
            let line = outerLines[i]
            var lineFrame: CGRect
            switch i {
            case 0:
                lineFrame = CGRect(x: outterGap, y: outterGap, width: bounds.width - outterGap * 2, height: lineWidth)
                break
            case 1:
                lineFrame = CGRect(x: bounds.width - lineWidth - outterGap, y: outterGap, width: lineWidth, height: bounds.height - outterGap * 2)
                break
            case 2:
                lineFrame = CGRect(x: outterGap, y: bounds.height - lineWidth - outterGap, width: bounds.width - outterGap * 2, height: lineWidth)
                break
            case 3:
                lineFrame = CGRect(x: outterGap, y: outterGap, width: lineWidth, height: bounds.height - outterGap * 2)
                break
            default:
                lineFrame = CGRect.zero
                break
            }

            line.frame = lineFrame
        }

        let corners = [topLeftCornerLines, topRightCornerLines, bottomLeftCornerLines, bottomRightCornerLines]
        for i in 0 ..< corners.count {
            let corner = corners[i]

            var horizontalFrame: CGRect
            var verticalFrame: CGRect
            var buttonFrame: CGRect
            let buttonSize = CGSize(width: cornerButtonWidth, height: cornerButtonWidth)

            switch i {
            case 0: // Top Left
                verticalFrame = CGRect(x: outterGap, y: outterGap, width: cornerLineDepth, height: cornerLineWidth)
                horizontalFrame = CGRect(x: outterGap, y: outterGap, width: cornerLineWidth, height: cornerLineDepth)
                buttonFrame = CGRect(origin: CGPoint(x: 0, y: 0), size: buttonSize)
            case 1: // Top Right
                verticalFrame = CGRect(x: bounds.width - cornerLineDepth - outterGap, y: outterGap, width: cornerLineDepth, height: cornerLineWidth)
                horizontalFrame = CGRect(x: bounds.width - cornerLineWidth - outterGap, y: outterGap, width: cornerLineWidth, height: cornerLineDepth)
                buttonFrame = CGRect(origin: CGPoint(x: bounds.width - cornerButtonWidth, y: 0), size: buttonSize)
            case 2: // Bottom Left
                verticalFrame = CGRect(x: outterGap, y: bounds.height - cornerLineWidth - outterGap, width: cornerLineDepth, height: cornerLineWidth)
                horizontalFrame = CGRect(x: outterGap, y: bounds.height - cornerLineDepth - outterGap, width: cornerLineWidth, height: cornerLineDepth)
                buttonFrame = CGRect(origin: CGPoint(x: 0, y: bounds.height - cornerButtonWidth), size: buttonSize)
            case 3: // Bottom Right
                verticalFrame = CGRect(x: bounds.width - cornerLineDepth - outterGap, y: bounds.height - cornerLineWidth - outterGap, width: cornerLineDepth, height: cornerLineWidth)
                horizontalFrame = CGRect(x: bounds.width - cornerLineWidth - outterGap, y: bounds.height - cornerLineDepth - outterGap, width: cornerLineWidth, height: cornerLineDepth)
                buttonFrame = CGRect(origin: CGPoint(x: bounds.width - cornerButtonWidth, y: bounds.height - cornerButtonWidth), size: buttonSize)

            default:
                verticalFrame = CGRect.zero
                horizontalFrame = CGRect.zero
                buttonFrame = CGRect.zero
            }

            corner[0].frame = verticalFrame
            corner[1].frame = horizontalFrame
            cornerButtons[i].frame = buttonFrame
        }

        let lineThickness = lineWidth / UIScreen.main.scale
        let vPadding = (bounds.height - outterGap * 2 - (lineThickness * CGFloat(horizontalLines.count))) / CGFloat(horizontalLines.count + 1)
        let hPadding = (bounds.width - outterGap * 2 - (lineThickness * CGFloat(verticalLines.count))) / CGFloat(verticalLines.count + 1)

        for i in 0 ..< horizontalLines.count {
            let hLine = horizontalLines[i]
            let vLine = verticalLines[i]

            let vSpacing = (vPadding * CGFloat(i + 1)) + (lineThickness * CGFloat(i))
            let hSpacing = (hPadding * CGFloat(i + 1)) + (lineThickness * CGFloat(i))

            hLine.frame = CGRect(x: outterGap, y: vSpacing + outterGap, width: bounds.width - outterGap * 2, height: lineThickness)
            vLine.frame = CGRect(x: hSpacing + outterGap, y: outterGap, width: lineThickness, height: bounds.height - outterGap * 2)
        }
    }

    func createLines() {
        outerLines = [createLine(), createLine(), createLine(), createLine()]
        horizontalLines = [createLine(), createLine()]
        verticalLines = [createLine(), createLine()]

        topLeftCornerLines = [createLine(), createLine()]
        topRightCornerLines = [createLine(), createLine()]
        bottomLeftCornerLines = [createLine(), createLine()]
        bottomRightCornerLines = [createLine(), createLine()]

        cornerButtons = [createButton(), createButton(), createButton(), createButton()]

        let dragGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(moveCropOverlay))
        addGestureRecognizer(dragGestureRecognizer)
    }

    func createLine() -> UIView {
        let line = UIView()
        line.backgroundColor = UIColor.white
        addSubview(line)
        return line
    }

    func createButton() -> UIButton {
        let button = UIButton()
        button.backgroundColor = UIColor.clear

        let dragGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(moveCropOverlay))
        button.addGestureRecognizer(dragGestureRecognizer)

        addSubview(button)
        return button
    }

    @objc func moveCropOverlay(gestureRecognizer: UIPanGestureRecognizer) {
        if isResizable, let button = gestureRecognizer.view as? UIButton {
            if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
                let translation = gestureRecognizer.translation(in: self)

                var newFrame: CGRect

                switch button {
                case cornerButtons[0]: // Top Left
                    newFrame = CGRect(x: frame.origin.x + translation.x, y: frame.origin.y + translation.y, width: frame.size.width - translation.x, height: frame.size.height - translation.y)
                case cornerButtons[1]: // Top Right
                    newFrame = CGRect(x: frame.origin.x, y: frame.origin.y + translation.y, width: frame.size.width + translation.x, height: frame.size.height - translation.y)
                case cornerButtons[2]: // Bottom Left
                    newFrame = CGRect(x: frame.origin.x + translation.x, y: frame.origin.y, width: frame.size.width - translation.x, height: frame.size.height + translation.y)
                case cornerButtons[3]: // Bottom Right
                    newFrame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width + translation.x, height: frame.size.height + translation.y)

                default:
                    newFrame = CGRect.zero
                }

                let minimumFrame = CGRect(x: newFrame.origin.x, y: newFrame.origin.y, width: max(newFrame.size.width, minimumSize.width + 2 * outterGap), height: max(newFrame.size.height, minimumSize.height + 2 * outterGap))
                frame = minimumFrame
                layoutSubviews()

                gestureRecognizer.setTranslation(CGPoint.zero, in: self)
            }
        } else if isMovable {
            if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
                let translation = gestureRecognizer.translation(in: self)

                gestureRecognizer.view!.center = CGPoint(x: gestureRecognizer.view!.center.x + translation.x, y: gestureRecognizer.view!.center.y + translation.y)
                gestureRecognizer.setTranslation(CGPoint(x: 0, y: 0), in: self)
            }
        }
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)

        if !isMovable && isResizable && view != nil {
            let isButton = cornerButtons.reduce(false) { $1.hitTest(convert(point, to: $1), with: event) != nil || $0 }
            if !isButton {
                return nil
            }
        }

        return view
    }
}

public typealias CameraShotCompletion = (UIImage?) -> Void

final class ImageResizer {
    static func resizeWith(on image: UIImage, with targetSize: CGRect) -> UIImage? {
        let size = image.size
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        let newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    static func resize(_ image: UIImage, with targetRect: CGRect) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(targetRect.size, false, image.scale)
        let origin = CGPoint(x: targetRect.origin.x * CGFloat(-1), y: targetRect.origin.y * CGFloat(-1))
        image.draw(at: origin)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}

class CameraView: UIView {
    var camereDispatchQueue = DispatchQueue(label: "io.selfin.camera.dispatch.queue")
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var captureDevice: AVCaptureDevice!
    var capturePhotoOutput: AVCapturePhotoOutput?
    var input: AVCaptureDeviceInput!
    var didCaptureImage: ((_: UIImage?) -> Void)?
    var currentImage: UIImage?
    var cameraPosition = AVCaptureDevice.Position.back
    var flashMode: AVCaptureDevice.FlashMode = .off
    let focus = CropOverlay(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
    var setFlashMode: ((_: String?) -> Void)?
    var isFront = false

    func startSession() {
        do {
            if isFront {captureDevice = device(for: .front)}else {captureDevice = device(for: .back)}
            input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession = AVCaptureSession()
            captureSession?.sessionPreset = .high
            capturePhotoOutput = AVCapturePhotoOutput()
            captureSession?.addInput(input)
            captureSession?.addOutput(capturePhotoOutput!)
        } catch {
            print(error)
        }
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        videoPreviewLayer?.videoGravity = .resizeAspectFill
        videoPreviewLayer?.frame = self.bounds
        if let previewLayer = videoPreviewLayer {layer.addSublayer(previewLayer)}
        captureSession?.startRunning()
    }

    func stopSession() {
        captureSession?.stopRunning()
        videoPreviewLayer?.removeFromSuperlayer()

        captureSession = nil
        input = nil
        capturePhotoOutput = nil
        videoPreviewLayer = nil
        captureDevice = nil
    }

    override func draw(_: CGRect) {
        focus.isHidden = true
        addSubview(focus)
        setupGestures()
    }

    private func settingOnTakePhoto() {
        let photoSettings = AVCapturePhotoSettings()
        guard let capturePhotoOutput = self.capturePhotoOutput else { return }
        photoSettings.isAutoStillImageStabilizationEnabled = true
        capturePhotoOutput.isHighResolutionCaptureEnabled = true
        photoSettings.isHighResolutionPhotoEnabled = true

        photoSettings.flashMode = flashMode
        
//        let previewPixelType = photoSettings.availablePreviewPhotoPixelFormatTypes.first!
//        let previewFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
//                             kCVPixelBufferWidthKey as String: 160,
//                             kCVPixelBufferHeightKey as String: 160]

        capturePhotoOutput.capturePhoto(with: photoSettings, delegate: self)
    }

    func setupGestures() {
        gestureRecognizers?.forEach({ removeGestureRecognizer($0) })
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(takePhoto(gesture:)))
        swipe.direction = .up
        addGestureRecognizer(swipe)
        // focus(gesture:)
        let tap = UITapGestureRecognizer(target: self, action: #selector(focus(gesture:)))
        addGestureRecognizer(tap)
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(zoom(gesture:)))
        addGestureRecognizer(pinch)
    }

    func toggleFlash() {
        guard let device = captureDevice else { return }
        if !device.hasFlash { return }

        switch flashMode {
        case .auto:
            flashMode = .off
        case .off:
            flashMode = .on
        case .on:
            flashMode = .auto
        }
    }

    @objc func takePhoto(gesture _: UISwipeGestureRecognizer) {
        settingOnTakePhoto()
    }

    // focus gesture
    @objc func focus(gesture: UITapGestureRecognizer) {
        let point = gesture.location(in: self)
        guard shouldFocus(on: point) else { return }
        focus.isHidden = false
        focus.center = point
        focus.alpha = 0
        focus.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        bringSubviewToFront(focus)
        UIView.animateKeyframes(withDuration: 1.5, delay: 0, options: [], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.15, animations: {
                self.focus.alpha = 1
                self.focus.transform = CGAffineTransform.identity
            })
            UIView.addKeyframe(withRelativeStartTime: 0.80, relativeDuration: 0.20, animations: {
                self.focus.alpha = 0
                self.focus.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            })

        }) { if $0 { self.focus.isHidden = true } }
    }

    // focus
    func shouldFocus(on point: CGPoint) -> Bool {
        guard let device = captureDevice, let preview = videoPreviewLayer,
            device.isFocusModeSupported(.continuousAutoFocus) else { return false }

        do { try device.lockForConfiguration() } catch {
            return false
        }
        let pFocus = preview.captureDevicePointConverted(fromLayerPoint: point)
        device.focusPointOfInterest = pFocus
        device.focusMode = .continuousAutoFocus
        device.exposurePointOfInterest = pFocus
        device.exposureMode = .continuousAutoExposure
        device.unlockForConfiguration()

        return true
    }

    @objc func zoom(gesture: UIPinchGestureRecognizer) {
        guard let device = captureDevice else { fatalError() }
        let velocity = gesture.velocity
        let velocityFactor: CGFloat = 13.0
        let desiredZoomFactor = device.videoZoomFactor + atan2(velocity, velocityFactor)
        let scaleFactor = minMaxZoom(factor: desiredZoomFactor)
        switch gesture.state {
        case .began, .changed:
            update(scale: scaleFactor)
        default:
            break
        }
    }

    private func minMaxZoom(factor: CGFloat) -> CGFloat {
        guard let device = captureDevice else { fatalError() }
        return min(max(factor, 1.0), device.activeFormat.videoMaxZoomFactor)
    }

    private func update(scale factor: CGFloat) {
        guard let device = captureDevice else { fatalError() }
        do { try device.lockForConfiguration()
            defer { device.unlockForConfiguration() }
            device.videoZoomFactor = factor
        } catch {
            fatalError("\(error.localizedDescription)")
        }
    }

    func device(for position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: position)
        return device
    }

    func flip() {
        guard let s = captureSession, let currentInput = input else { return }
        s.beginConfiguration()
        s.removeInput(currentInput)
        if currentInput.device.position == .back {
            isFront = true
            cameraPosition = .front
            captureDevice = device(for: cameraPosition)
        } else {
            isFront = false
            cameraPosition = .back
            captureDevice = device(for: cameraPosition)
        }

        guard let new = try? AVCaptureDeviceInput(device: captureDevice) else {
            print("something wrong")
            return
        }
        input = new
        s.addInput(new)
        s.commitConfiguration()
    }

    //Method don't seems to work
    func rotateView() {
        guard videoPreviewLayer != nil else { return }
        switch UIDevice.current.orientation {
        case .portrait:
            videoPreviewLayer?.connection?.videoOrientation = .portrait
        case .portraitUpsideDown:
            videoPreviewLayer?.connection?.videoOrientation = .portraitUpsideDown
        case .landscapeRight:
            videoPreviewLayer?.connection?.videoOrientation = .landscapeRight
        case .landscapeLeft:
            videoPreviewLayer?.connection?.videoOrientation = .landscapeLeft
        default: break
        }
    }
    
    private func updatePreviewLayer(layer: AVCaptureConnection, orientation: AVCaptureVideoOrientation, rect : CGRect) {
        layer.videoOrientation = orientation
        videoPreviewLayer?.frame = rect
    }

    func rotateCamera(bounds : CGRect) {
        if let connection =  self.videoPreviewLayer?.connection  {

            let currentDevice: UIDevice = UIDevice.current

            let orientation: UIDeviceOrientation = currentDevice.orientation

            let previewLayerConnection : AVCaptureConnection = connection

            if previewLayerConnection.isVideoOrientationSupported {

                switch (orientation) {
                case .portrait: updatePreviewLayer(layer: previewLayerConnection, orientation: .portrait, rect: bounds)
                case .landscapeRight: updatePreviewLayer(layer: previewLayerConnection, orientation: .landscapeLeft, rect: bounds)
                case .landscapeLeft: updatePreviewLayer(layer: previewLayerConnection, orientation: .landscapeRight, rect: bounds)
                case .portraitUpsideDown: updatePreviewLayer(layer: previewLayerConnection, orientation: .portraitUpsideDown, rect: bounds)
                default: updatePreviewLayer(layer: previewLayerConnection, orientation: .portrait, rect: bounds)
                    break
                }
            }
        }
    }
    
    func imageRotatedByDegrees(oldImage: UIImage, deg degrees: CGFloat) -> UIImage {
        //Calculate the size of the rotated view's containing box for our drawing space
        let rotatedViewBox: UIView = UIView(frame: CGRect(x: 0, y: 0, width: oldImage.size.width, height: oldImage.size.height))
        let t: CGAffineTransform = CGAffineTransform(rotationAngle: degrees * CGFloat.pi / 180)
        rotatedViewBox.transform = t
        let rotatedSize: CGSize = rotatedViewBox.frame.size
        //Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap: CGContext = UIGraphicsGetCurrentContext()!
        //Move the origin to the middle of the image so we will rotate and scale around the center.
        bitmap.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
        //Rotate the image context
        bitmap.rotate(by: (degrees * CGFloat.pi / 180))
        //Now, draw the rotated/scaled image into the context
        bitmap.scaleBy(x: 1.0, y: -1.0)
        bitmap.draw(oldImage.cgImage!, in: CGRect(x: -oldImage.size.width / 2, y: -oldImage.size.height / 2, width: oldImage.size.width, height: oldImage.size.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
}

extension CameraView: AVCapturePhotoCaptureDelegate {
    func photoOutput(_: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?,
                     previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?,
                     resolvedSettings _: AVCaptureResolvedPhotoSettings,
                     bracketSettings _: AVCaptureBracketedStillImageSettings?,
                     error: Error?) {
        
        guard error == nil,
            let photoSampleBuffer = photoSampleBuffer else {
            print("Error capturing photo: \(String(describing: error))")
            return
        }

        guard let imageData =
            AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer) else {
            return
        }

        var image = UIImage(data: imageData, scale: 1)!
        switch UIDevice.current.orientation {
        case .landscapeRight:
            if isFront {
                image = image.fixedOrientation().imageRotatedByDegrees(degrees: -90.0)
                
            }else {
                image = image.fixedOrientation().imageRotatedByDegrees(degrees: 90.0)
            }
            
        case .landscapeLeft:
            if isFront {
                image = image.fixedOrientation().imageRotatedByDegrees(degrees: 90.0)
            }else {
                image = image.fixedOrientation().imageRotatedByDegrees(degrees: -90.0)
            }
        default:
            break
        }
        
        // flip the image to match the orientation of the preview
        if cameraPosition == .front, let cgImage = image.cgImage {
        let cgImage : CGImage = image.cgImage!

            switch image.imageOrientation {
            case .leftMirrored:
                image = UIImage(cgImage: cgImage, scale: image.scale, orientation: .right)
            case .left:
                image = UIImage(cgImage: cgImage, scale: image.scale, orientation: .rightMirrored)
            case .rightMirrored:
                image = UIImage(cgImage: cgImage, scale: image.scale, orientation: .left)
            case .right:
                image = UIImage(cgImage: cgImage, scale: image.scale, orientation: .leftMirrored)
            case .up:
                image = UIImage(cgImage: cgImage, scale: image.scale, orientation: .upMirrored)
            case .upMirrored:
                image = UIImage(cgImage: cgImage, scale: image.scale, orientation: .up)
            case .down:
                image = UIImage(cgImage: cgImage, scale: image.scale, orientation: .downMirrored)
            case .downMirrored:
                image = UIImage(cgImage: cgImage, scale: image.scale, orientation: .down)
            }
        }

        currentImage = ImageResizer.resizeWith(on: image, with: frame)
        didCaptureImage?(currentImage)
    }
}

func interfaceOrientation(toVideoOrientation orientation: UIInterfaceOrientation) -> AVCaptureVideoOrientation {
    switch orientation {
    case .portrait:
        return .portrait
    case .portraitUpsideDown:
        return .portraitUpsideDown
    case .landscapeLeft:
        return .landscapeLeft
    case .landscapeRight:
        return .landscapeRight
    default:
        break
    }
    
    print("Warning - Didn't recognise interface orientation (\(orientation))")
    return .portrait
}
extension UIImage {
    public func imageRotatedByDegrees(degrees: CGFloat) -> UIImage {
        //Calculate the size of the rotated view's containing box for our drawing space
        let rotatedViewBox: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        let t: CGAffineTransform = CGAffineTransform(rotationAngle: degrees * CGFloat.pi / 180)
        rotatedViewBox.transform = t
        let rotatedSize: CGSize = rotatedViewBox.frame.size
        //Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap: CGContext = UIGraphicsGetCurrentContext()!
        //Move the origin to the middle of the image so we will rotate and scale around the center.
        bitmap.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
        //Rotate the image context
        bitmap.rotate(by: (degrees * CGFloat.pi / 180))
        //Now, draw the rotated/scaled image into the context
        bitmap.scaleBy(x: 1.0, y: -1.0)
        bitmap.draw(self.cgImage!, in: CGRect(x: -self.size.width / 2, y: -self.size.height / 2, width: self.size.width, height: self.size.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    
    public func fixedOrientation() -> UIImage {
        if imageOrientation == UIImage.Orientation.up {
            return self
        }
        
        var transform: CGAffineTransform = CGAffineTransform.identity
        
        switch imageOrientation {
        case UIImage.Orientation.down, UIImage.Orientation.downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat.pi)
            break
        case UIImage.Orientation.left, UIImage.Orientation.leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat.pi/2)
            break
        case UIImage.Orientation.right, UIImage.Orientation.rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: -CGFloat.pi/2)
            break
        case UIImage.Orientation.up, UIImage.Orientation.upMirrored:
            break
        }
        
        switch imageOrientation {
        case UIImage.Orientation.upMirrored, UIImage.Orientation.downMirrored:
            transform.translatedBy(x: size.width, y: 0)
            transform.scaledBy(x: -1, y: 1)
            break
        case UIImage.Orientation.leftMirrored, UIImage.Orientation.rightMirrored:
            transform.translatedBy(x: size.height, y: 0)
            transform.scaledBy(x: -1, y: 1)
        case UIImage.Orientation.up, UIImage.Orientation.down, UIImage.Orientation.left, UIImage.Orientation.right:
            break
        }
        
        let ctx: CGContext = CGContext(data: nil,
                                       width: Int(size.width),
                                       height: Int(size.height),
                                       bitsPerComponent: self.cgImage!.bitsPerComponent,
                                       bytesPerRow: 0,
                                       space: self.cgImage!.colorSpace!,
                                       bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
        
        ctx.concatenate(transform)
        
        switch imageOrientation {
        case UIImage.Orientation.left, UIImage.Orientation.leftMirrored, UIImage.Orientation.right, UIImage.Orientation.rightMirrored:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
        default:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            break
        }
        
        let cgImage: CGImage = ctx.makeImage()!
        
        return UIImage(cgImage: cgImage)
    }
    
    func resizeImageUsingVImage(size:CGSize) -> UIImage? {
        let cgImage = self.cgImage!
        var format = vImage_CGImageFormat(bitsPerComponent: 8, bitsPerPixel: 32, colorSpace: nil, bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.first.rawValue), version: 0, decode: nil, renderingIntent: CGColorRenderingIntent.defaultIntent)
        var sourceBuffer = vImage_Buffer()
        defer {
            free(sourceBuffer.data)
        }
        var error = vImageBuffer_InitWithCGImage(&sourceBuffer, &format, nil, cgImage, numericCast(kvImageNoFlags))
        guard error == kvImageNoError else { return nil }
        // create a destination buffer
        let scale = self.scale
        let destWidth = Int(size.width)
        let destHeight = Int(size.height)
        let bytesPerPixel = self.cgImage!.bitsPerPixel/8
        let destBytesPerRow = destWidth * bytesPerPixel
        let destData = UnsafeMutablePointer<UInt8>.allocate(capacity: destHeight * destBytesPerRow)
        defer {
            destData.deallocate()
            //destData.deallocate(capacity: destHeight * destBytesPerRow)
        }
        var destBuffer = vImage_Buffer(data: destData, height: vImagePixelCount(destHeight), width: vImagePixelCount(destWidth), rowBytes: destBytesPerRow)
        // scale the image
        error = vImageScale_ARGB8888(&sourceBuffer, &destBuffer, nil, numericCast(kvImageHighQualityResampling))
        guard error == kvImageNoError else { return nil }
        // create a CGImage from vImage_Buffer
        var destCGImage = vImageCreateCGImageFromBuffer(&destBuffer, &format, nil, nil, numericCast(kvImageNoFlags), &error)?.takeRetainedValue()
        guard error == kvImageNoError else { return nil }
        // create a UIImage
        let resizedImage = destCGImage.flatMap { UIImage(cgImage: $0, scale: 0.0, orientation: self.imageOrientation) }
        destCGImage = nil
        return resizedImage
    }
}

// To increase height of default slider
class CustomSlide: UISlider {
    @IBInspectable var trackHeight: CGFloat = 8
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(origin: bounds.origin, size: CGSize(width: bounds.width, height: trackHeight))
    }
}
