//
//  cblas.swift
//  Matft
//
//  Created by Junnosuke Kado on 2020/03/07.
//  Copyright © 2020 jkado. All rights reserved.
//

import Foundation
import Accelerate

//convert order
internal typealias cblas_convorder_func<T> = (Int32, UnsafePointer<T>, Int32, UnsafeMutablePointer<T>, Int32) -> Void

internal func copy_unsafeptrT<T>(_ size: Int, _ srcptr: UnsafePointer<T>, _ srcStride: Int, _ dstptr: UnsafeMutablePointer<T>, _ dstStride: Int, _ cblas_func: cblas_convorder_func<T>){
    cblas_func(Int32(size), srcptr, Int32(srcStride), dstptr, Int32(dstStride))
}

internal func copy_by_cblas<T: Numeric>(_ mfarray: MfArray, dsttmpMfarray: MfArray, cblas_func: cblas_convorder_func<T>) -> MfArray{
    
    
    dsttmpMfarray.withDataUnsafeMBPtrT(datatype: T.self){
        dstptr in
        mfarray.withDataUnsafeMBPtrT(datatype: T.self){
            srcptr in
            for cblasPrams in OptOffsetParams(bigger_mfarray: dsttmpMfarray, smaller_mfarray: mfarray){
                copy_unsafeptrT(cblasPrams.blocksize, srcptr.baseAddress! + cblasPrams.s_offset, cblasPrams.s_stride, dstptr.baseAddress! + cblasPrams.b_offset, cblasPrams.b_stride, cblas_func)
            }
        }
    }
    
    return dsttmpMfarray
}
