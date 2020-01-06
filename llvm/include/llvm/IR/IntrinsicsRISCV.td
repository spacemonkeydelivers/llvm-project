//===- IntrinsicsRISCV.td - Defines RISCV intrinsics -------*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file defines all of the RISCV-specific intrinsics.
//
//===----------------------------------------------------------------------===//

let TargetPrefix = "riscv" in {

//===----------------------------------------------------------------------===//
// Atomics

class MaskedAtomicRMW32Intrinsic
    : Intrinsic<[llvm_i32_ty],
                [llvm_anyptr_ty, llvm_i32_ty, llvm_i32_ty, llvm_i32_ty],
                [IntrArgMemOnly, NoCapture<0>, ImmArg<3>]>;

class MaskedAtomicRMW32WithSextIntrinsic
    : Intrinsic<[llvm_i32_ty],
                [llvm_anyptr_ty, llvm_i32_ty, llvm_i32_ty, llvm_i32_ty,
                 llvm_i32_ty],
                [IntrArgMemOnly, NoCapture<0>, ImmArg<4>]>;

def int_riscv_masked_atomicrmw_xchg_i32 : MaskedAtomicRMW32Intrinsic;
def int_riscv_masked_atomicrmw_add_i32  : MaskedAtomicRMW32Intrinsic;
def int_riscv_masked_atomicrmw_sub_i32  : MaskedAtomicRMW32Intrinsic;
def int_riscv_masked_atomicrmw_nand_i32 : MaskedAtomicRMW32Intrinsic;
def int_riscv_masked_atomicrmw_max_i32  : MaskedAtomicRMW32WithSextIntrinsic;
def int_riscv_masked_atomicrmw_min_i32  : MaskedAtomicRMW32WithSextIntrinsic;
def int_riscv_masked_atomicrmw_umax_i32 : MaskedAtomicRMW32Intrinsic;
def int_riscv_masked_atomicrmw_umin_i32 : MaskedAtomicRMW32Intrinsic;

def int_riscv_masked_cmpxchg_i32
    : Intrinsic<[llvm_i32_ty], [llvm_anyptr_ty, llvm_i32_ty, llvm_i32_ty,
                                llvm_i32_ty, llvm_i32_ty],
                [IntrArgMemOnly, NoCapture<0>, ImmArg<4>]>;

class MaskedAtomicRMW64Intrinsic
    : Intrinsic<[llvm_i64_ty],
                [llvm_anyptr_ty, llvm_i64_ty, llvm_i64_ty, llvm_i64_ty],
                [IntrArgMemOnly, NoCapture<0>, ImmArg<3>]>;

class MaskedAtomicRMW64WithSextIntrinsic
    : Intrinsic<[llvm_i64_ty],
                [llvm_anyptr_ty, llvm_i64_ty, llvm_i64_ty, llvm_i64_ty,
                 llvm_i64_ty],
                [IntrArgMemOnly, NoCapture<0>, ImmArg<4>]>;

def int_riscv_masked_atomicrmw_xchg_i64 : MaskedAtomicRMW64Intrinsic;
def int_riscv_masked_atomicrmw_add_i64  : MaskedAtomicRMW64Intrinsic;
def int_riscv_masked_atomicrmw_sub_i64  : MaskedAtomicRMW64Intrinsic;
def int_riscv_masked_atomicrmw_nand_i64 : MaskedAtomicRMW64Intrinsic;
def int_riscv_masked_atomicrmw_max_i64  : MaskedAtomicRMW64WithSextIntrinsic;
def int_riscv_masked_atomicrmw_min_i64  : MaskedAtomicRMW64WithSextIntrinsic;
def int_riscv_masked_atomicrmw_umax_i64 : MaskedAtomicRMW64Intrinsic;
def int_riscv_masked_atomicrmw_umin_i64 : MaskedAtomicRMW64Intrinsic;

def int_riscv_masked_cmpxchg_i64
    : Intrinsic<[llvm_i64_ty], [llvm_anyptr_ty, llvm_i64_ty, llvm_i64_ty,
                                llvm_i64_ty, llvm_i64_ty],
                [IntrArgMemOnly, NoCapture<0>, ImmArg<4>]>;

// MTE
def int_riscv_irg   : Intrinsic<[llvm_ptr_ty], [llvm_ptr_ty, llvm_i64_ty], [IntrInaccessibleMemOnly]>;
def int_riscv_addg  : Intrinsic<[llvm_ptr_ty], [llvm_ptr_ty, llvm_i64_ty], [IntrNoMem]>;
def int_riscv_gmi   : Intrinsic<[llvm_i64_ty], [llvm_ptr_ty, llvm_i64_ty], [IntrNoMem]>;
def int_riscv_ldg   : Intrinsic<[llvm_ptr_ty], [llvm_ptr_ty, llvm_ptr_ty], [IntrReadMem]>;
def int_riscv_stg   : Intrinsic<[], [llvm_ptr_ty, llvm_ptr_ty], [IntrWriteMem]>;
def int_riscv_subp  : Intrinsic<[llvm_i64_ty], [llvm_ptr_ty, llvm_ptr_ty], [IntrNoMem]>;

// The following are codegen-only intrinsics for stack instrumentation.

// Generate a randomly tagged stack base pointer.
def int_riscv_irg_sp   : Intrinsic<[llvm_ptr_ty], [llvm_i64_ty],
    [IntrInaccessibleMemOnly]>;

// Transfer pointer tag with offset.
// ptr1 = tagp(ptr0, baseptr, tag_offset) returns a pointer where
// * address is the address in ptr0
// * tag is a function of (tag in baseptr, tag_offset).
// Address bits in baseptr and tag bits in ptr0 are ignored.
// When offset between ptr0 and baseptr is a compile time constant, this can be emitted as
//   ADDG ptr1, baseptr, (ptr0 - baseptr), tag_offset
// It is intended that ptr0 is an alloca address, and baseptr is the direct output of llvm.aarch64.irg.sp.
def int_riscv_tagp : Intrinsic<[llvm_anyptr_ty], [LLVMMatchType<0>, llvm_ptr_ty, llvm_i64_ty],
    [IntrNoMem, ImmArg<2>]>;

// Update allocation tags for the memory range to match the tag in the pointer argument.
def int_riscv_settag  : Intrinsic<[], [llvm_ptr_ty, llvm_i64_ty],
    [IntrWriteMem, IntrArgMemOnly, NoCapture<0>, WriteOnly<0>]>;

// Update allocation tags for the memory range to match the tag in the pointer argument,
// and set memory contents to zero.
def int_riscv_settag_zero  : Intrinsic<[], [llvm_ptr_ty, llvm_i64_ty],
    [IntrWriteMem, IntrArgMemOnly, NoCapture<0>, WriteOnly<0>]>;

// Update allocation tags for 16-aligned, 16-sized memory region, and store a pair 8-byte values.
def int_riscv_stgp  : Intrinsic<[], [llvm_ptr_ty, llvm_i64_ty, llvm_i64_ty],
    [IntrWriteMem, IntrArgMemOnly, NoCapture<0>, WriteOnly<0>]>;

} // TargetPrefix = "riscv"
