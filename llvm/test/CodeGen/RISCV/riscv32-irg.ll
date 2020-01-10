; RUN: llc < %s -mtriple=riscv32  | FileCheck %s

; test create_tag
define i32* @create_tag(i32* %ptr, i32 %m) {
entry:
; CHECK-LABEL: create_tag:
  %0 = bitcast i32* %ptr to i8*
  %1 = tail call i8* @llvm.riscv.irg(i8* %0, i32 %m)
  %2 = bitcast i8* %1 to i32*
  ret i32* %2
;CHECK: irg x0, x0, {{x[0-9]+}}
}

define i8* @irg_imm16(i8* %p) {
entry:
; CHECK-LABEL: irg_imm16:
; CHECK: mov w[[R:[0-9]+]], #16
; CHECK: irg x0, x0, x[[R]]
; CHECK: ret
  %q = call i8* @llvm.riscv.irg(i8* %p, i32 16)
  ret i8* %q
}

define i8* @irg_imm0(i8* %p) {
entry:
; CHECK-LABEL: irg_imm0:
; CHECK: irg x0, x0{{$}}
; CHECK: ret
  %q = call i8* @llvm.riscv.irg(i8* %p, i32 0)
  ret i8* %q
}

define i8* @irg_reg(i8* %p, i32 %ex) {
entry:
; CHECK-LABEL: irg_reg:
; CHECK: irg x0, x0, x1
; CHECK: ret
  %q = call i8* @llvm.riscv.irg(i8* %p, i32 %ex)
  ret i8* %q
}

; undef argument in irg is treated specially
define i8* @irg_sp() {
entry:
; CHECK-LABEL: irg_sp:
; CHECK: irg x0, sp{{$}}
; CHECK: ret
  %q = call i8* @llvm.riscv.irg.sp(i32 0)
  ret i8* %q
}

declare i8* @llvm.riscv.irg(i8*, i32)
declare i8* @llvm.riscv.irg.sp(i32 %exclude)
