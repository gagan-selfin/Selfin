//
//  OnboardingViewModel.swift
//  Selfin
//
//  Created by Marlon Monroy on 8/17/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation

struct OnboardingViewModel {
    var onboardinItems: [OnboardingItem] {
        let friend = OnboardingItem(imageName: "onboarding_page_1", title: "Find Friends", message: "I am going to find and follow my friends on Selfin.")
        let stars = OnboardingItem(imageName: "onboarding_page_2", title: "Earn Stars", message: "I will earn stars every time you publish a post, get liked, or get followed. Stars will help me to get verified.")
        let canBeUsed = OnboardingItem(imageName: "onboarding_page_3", title: "Can Be Used Horizontally", message: "First horizontal social media application ever. I will turn my phone sideways and see the magic.")
        return [friend, stars, canBeUsed]
    }
}
