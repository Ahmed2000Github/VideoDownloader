//
//  YoutubeVideoRS.swift
//  VideoDownloader
//
//  Created by mac on 7/6/2023.
//

import Foundation

struct YoutubeVideoRS: Codable {
    let responseContext: ResponseContext
    let playabilityStatus: PlayabilityStatus
    let streamingData: StreamingData
    let playbackTracking: PlaybackTracking
    let videoDetails: VideoDetails
    let playerConfig: PlayerConfig
    let trackingParams: String
}

// MARK: - PlayabilityStatus
struct PlayabilityStatus: Codable {
    let status: String
    let playableInEmbed: Bool
}

// MARK: - PlaybackTracking
struct PlaybackTracking: Codable {
    let videostatsPlaybackURL, videostatsDelayplayURL, videostatsWatchtimeURL, ptrackingURL: PtrackingURLClass
    let qoeURL: PtrackingURLClass

    enum CodingKeys: String, CodingKey {
        case videostatsPlaybackURL = "videostatsPlaybackUrl"
        case videostatsDelayplayURL = "videostatsDelayplayUrl"
        case videostatsWatchtimeURL = "videostatsWatchtimeUrl"
        case ptrackingURL = "ptrackingUrl"
        case qoeURL = "qoeUrl"
    }
}

// MARK: - PtrackingURLClass
struct PtrackingURLClass: Codable {
    let baseURL: String
    let headers: [Header]

    enum CodingKeys: String, CodingKey {
        case baseURL = "baseUrl"
        case headers
    }
}

// MARK: - Header
struct Header: Codable {
    let headerType: HeaderType
}

enum HeaderType: String, Codable {
    case userAuth = "USER_AUTH"
    case visitorID = "VISITOR_ID"
}

// MARK: - PlayerConfig
struct PlayerConfig: Codable {
    let audioConfig: AudioConfig
    let exoPlayerConfig: ExoPlayerConfig
}

// MARK: - AudioConfig
struct AudioConfig: Codable {
    let loudnessDB, perceptualLoudnessDB: Double
    let enablePerFormatLoudness: Bool

    enum CodingKeys: String, CodingKey {
        case loudnessDB = "loudnessDb"
        case perceptualLoudnessDB = "perceptualLoudnessDb"
        case enablePerFormatLoudness
    }
}

// MARK: - ExoPlayerConfig
struct ExoPlayerConfig: Codable {
    let useExoPlayer, useAdaptiveBitrate: Bool
    let maxInitialByteRate, minDurationForQualityIncreaseMS, maxDurationForQualityDecreaseMS, minDurationToRetainAfterDiscardMS: Int
    let lowWatermarkMS, highWatermarkMS: Int
    let lowPoolLoad, highPoolLoad, sufficientBandwidthOverhead: Double
    let bufferChunkSizeKB, httpConnectTimeoutMS, httpReadTimeoutMS, numAudioSegmentsPerFetch: Int
    let numVideoSegmentsPerFetch, minDurationForPlaybackStartMS: Int
    let enableExoplayerReuse, useRadioTypeForInitialQualitySelection, blacklistFormatOnError, enableBandaidHTTPDataSource: Bool
    let httpLoadTimeoutMS: Int
    let canPlayHDDRM: Bool
    let videoBufferSegmentCount, audioBufferSegmentCount: Int
    let useAbruptSplicing: Bool
    let minRetryCount, minChunksNeededToPreferOffline, secondsToMaxAggressiveness: Int
    let enableSurfaceviewResizeWorkaround, enableVp9IfThresholdsPass, matchQualityToViewportOnUnfullscreen: Bool
    let lowAudioQualityConnTypes: [String]
    let useDashForLiveStreams, enableLibvpxVideoTrackRenderer: Bool
    let lowAudioQualityBandwidthThresholdBps: Int
    let enableVariableSpeedPlayback, preferOnesieBufferedFormat: Bool
    let minimumBandwidthSampleBytes: Int
    let useDashForOtfAndCompletedLiveStreams, disableCacheAwareVideoFormatEvaluation, useLiveDVRForDashLiveStreams, cronetResetTimeoutOnRedirects: Bool
    let emitVideoDecoderChangeEvents: Bool
    let onesieVideoBufferLoadTimeoutMS, onesieVideoBufferReadTimeoutMS: String
    let libvpxEnableGl, enableVp9EncryptedIfThresholdsPass, enableOpus, usePredictedBuffer: Bool
    let maxReadAheadMediaTimeMS: Int
    let useMediaTimeCappedLoadControl: Bool
    let allowCacheOverrideToLowerQualitiesWithinRange: Int
    let allowDroppingUndecodedFrames: Bool
    let minDurationForPlaybackRestartMS: Int
    let serverProvidedBandwidthHeader, liveOnlyPegStrategy: String
    let enableRedirectorHostFallback, enableHighlyAvailableFormatFallbackOnPcr, recordTrackRendererTimingEvents: Bool
    let minErrorsForRedirectorHostFallback: Int
    let nonHardwareMediaCodecNames: [String]
    let enableVp9IfInHardware, enableVp9EncryptedIfInHardware, useOpusMedAsLowQualityAudio: Bool
    let minErrorsForPcrFallback: Int
    let useStickyRedirectHTTPDataSource, onlyVideoBandwidth, useRedirectorOnNetworkChange, enableMaxReadaheadABRThreshold: Bool
    let cacheCheckDirectoryWritabilityOnce: Bool
    let predictorType: String
    let slidingPercentile: Double
    let slidingWindowSize, maxFrameDropIntervalMS: Int
    let ignoreLoadTimeoutForFallback: Bool
    let serverBweMultiplier, drmMaxKeyfetchDelayMS, maxResolutionForWhiteNoise: Int
    let whiteNoiseRenderEffectMode: String
    let enableLibvpxHdr, enableCacheAwareStreamSelection, useExoCronetDataSource: Bool
    let whiteNoiseScale, whiteNoiseOffset: Int
    let preventVideoFrameLaggingWithLibvpx, enableMediaCodecHdr, enableMediaCodecSwHdr: Bool
    let liveOnlyWindowChunks: Int
    let bearerMinDurationToRetainAfterDiscardMS: [Int]
    let forceWidevineL3, useAverageBitrate, useMedialibAudioTrackRendererForLive, useExoPlayerV2: Bool
    let logMediaRequestEventsToCSI, onesieFixNonZeroStartTimeFormatSelection: Bool
    let liveOnlyReadaheadStepSizeChunks, liveOnlyBufferHealthHalfLifeSeconds: Int
    let liveOnlyMinBufferHealthRatio: Double
    let liveOnlyMinLatencyToSeekRatio: Int
    let manifestlessPartialChunkStrategy: String
    let ignoreViewportSizeWhenSticky, enableLibvpxFallback, disableLibvpxLoopFilter, enableVpxMediaView: Bool
    let hdrMinScreenBrightness, hdrMaxScreenBrightnessThreshold: Int
    let onesieDataSourceAboveCacheDataSource: Bool
    let httpNonplayerLoadTimeoutMS: Int
    let numVideoSegmentsPerFetchStrategy: String
    let maxVideoDurationPerFetchMS, maxVideoEstimatedLoadDurationMS, estimatedServerClockHalfLife: Int
    let estimatedServerClockStrictOffset: Bool
    let minReadAheadMediaTimeMS, readAheadGrowthRate: Int
    let useDynamicReadAhead, useYtVODMediaSourceForV2, enableV2Gapless, useLiveHeadTimeMillis: Bool
    let allowTrackSelectionWithUpdatedVideoItagsForExoV2: Bool
    let maxAllowableTimeBeforeMediaTimeUpdateSEC: Int
    let enableDynamicHdr, v2PerformEarlyStreamSelection, v2UsePlaybackStreamSelectionResult: Bool
    let v2MinTimeBetweenABRReevaluationMS: Int
    let avoidReusePlaybackAcrossLoadvideos, enableInfiniteNetworkLoadingRetries, reportExoPlayerStateOnTransition: Bool
    let manifestlessSequenceMethod: String
    let useLiveHeadWindow, enableDynamicHdrInHardware: Bool
    let ultralowAudioQualityBandwidthThresholdBps: Int
    let ignoreUnneededSeeksToLiveHead: Bool
    let drmMetricsQoeLoggingFraction: Double
    let useTimeSeriesBufferPrediction: Bool
    let slidingPercentileScalar: Int

    enum CodingKeys: String, CodingKey {
        case useExoPlayer, useAdaptiveBitrate, maxInitialByteRate
        case minDurationForQualityIncreaseMS = "minDurationForQualityIncreaseMs"
        case maxDurationForQualityDecreaseMS = "maxDurationForQualityDecreaseMs"
        case minDurationToRetainAfterDiscardMS = "minDurationToRetainAfterDiscardMs"
        case lowWatermarkMS = "lowWatermarkMs"
        case highWatermarkMS = "highWatermarkMs"
        case lowPoolLoad, highPoolLoad, sufficientBandwidthOverhead
        case bufferChunkSizeKB = "bufferChunkSizeKb"
        case httpConnectTimeoutMS = "httpConnectTimeoutMs"
        case httpReadTimeoutMS = "httpReadTimeoutMs"
        case numAudioSegmentsPerFetch, numVideoSegmentsPerFetch
        case minDurationForPlaybackStartMS = "minDurationForPlaybackStartMs"
        case enableExoplayerReuse, useRadioTypeForInitialQualitySelection, blacklistFormatOnError
        case enableBandaidHTTPDataSource = "enableBandaidHttpDataSource"
        case httpLoadTimeoutMS = "httpLoadTimeoutMs"
        case canPlayHDDRM = "canPlayHdDrm"
        case videoBufferSegmentCount, audioBufferSegmentCount, useAbruptSplicing, minRetryCount, minChunksNeededToPreferOffline, secondsToMaxAggressiveness, enableSurfaceviewResizeWorkaround, enableVp9IfThresholdsPass, matchQualityToViewportOnUnfullscreen, lowAudioQualityConnTypes, useDashForLiveStreams, enableLibvpxVideoTrackRenderer, lowAudioQualityBandwidthThresholdBps, enableVariableSpeedPlayback, preferOnesieBufferedFormat, minimumBandwidthSampleBytes, useDashForOtfAndCompletedLiveStreams, disableCacheAwareVideoFormatEvaluation
        case useLiveDVRForDashLiveStreams = "useLiveDvrForDashLiveStreams"
        case cronetResetTimeoutOnRedirects, emitVideoDecoderChangeEvents
        case onesieVideoBufferLoadTimeoutMS = "onesieVideoBufferLoadTimeoutMs"
        case onesieVideoBufferReadTimeoutMS = "onesieVideoBufferReadTimeoutMs"
        case libvpxEnableGl, enableVp9EncryptedIfThresholdsPass, enableOpus, usePredictedBuffer
        case maxReadAheadMediaTimeMS = "maxReadAheadMediaTimeMs"
        case useMediaTimeCappedLoadControl, allowCacheOverrideToLowerQualitiesWithinRange, allowDroppingUndecodedFrames
        case minDurationForPlaybackRestartMS = "minDurationForPlaybackRestartMs"
        case serverProvidedBandwidthHeader, liveOnlyPegStrategy, enableRedirectorHostFallback, enableHighlyAvailableFormatFallbackOnPcr, recordTrackRendererTimingEvents, minErrorsForRedirectorHostFallback, nonHardwareMediaCodecNames, enableVp9IfInHardware, enableVp9EncryptedIfInHardware, useOpusMedAsLowQualityAudio, minErrorsForPcrFallback
        case useStickyRedirectHTTPDataSource = "useStickyRedirectHttpDataSource"
        case onlyVideoBandwidth, useRedirectorOnNetworkChange
        case enableMaxReadaheadABRThreshold = "enableMaxReadaheadAbrThreshold"
        case cacheCheckDirectoryWritabilityOnce, predictorType, slidingPercentile, slidingWindowSize
        case maxFrameDropIntervalMS = "maxFrameDropIntervalMs"
        case ignoreLoadTimeoutForFallback, serverBweMultiplier
        case drmMaxKeyfetchDelayMS = "drmMaxKeyfetchDelayMs"
        case maxResolutionForWhiteNoise, whiteNoiseRenderEffectMode, enableLibvpxHdr, enableCacheAwareStreamSelection, useExoCronetDataSource, whiteNoiseScale, whiteNoiseOffset, preventVideoFrameLaggingWithLibvpx, enableMediaCodecHdr, enableMediaCodecSwHdr, liveOnlyWindowChunks
        case bearerMinDurationToRetainAfterDiscardMS = "bearerMinDurationToRetainAfterDiscardMs"
        case forceWidevineL3, useAverageBitrate, useMedialibAudioTrackRendererForLive, useExoPlayerV2
        case logMediaRequestEventsToCSI = "logMediaRequestEventsToCsi"
        case onesieFixNonZeroStartTimeFormatSelection, liveOnlyReadaheadStepSizeChunks, liveOnlyBufferHealthHalfLifeSeconds, liveOnlyMinBufferHealthRatio, liveOnlyMinLatencyToSeekRatio, manifestlessPartialChunkStrategy, ignoreViewportSizeWhenSticky, enableLibvpxFallback, disableLibvpxLoopFilter, enableVpxMediaView, hdrMinScreenBrightness, hdrMaxScreenBrightnessThreshold, onesieDataSourceAboveCacheDataSource
        case httpNonplayerLoadTimeoutMS = "httpNonplayerLoadTimeoutMs"
        case numVideoSegmentsPerFetchStrategy
        case maxVideoDurationPerFetchMS = "maxVideoDurationPerFetchMs"
        case maxVideoEstimatedLoadDurationMS = "maxVideoEstimatedLoadDurationMs"
        case estimatedServerClockHalfLife, estimatedServerClockStrictOffset
        case minReadAheadMediaTimeMS = "minReadAheadMediaTimeMs"
        case readAheadGrowthRate, useDynamicReadAhead
        case useYtVODMediaSourceForV2 = "useYtVodMediaSourceForV2"
        case enableV2Gapless, useLiveHeadTimeMillis, allowTrackSelectionWithUpdatedVideoItagsForExoV2
        case maxAllowableTimeBeforeMediaTimeUpdateSEC = "maxAllowableTimeBeforeMediaTimeUpdateSec"
        case enableDynamicHdr, v2PerformEarlyStreamSelection, v2UsePlaybackStreamSelectionResult
        case v2MinTimeBetweenABRReevaluationMS = "v2MinTimeBetweenAbrReevaluationMs"
        case avoidReusePlaybackAcrossLoadvideos, enableInfiniteNetworkLoadingRetries, reportExoPlayerStateOnTransition, manifestlessSequenceMethod, useLiveHeadWindow, enableDynamicHdrInHardware, ultralowAudioQualityBandwidthThresholdBps, ignoreUnneededSeeksToLiveHead, drmMetricsQoeLoggingFraction, useTimeSeriesBufferPrediction, slidingPercentileScalar
    }
}

// MARK: - ResponseContext
struct ResponseContext: Codable {
    let visitorData: String
}

// MARK: - StreamingData
struct StreamingData: Codable {
    let expiresInSeconds: String
    let formats, adaptiveFormats: [Format]
}

// MARK: - Format
struct Format: Codable {
    let itag: Int
    let url: String
    let mimeType: String
    let bitrate: Int
    let width, height: Int?
    let initRange, indexRange: APIRange?
    let lastModified: String
    let contentLength: String?
    let quality: String
    let fps: Int?
    let qualityLabel: String?
    let projectionType: ProjectionType
    let averageBitrate: Int?
    let approxDurationMS: String
    let highReplication: Bool?
    let audioQuality, audioSampleRate: String?
    let audioChannels: Int?

    enum CodingKeys: String, CodingKey {
        case itag, url, mimeType, bitrate, width, height, initRange, indexRange, lastModified, contentLength, quality, fps, qualityLabel, projectionType, averageBitrate
        case approxDurationMS = "approxDurationMs"
        case highReplication, audioQuality, audioSampleRate, audioChannels
    }
}

// MARK: - ColorInfo
struct ColorInfo: Codable {
    let primaries: Primaries
    let transferCharacteristics: TransferCharacteristics
    let matrixCoefficients: MatrixCoefficients
}

enum MatrixCoefficients: String, Codable {
    case colorMatrixCoefficientsBt709 = "COLOR_MATRIX_COEFFICIENTS_BT709"
}

enum Primaries: String, Codable {
    case colorPrimariesBt709 = "COLOR_PRIMARIES_BT709"
}

enum TransferCharacteristics: String, Codable {
    case colorTransferCharacteristicsBt709 = "COLOR_TRANSFER_CHARACTERISTICS_BT709"
}

// MARK: - Range
struct APIRange: Codable {
    let start, end: String
}

enum ProjectionType: String, Codable {
    case rectangular = "RECTANGULAR"
}

// MARK: - VideoDetails
struct VideoDetails: Codable {
    let videoID, title, lengthSeconds, channelID: String
    let isOwnerViewing: Bool
    let shortDescription: String
    let isCrawlable: Bool
    let thumbnail: VideoDetailsThumbnail
    let allowRatings: Bool
    let viewCount, author: String
    let isPrivate, isUnpluggedCorpus, isLiveContent: Bool

    enum CodingKeys: String, CodingKey {
        case videoID = "videoId"
        case title, lengthSeconds
        case channelID = "channelId"
        case isOwnerViewing, shortDescription, isCrawlable, thumbnail, allowRatings, viewCount, author, isPrivate, isUnpluggedCorpus, isLiveContent
    }
}

// MARK: - VideoDetailsThumbnail
struct VideoDetailsThumbnail: Codable {
    let thumbnails: [ThumbnailElement]
}

// MARK: - ThumbnailElement
struct ThumbnailElement: Codable {
    let url: String
    let width, height: Int
}
