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

declare i8* @llvm.riscv.irg(i8*, i32)
