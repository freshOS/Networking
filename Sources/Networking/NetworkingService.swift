//
//  NetworkingService.swift
//
//
//  Created by Sacha on 13/03/2020.
//

import Foundation
import Combine

public protocol NetworkingService {
    var network: NetworkingClient { get }
}
