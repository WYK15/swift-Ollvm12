; NOTE: Assertions have been autogenerated by utils/update_mir_test_checks.py
; RUN: llc -global-isel -mtriple=amdgcn-mesa-mesa3d -mcpu=gfx1010 -stop-after=instruction-select -verify-machineinstrs -o - %s | FileCheck %s

define amdgpu_ps float @raw_tbuffer_load_f32__sgpr_rsrc__vgpr_voffset__sgpr_soffset(<4 x i32> inreg %rsrc, i32 %voffset, i32 inreg %soffset) {
  ; CHECK-LABEL: name: raw_tbuffer_load_f32__sgpr_rsrc__vgpr_voffset__sgpr_soffset
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $vgpr0
  ; CHECK:   [[COPY:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; CHECK:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; CHECK:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; CHECK:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; CHECK:   [[COPY4:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; CHECK:   [[COPY5:%[0-9]+]]:sreg_32 = COPY $sgpr6
  ; CHECK:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1, [[COPY2]], %subreg.sub2, [[COPY3]], %subreg.sub3
  ; CHECK:   [[TBUFFER_LOAD_FORMAT_X_OFFEN:%[0-9]+]]:vgpr_32 = TBUFFER_LOAD_FORMAT_X_OFFEN [[COPY4]], [[REG_SEQUENCE]], [[COPY5]], 0, 78, 0, 0, 0, 0, 0, implicit $exec :: (dereferenceable load 4 from custom "TargetCustom7", align 1, addrspace 4)
  ; CHECK:   $vgpr0 = COPY [[TBUFFER_LOAD_FORMAT_X_OFFEN]]
  ; CHECK:   SI_RETURN_TO_EPILOG implicit $vgpr0
  %val = call float @llvm.amdgcn.raw.tbuffer.load.f32(<4 x i32> %rsrc, i32 %voffset, i32 %soffset, i32 78, i32 0)
  ret float %val
}

define amdgpu_ps <2 x float> @raw_tbuffer_load_v2f32__sgpr_rsrc__vgpr_voffset__sgpr_soffset(<4 x i32> inreg %rsrc, i32 %voffset, i32 inreg %soffset) {
  ; CHECK-LABEL: name: raw_tbuffer_load_v2f32__sgpr_rsrc__vgpr_voffset__sgpr_soffset
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $vgpr0
  ; CHECK:   [[COPY:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; CHECK:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; CHECK:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; CHECK:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; CHECK:   [[COPY4:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; CHECK:   [[COPY5:%[0-9]+]]:sreg_32 = COPY $sgpr6
  ; CHECK:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1, [[COPY2]], %subreg.sub2, [[COPY3]], %subreg.sub3
  ; CHECK:   [[TBUFFER_LOAD_FORMAT_XY_OFFEN:%[0-9]+]]:vreg_64 = TBUFFER_LOAD_FORMAT_XY_OFFEN [[COPY4]], [[REG_SEQUENCE]], [[COPY5]], 0, 78, 0, 0, 0, 0, 0, implicit $exec :: (dereferenceable load 8 from custom "TargetCustom7", align 1, addrspace 4)
  ; CHECK:   [[COPY6:%[0-9]+]]:vgpr_32 = COPY [[TBUFFER_LOAD_FORMAT_XY_OFFEN]].sub0
  ; CHECK:   [[COPY7:%[0-9]+]]:vgpr_32 = COPY [[TBUFFER_LOAD_FORMAT_XY_OFFEN]].sub1
  ; CHECK:   $vgpr0 = COPY [[COPY6]]
  ; CHECK:   $vgpr1 = COPY [[COPY7]]
  ; CHECK:   SI_RETURN_TO_EPILOG implicit $vgpr0, implicit $vgpr1
  %val = call <2 x float> @llvm.amdgcn.raw.tbuffer.load.v2f32(<4 x i32> %rsrc, i32 %voffset, i32 %soffset, i32 78, i32 0)
  ret <2 x float> %val
}

define amdgpu_ps <3 x float> @raw_tbuffer_load_v3f32__sgpr_rsrc__vgpr_voffset__sgpr_soffset(<4 x i32> inreg %rsrc, i32 %voffset, i32 inreg %soffset) {
  ; CHECK-LABEL: name: raw_tbuffer_load_v3f32__sgpr_rsrc__vgpr_voffset__sgpr_soffset
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $vgpr0
  ; CHECK:   [[COPY:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; CHECK:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; CHECK:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; CHECK:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; CHECK:   [[COPY4:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; CHECK:   [[COPY5:%[0-9]+]]:sreg_32 = COPY $sgpr6
  ; CHECK:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1, [[COPY2]], %subreg.sub2, [[COPY3]], %subreg.sub3
  ; CHECK:   [[TBUFFER_LOAD_FORMAT_XYZ_OFFEN:%[0-9]+]]:vreg_96 = TBUFFER_LOAD_FORMAT_XYZ_OFFEN [[COPY4]], [[REG_SEQUENCE]], [[COPY5]], 0, 78, 0, 0, 0, 0, 0, implicit $exec :: (dereferenceable load 12 from custom "TargetCustom7", align 1, addrspace 4)
  ; CHECK:   [[COPY6:%[0-9]+]]:vgpr_32 = COPY [[TBUFFER_LOAD_FORMAT_XYZ_OFFEN]].sub0
  ; CHECK:   [[COPY7:%[0-9]+]]:vgpr_32 = COPY [[TBUFFER_LOAD_FORMAT_XYZ_OFFEN]].sub1
  ; CHECK:   [[COPY8:%[0-9]+]]:vgpr_32 = COPY [[TBUFFER_LOAD_FORMAT_XYZ_OFFEN]].sub2
  ; CHECK:   $vgpr0 = COPY [[COPY6]]
  ; CHECK:   $vgpr1 = COPY [[COPY7]]
  ; CHECK:   $vgpr2 = COPY [[COPY8]]
  ; CHECK:   SI_RETURN_TO_EPILOG implicit $vgpr0, implicit $vgpr1, implicit $vgpr2
  %val = call <3 x float> @llvm.amdgcn.raw.tbuffer.load.v3f32(<4 x i32> %rsrc, i32 %voffset, i32 %soffset, i32 78, i32 0)
  ret <3 x float> %val
}

define amdgpu_ps <4 x float> @raw_tbuffer_load_v4f32__sgpr_rsrc__vgpr_voffset__sgpr_soffset(<4 x i32> inreg %rsrc, i32 %voffset, i32 inreg %soffset) {
  ; CHECK-LABEL: name: raw_tbuffer_load_v4f32__sgpr_rsrc__vgpr_voffset__sgpr_soffset
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $vgpr0
  ; CHECK:   [[COPY:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; CHECK:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; CHECK:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; CHECK:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; CHECK:   [[COPY4:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; CHECK:   [[COPY5:%[0-9]+]]:sreg_32 = COPY $sgpr6
  ; CHECK:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1, [[COPY2]], %subreg.sub2, [[COPY3]], %subreg.sub3
  ; CHECK:   [[TBUFFER_LOAD_FORMAT_XYZW_OFFEN:%[0-9]+]]:vreg_128 = TBUFFER_LOAD_FORMAT_XYZW_OFFEN [[COPY4]], [[REG_SEQUENCE]], [[COPY5]], 0, 78, 0, 0, 0, 0, 0, implicit $exec :: (dereferenceable load 16 from custom "TargetCustom7", align 1, addrspace 4)
  ; CHECK:   [[COPY6:%[0-9]+]]:vgpr_32 = COPY [[TBUFFER_LOAD_FORMAT_XYZW_OFFEN]].sub0
  ; CHECK:   [[COPY7:%[0-9]+]]:vgpr_32 = COPY [[TBUFFER_LOAD_FORMAT_XYZW_OFFEN]].sub1
  ; CHECK:   [[COPY8:%[0-9]+]]:vgpr_32 = COPY [[TBUFFER_LOAD_FORMAT_XYZW_OFFEN]].sub2
  ; CHECK:   [[COPY9:%[0-9]+]]:vgpr_32 = COPY [[TBUFFER_LOAD_FORMAT_XYZW_OFFEN]].sub3
  ; CHECK:   $vgpr0 = COPY [[COPY6]]
  ; CHECK:   $vgpr1 = COPY [[COPY7]]
  ; CHECK:   $vgpr2 = COPY [[COPY8]]
  ; CHECK:   $vgpr3 = COPY [[COPY9]]
  ; CHECK:   SI_RETURN_TO_EPILOG implicit $vgpr0, implicit $vgpr1, implicit $vgpr2, implicit $vgpr3
  %val = call <4 x float> @llvm.amdgcn.raw.tbuffer.load.v4f32(<4 x i32> %rsrc, i32 %voffset, i32 %soffset, i32 78, i32 0)
  ret <4 x float> %val
}

define amdgpu_ps float @raw_tbuffer_load_f32__vgpr_rsrc__sgpr_voffset__vgpr_soffset(<4 x i32> %rsrc, i32 inreg %voffset, i32 %soffset) {
  ; CHECK-LABEL: name: raw_tbuffer_load_f32__vgpr_rsrc__sgpr_voffset__vgpr_soffset
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   successors: %bb.2(0x80000000)
  ; CHECK:   liveins: $sgpr2, $vgpr0, $vgpr1, $vgpr2, $vgpr3, $vgpr4
  ; CHECK:   [[COPY:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; CHECK:   [[COPY1:%[0-9]+]]:vgpr_32 = COPY $vgpr1
  ; CHECK:   [[COPY2:%[0-9]+]]:vgpr_32 = COPY $vgpr2
  ; CHECK:   [[COPY3:%[0-9]+]]:vgpr_32 = COPY $vgpr3
  ; CHECK:   [[COPY4:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; CHECK:   [[COPY5:%[0-9]+]]:vgpr_32 = COPY $vgpr4
  ; CHECK:   [[REG_SEQUENCE:%[0-9]+]]:vreg_128 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1, [[COPY2]], %subreg.sub2, [[COPY3]], %subreg.sub3
  ; CHECK:   [[COPY6:%[0-9]+]]:vgpr_32 = COPY [[COPY4]]
  ; CHECK:   [[COPY7:%[0-9]+]]:vreg_64 = COPY [[REG_SEQUENCE]].sub0_sub1
  ; CHECK:   [[COPY8:%[0-9]+]]:vreg_64 = COPY [[REG_SEQUENCE]].sub2_sub3
  ; CHECK:   [[S_MOV_B32_term:%[0-9]+]]:sreg_32_xm0_xexec = S_MOV_B32_term $exec_lo
  ; CHECK: bb.2:
  ; CHECK:   successors: %bb.3(0x40000000), %bb.2(0x40000000)
  ; CHECK:   [[V_READFIRSTLANE_B32_:%[0-9]+]]:sreg_32_xm0 = V_READFIRSTLANE_B32 [[COPY7]].sub0, implicit $exec
  ; CHECK:   [[V_READFIRSTLANE_B32_1:%[0-9]+]]:sreg_32_xm0 = V_READFIRSTLANE_B32 [[COPY7]].sub1, implicit $exec
  ; CHECK:   [[REG_SEQUENCE1:%[0-9]+]]:sreg_64_xexec = REG_SEQUENCE [[V_READFIRSTLANE_B32_]], %subreg.sub0, [[V_READFIRSTLANE_B32_1]], %subreg.sub1
  ; CHECK:   [[V_CMP_EQ_U64_e64_:%[0-9]+]]:sreg_32_xm0_xexec = V_CMP_EQ_U64_e64 [[REG_SEQUENCE1]], [[COPY7]], implicit $exec
  ; CHECK:   [[V_READFIRSTLANE_B32_2:%[0-9]+]]:sreg_32_xm0 = V_READFIRSTLANE_B32 [[COPY8]].sub0, implicit $exec
  ; CHECK:   [[V_READFIRSTLANE_B32_3:%[0-9]+]]:sreg_32_xm0 = V_READFIRSTLANE_B32 [[COPY8]].sub1, implicit $exec
  ; CHECK:   [[REG_SEQUENCE2:%[0-9]+]]:sreg_64_xexec = REG_SEQUENCE [[V_READFIRSTLANE_B32_2]], %subreg.sub0, [[V_READFIRSTLANE_B32_3]], %subreg.sub1
  ; CHECK:   [[V_CMP_EQ_U64_e64_1:%[0-9]+]]:sreg_32_xm0_xexec = V_CMP_EQ_U64_e64 [[REG_SEQUENCE2]], [[COPY8]], implicit $exec
  ; CHECK:   [[S_AND_B32_:%[0-9]+]]:sreg_32_xm0_xexec = S_AND_B32 [[V_CMP_EQ_U64_e64_1]], [[V_CMP_EQ_U64_e64_]], implicit-def $scc
  ; CHECK:   [[REG_SEQUENCE3:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[V_READFIRSTLANE_B32_]], %subreg.sub0, [[V_READFIRSTLANE_B32_1]], %subreg.sub1, [[V_READFIRSTLANE_B32_2]], %subreg.sub2, [[V_READFIRSTLANE_B32_3]], %subreg.sub3
  ; CHECK:   [[V_READFIRSTLANE_B32_4:%[0-9]+]]:sreg_32_xm0 = V_READFIRSTLANE_B32 [[COPY5]], implicit $exec
  ; CHECK:   [[V_CMP_EQ_U32_e64_:%[0-9]+]]:sreg_32_xm0_xexec = V_CMP_EQ_U32_e64 [[V_READFIRSTLANE_B32_4]], [[COPY5]], implicit $exec
  ; CHECK:   [[S_AND_B32_1:%[0-9]+]]:sreg_32_xm0_xexec = S_AND_B32 [[V_CMP_EQ_U32_e64_]], [[S_AND_B32_]], implicit-def $scc
  ; CHECK:   [[TBUFFER_LOAD_FORMAT_X_OFFEN:%[0-9]+]]:vgpr_32 = TBUFFER_LOAD_FORMAT_X_OFFEN [[COPY6]], [[REG_SEQUENCE3]], [[V_READFIRSTLANE_B32_4]], 0, 78, 0, 0, 0, 0, 0, implicit $exec :: (dereferenceable load 4 from custom "TargetCustom7", align 1, addrspace 4)
  ; CHECK:   [[S_AND_SAVEEXEC_B32_:%[0-9]+]]:sreg_32_xm0_xexec = S_AND_SAVEEXEC_B32 killed [[S_AND_B32_1]], implicit-def $exec, implicit-def $scc, implicit $exec
  ; CHECK:   $exec_lo = S_XOR_B32_term $exec_lo, [[S_AND_SAVEEXEC_B32_]], implicit-def $scc
  ; CHECK:   S_CBRANCH_EXECNZ %bb.2, implicit $exec
  ; CHECK: bb.3:
  ; CHECK:   successors: %bb.4(0x80000000)
  ; CHECK:   $exec_lo = S_MOV_B32_term [[S_MOV_B32_term]]
  ; CHECK: bb.4:
  ; CHECK:   $vgpr0 = COPY [[TBUFFER_LOAD_FORMAT_X_OFFEN]]
  ; CHECK:   SI_RETURN_TO_EPILOG implicit $vgpr0
  %val = call float @llvm.amdgcn.raw.tbuffer.load.f32(<4 x i32> %rsrc, i32 %voffset, i32 %soffset, i32 78, i32 0)
  ret float %val
}

define amdgpu_ps float @raw_tbuffer_load_f32__sgpr_rsrc__vgpr_voffset__sgpr_soffset_glc(<4 x i32> inreg %rsrc, i32 %voffset, i32 inreg %soffset) {
  ; CHECK-LABEL: name: raw_tbuffer_load_f32__sgpr_rsrc__vgpr_voffset__sgpr_soffset_glc
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $vgpr0
  ; CHECK:   [[COPY:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; CHECK:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; CHECK:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; CHECK:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; CHECK:   [[COPY4:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; CHECK:   [[COPY5:%[0-9]+]]:sreg_32 = COPY $sgpr6
  ; CHECK:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1, [[COPY2]], %subreg.sub2, [[COPY3]], %subreg.sub3
  ; CHECK:   [[TBUFFER_LOAD_FORMAT_X_OFFEN:%[0-9]+]]:vgpr_32 = TBUFFER_LOAD_FORMAT_X_OFFEN [[COPY4]], [[REG_SEQUENCE]], [[COPY5]], 0, 78, 1, 0, 0, 0, 0, implicit $exec :: (dereferenceable load 4 from custom "TargetCustom7", align 1, addrspace 4)
  ; CHECK:   $vgpr0 = COPY [[TBUFFER_LOAD_FORMAT_X_OFFEN]]
  ; CHECK:   SI_RETURN_TO_EPILOG implicit $vgpr0
  %val = call float @llvm.amdgcn.raw.tbuffer.load.f32(<4 x i32> %rsrc, i32 %voffset, i32 %soffset, i32 78, i32 1)
  ret float %val
}

define amdgpu_ps float @raw_tbuffer_load_f32__sgpr_rsrc__vgpr_voffset__sgpr_soffset_slc(<4 x i32> inreg %rsrc, i32 %voffset, i32 inreg %soffset) {
  ; CHECK-LABEL: name: raw_tbuffer_load_f32__sgpr_rsrc__vgpr_voffset__sgpr_soffset_slc
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $vgpr0
  ; CHECK:   [[COPY:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; CHECK:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; CHECK:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; CHECK:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; CHECK:   [[COPY4:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; CHECK:   [[COPY5:%[0-9]+]]:sreg_32 = COPY $sgpr6
  ; CHECK:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1, [[COPY2]], %subreg.sub2, [[COPY3]], %subreg.sub3
  ; CHECK:   [[TBUFFER_LOAD_FORMAT_X_OFFEN:%[0-9]+]]:vgpr_32 = TBUFFER_LOAD_FORMAT_X_OFFEN [[COPY4]], [[REG_SEQUENCE]], [[COPY5]], 0, 78, 0, 1, 0, 0, 0, implicit $exec :: (dereferenceable load 4 from custom "TargetCustom7", align 1, addrspace 4)
  ; CHECK:   $vgpr0 = COPY [[TBUFFER_LOAD_FORMAT_X_OFFEN]]
  ; CHECK:   SI_RETURN_TO_EPILOG implicit $vgpr0
  %val = call float @llvm.amdgcn.raw.tbuffer.load.f32(<4 x i32> %rsrc, i32 %voffset, i32 %soffset, i32 78, i32 2)
  ret float %val
}

define amdgpu_ps float @raw_tbuffer_load_f32__sgpr_rsrc__vgpr_voffset__sgpr_soffset_slc_glc(<4 x i32> inreg %rsrc, i32 %voffset, i32 inreg %soffset) {
  ; CHECK-LABEL: name: raw_tbuffer_load_f32__sgpr_rsrc__vgpr_voffset__sgpr_soffset_slc_glc
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $vgpr0
  ; CHECK:   [[COPY:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; CHECK:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; CHECK:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; CHECK:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; CHECK:   [[COPY4:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; CHECK:   [[COPY5:%[0-9]+]]:sreg_32 = COPY $sgpr6
  ; CHECK:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1, [[COPY2]], %subreg.sub2, [[COPY3]], %subreg.sub3
  ; CHECK:   [[TBUFFER_LOAD_FORMAT_X_OFFEN:%[0-9]+]]:vgpr_32 = TBUFFER_LOAD_FORMAT_X_OFFEN [[COPY4]], [[REG_SEQUENCE]], [[COPY5]], 0, 78, 1, 1, 0, 0, 0, implicit $exec :: (dereferenceable load 4 from custom "TargetCustom7", align 1, addrspace 4)
  ; CHECK:   $vgpr0 = COPY [[TBUFFER_LOAD_FORMAT_X_OFFEN]]
  ; CHECK:   SI_RETURN_TO_EPILOG implicit $vgpr0
  %val = call float @llvm.amdgcn.raw.tbuffer.load.f32(<4 x i32> %rsrc, i32 %voffset, i32 %soffset, i32 78, i32 3)
  ret float %val
}

define amdgpu_ps float @raw_tbuffer_load_f32__sgpr_rsrc__vgpr_voffset__sgpr_soffset_dlc(<4 x i32> inreg %rsrc, i32 %voffset, i32 inreg %soffset) {
  ; CHECK-LABEL: name: raw_tbuffer_load_f32__sgpr_rsrc__vgpr_voffset__sgpr_soffset_dlc
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $vgpr0
  ; CHECK:   [[COPY:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; CHECK:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; CHECK:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; CHECK:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; CHECK:   [[COPY4:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; CHECK:   [[COPY5:%[0-9]+]]:sreg_32 = COPY $sgpr6
  ; CHECK:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1, [[COPY2]], %subreg.sub2, [[COPY3]], %subreg.sub3
  ; CHECK:   [[TBUFFER_LOAD_FORMAT_X_OFFEN:%[0-9]+]]:vgpr_32 = TBUFFER_LOAD_FORMAT_X_OFFEN [[COPY4]], [[REG_SEQUENCE]], [[COPY5]], 0, 78, 0, 0, 0, 1, 0, implicit $exec :: (dereferenceable load 4 from custom "TargetCustom7", align 1, addrspace 4)
  ; CHECK:   $vgpr0 = COPY [[TBUFFER_LOAD_FORMAT_X_OFFEN]]
  ; CHECK:   SI_RETURN_TO_EPILOG implicit $vgpr0
  %val = call float @llvm.amdgcn.raw.tbuffer.load.f32(<4 x i32> %rsrc, i32 %voffset, i32 %soffset, i32 78, i32 4)
  ret float %val
}

declare float @llvm.amdgcn.raw.tbuffer.load.f32(<4 x i32>, i32, i32, i32 immarg, i32 immarg) #0
declare <2 x float> @llvm.amdgcn.raw.tbuffer.load.v2f32(<4 x i32>, i32, i32, i32 immarg, i32 immarg) #0
declare <3 x float> @llvm.amdgcn.raw.tbuffer.load.v3f32(<4 x i32>, i32, i32, i32 immarg, i32 immarg) #0
declare <4 x float> @llvm.amdgcn.raw.tbuffer.load.v4f32(<4 x i32>, i32, i32, i32 immarg, i32 immarg) #0

attributes #0 = { nounwind readonly }