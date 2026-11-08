define internal fastcc void @_RNvNtCs8b9n3vPMt31_13blake3_servil4each11hash_cohort(ptr noalias nofree noundef nonnull align 64 %hashers.0, i64 noundef range(i64 0, 500399958596722) %hashers.1, ptr noalias nofree noundef nonnull readonly align 8 captures(address) %alike.0, i64 noundef range(i64 1, 1152921504606846976) %alike.1) unnamed_addr #2 personality ptr @rust_eh_personality !guid !4772 {
start:
  %vector.i = alloca [24 x i8], align 8
  %result = alloca [64 x i8], align 1
  %key = alloca [32 x i8], align 4
  %first = load i64, ptr %alike.0, align 8, !noundef !566
  %_9 = icmp ult i64 %first, %hashers.1
  br i1 %_9, label %bb2, label %panic3

bb2:                                              ; preds = %start
  %0 = getelementptr inbounds nuw [18432 x i8], ptr %hashers.0, i64 %first
  %1 = getelementptr inbounds nuw i8, ptr %0, i64 128
  call void @llvm.lifetime.start.p0(ptr nonnull %key)
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 4 dereferenceable(32) %key, ptr noundef nonnull align 64 dereferenceable(32) %1, i64 32, i1 false)
  %2 = getelementptr inbounds nuw i8, ptr %0, i64 106
  %flags = load i8, ptr %2, align 2, !noundef !566
  %3 = getelementptr inbounds nuw i8, ptr %0, i64 107
  %_12 = load i8, ptr %3, align 1, !range !891, !noundef !566
  %_16 = shl i64 %alike.1, 9
  %_39.not.i.i = icmp slt i64 %_16, 0
  br i1 %_39.not.i.i, label %bb6.i, label %bb18.i.i, !prof !2162

bb18.i.i:                                         ; preds = %bb2
  %4 = icmp eq i64 %_16, 0
  br i1 %4, label %bb5.i.peel.i.i.i, label %bb3.i.i

bb3.i.i:                                          ; preds = %bb18.i.i
; call __rustc::__rust_no_alloc_shim_is_unstable_v2
  tail call void @_RNvCs5fGHjzWXRav_7___rustc35___rust_no_alloc_shim_is_unstable_v2() #36, !noalias !4773
; call __rustc::__rust_alloc_zeroed
  %5 = tail call noundef ptr @_RNvCs5fGHjzWXRav_7___rustc19___rust_alloc_zeroed(i64 noundef range(i64 1, -9223372036854775808) %_16, i64 noundef range(i64 1, 129) 1) #36, !noalias !4773
  %6 = icmp eq ptr %5, null
  br i1 %6, label %bb6.i, label %bb10.i.i

bb10.i.i:                                         ; preds = %bb3.i.i
  %7 = ptrtoint ptr %5 to i64
  br label %bb5.i.peel.i.i.i

bb6.i:                                            ; preds = %bb3.i.i, %bb2
  %_10.sroa.4.0.ph.i = phi i64 [ 1, %bb3.i.i ], [ 0, %bb2 ]
; call alloc::raw_vec::handle_error
  tail call void @_RNvNtCsgFX3jaOk65H_5alloc7raw_vec12handle_error(i64 noundef %_10.sroa.4.0.ph.i, i64 %_16) #41
  unreachable

panic3:                                           ; preds = %start
; call core::panicking::panic_bounds_check
  tail call void @_RNvNtCskADBYZwJmSU_4core9panicking18panic_bounds_check(i64 noundef %first, i64 noundef %hashers.1, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(24) @alloc_0ff2b526c19f1ee3d287ac9ff8cb84ac) #44
  unreachable

bb5.i.peel.i.i.i:                                 ; preds = %bb10.i.i, %bb18.i.i
  %_10.sroa.10.0.i = phi i64 [ %7, %bb10.i.i ], [ 1, %bb18.i.i ]
  %8 = inttoptr i64 %_10.sroa.10.0.i to ptr
  %_116.idx = shl nuw nsw i64 %alike.1, 3
  %_116 = getelementptr inbounds nuw i8, ptr %alike.0, i64 %_116.idx
  call void @llvm.lifetime.start.p0(ptr nonnull %vector.i), !noalias !4778
  %_16.i.i.i.peel.i.i.i = getelementptr inbounds nuw i8, ptr %alike.0, i64 8
  %9 = getelementptr inbounds nuw i8, ptr %0, i64 18368
  %_3.i.i.i.i.peel.i.i.i = load i64, ptr %9, align 64, !alias.scope !4782, !noalias !4785, !noundef !566
  %10 = icmp eq i64 %_3.i.i.i.i.peel.i.i.i, 16384
  %11 = getelementptr inbounds nuw i8, ptr %0, i64 1936
  %_4.i.i.i.i.peel.i.i.i = load i64, ptr %11, align 16, !alias.scope !4782, !noalias !4785
  %_2.i.i.i.i.peel.i.i.i = icmp eq i64 %_4.i.i.i.i.peel.i.i.i, 0
  %or.cond.i.i.i.i.peel.i.i.i = select i1 %10, i1 %_2.i.i.i.i.peel.i.i.i, i1 false
  br i1 %or.cond.i.i.i.i.peel.i.i.i, label %_RINvMNtCskADBYZwJmSU_4core6optionINtB3_6OptionRINtNtNtB5_5slice4iter11ChunksExacthEE6map_orTjIBw_jEENvYBJ_NtNtNtNtB5_4iter6traits8iterator8Iterator9size_hintECs8b9n3vPMt31_13blake3_servil.exit54.i.i.i.i, label %bb5.i.i.i.i.i.i

bb5.i.i.i.i.i.i:                                  ; preds = %bb5.i.peel.i.i.i
; invoke core::option::expect_failed
  invoke void @_RNvNtCskADBYZwJmSU_4core6option13expect_failed(ptr noalias nofree noundef nonnull readonly captures(address, read_provenance) @alloc_892642cc7f6c32dc42749a5a71ace53a, i64 noundef 12, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(24) @alloc_d5960a87784418e80f2b77d70b9bc1be) #44
          to label %.noexc176 unwind label %cleanup6

.noexc176:                                        ; preds = %bb5.i.i.i.i.i.i
  unreachable

_RINvMNtCskADBYZwJmSU_4core6optionINtB3_6OptionRINtNtNtB5_5slice4iter11ChunksExacthEE6map_orTjIBw_jEENvYBJ_NtNtNtNtB5_4iter6traits8iterator8Iterator9size_hintECs8b9n3vPMt31_13blake3_servil.exit54.i.i.i.i: ; preds = %bb5.i.peel.i.i.i
; call __rustc::__rust_no_alloc_shim_is_unstable_v2
  tail call void @_RNvCs5fGHjzWXRav_7___rustc35___rust_no_alloc_shim_is_unstable_v2() #36, !noalias !4800
; call __rustc::__rust_alloc
  %12 = tail call noundef align 8 dereferenceable_or_null(128) ptr @_RNvCs5fGHjzWXRav_7___rustc12___rust_alloc(i64 noundef range(i64 0, -9223372036854775808) 128, i64 noundef range(i64 1, 129) 8) #36, !noalias !4800
  %13 = icmp eq ptr %12, null
  br i1 %13, label %bb3.i.i62, label %_RNvMs5_NtCsgFX3jaOk65H_5alloc7raw_vecNtB5_11RawVecInner16with_capacity_inCs8b9n3vPMt31_13blake3_servil.exit.i

bb3.i.i62:                                        ; preds = %_RINvMNtCskADBYZwJmSU_4core6optionINtB3_6OptionRINtNtNtB5_5slice4iter11ChunksExacthEE6map_orTjIBw_jEENvYBJ_NtNtNtNtB5_4iter6traits8iterator8Iterator9size_hintECs8b9n3vPMt31_13blake3_servil.exit54.i.i.i.i
; invoke alloc::raw_vec::handle_error
  invoke void @_RNvNtCsgFX3jaOk65H_5alloc7raw_vec12handle_error(i64 noundef 8, i64 128) #41
          to label %.noexc66 unwind label %cleanup6

.noexc66:                                         ; preds = %bb3.i.i62
  unreachable

_RNvMs5_NtCsgFX3jaOk65H_5alloc7raw_vecNtB5_11RawVecInner16with_capacity_inCs8b9n3vPMt31_13blake3_servil.exit.i: ; preds = %_RINvMNtCskADBYZwJmSU_4core6optionINtB3_6OptionRINtNtNtB5_5slice4iter11ChunksExacthEE6map_orTjIBw_jEENvYBJ_NtNtNtNtB5_4iter6traits8iterator8Iterator9size_hintECs8b9n3vPMt31_13blake3_servil.exit54.i.i.i.i
  %data.i.i.i.i.i.i.i = getelementptr inbounds nuw i8, ptr %0, i64 3008
  %_20.i.i.i.i.i.peel.i.i.i = getelementptr inbounds nuw i8, ptr %0, i64 1984
  store ptr %_20.i.i.i.i.i.peel.i.i.i, ptr %12, align 8, !noalias !4778, !captures !848
  store i64 16, ptr %vector.i, align 8, !noalias !4778
  %vector1.sroa.4.0.vector.sroa_idx.i = getelementptr inbounds nuw i8, ptr %vector.i, i64 8
  store ptr %12, ptr %vector1.sroa.4.0.vector.sroa_idx.i, align 8, !noalias !4778
  %vector1.sroa.6.0.vector.sroa_idx.i = getelementptr inbounds nuw i8, ptr %vector.i, i64 16
  store i64 1, ptr %vector1.sroa.6.0.vector.sroa_idx.i, align 8, !noalias !4778
  tail call void @llvm.experimental.noalias.scope.decl(metadata !4803)
  tail call void @llvm.experimental.noalias.scope.decl(metadata !4806)
  %data.i.i.i.i.i.i.i32.i = getelementptr inbounds nuw i8, ptr %0, i64 4032
  br label %bb3.i.i3.i

bb3.i.i3.i:                                       ; preds = %bb5.i.i, %_RNvMs5_NtCsgFX3jaOk65H_5alloc7raw_vecNtB5_11RawVecInner16with_capacity_inCs8b9n3vPMt31_13blake3_servil.exit.i
  %_23.i.i101.i = phi ptr [ %_23.i.i.i, %bb5.i.i ], [ %12, %_RNvMs5_NtCsgFX3jaOk65H_5alloc7raw_vecNtB5_11RawVecInner16with_capacity_inCs8b9n3vPMt31_13blake3_servil.exit.i ]
  %_19.sroa.13.0.i = phi ptr [ %data.i.i.i.i.i.i.i.i, %bb5.i.i ], [ %data.i.i.i.i.i.i.i32.i, %_RNvMs5_NtCsgFX3jaOk65H_5alloc7raw_vecNtB5_11RawVecInner16with_capacity_inCs8b9n3vPMt31_13blake3_servil.exit.i ]
  %_19.sroa.20.0.i = phi i64 [ %len.i.i.i.i.i.i.i.i, %bb5.i.i ], [ 14336, %_RNvMs5_NtCsgFX3jaOk65H_5alloc7raw_vecNtB5_11RawVecInner16with_capacity_inCs8b9n3vPMt31_13blake3_servil.exit.i ]
  %_19.sroa.0.0.i = phi ptr [ %_19.sroa.0.1.i, %bb5.i.i ], [ %_16.i.i.i.peel.i.i.i, %_RNvMs5_NtCsgFX3jaOk65H_5alloc7raw_vecNtB5_11RawVecInner16with_capacity_inCs8b9n3vPMt31_13blake3_servil.exit.i ]
  %self1.i.i.i = phi i64 [ %self15.i.i.i, %bb5.i.i ], [ 16, %_RNvMs5_NtCsgFX3jaOk65H_5alloc7raw_vecNtB5_11RawVecInner16with_capacity_inCs8b9n3vPMt31_13blake3_servil.exit.i ]
  %len.i.i.i = phi i64 [ %new_len.i.i.i, %bb5.i.i ], [ 1, %_RNvMs5_NtCsgFX3jaOk65H_5alloc7raw_vecNtB5_11RawVecInner16with_capacity_inCs8b9n3vPMt31_13blake3_servil.exit.i ]
  %14 = phi ptr [ %_20.i.i.i.i.i33.lcssa.i.i.i.i, %bb5.i.i ], [ %data.i.i.i.i.i.i.i, %_RNvMs5_NtCsgFX3jaOk65H_5alloc7raw_vecNtB5_11RawVecInner16with_capacity_inCs8b9n3vPMt31_13blake3_servil.exit.i ]
  %_19.i.i.i = icmp samesign ult i64 %len.i.i.i, 1152921504606846976
  tail call void @llvm.assume(i1 %_19.i.i.i)
  %_8.i.i.i = icmp eq i64 %len.i.i.i, %self1.i.i.i
  br i1 %_8.i.i.i, label %bb4.i.i.i, label %bb8.i.i.i

bb4.i.i.i:                                        ; preds = %bb3.i.i3.i
  %n.i.i.i.i.i.i.i.i.i236 = lshr i64 %_19.sroa.20.0.i, 10
  %_14.i.i.i234 = add nuw nsw i64 %n.i.i.i.i.i.i.i.i.i236, 1
; invoke <alloc::raw_vec::RawVecInner<_>>::reserve::do_reserve_and_handle::<alloc::alloc::Global>
  invoke fastcc void @_RINvNvMs2_NtCsgFX3jaOk65H_5alloc7raw_vecINtB8_11RawVecInnerpE7reserve21do_reserve_and_handleNtNtBa_5alloc6GlobalECs8b9n3vPMt31_13blake3_servil(ptr noalias nofree noundef nonnull align 8 dereferenceable(24) %vector.i, i64 noundef %self1.i.i.i, i64 noundef range(i64 1, 0) %_14.i.i.i234, i64 noundef 8, i64 noundef 8)
          to label %.noexc6.i unwind label %cleanup.loopexit.i, !noalias !4778

.noexc6.i:                                        ; preds = %bb4.i.i.i
  %self1.pre.i.i.i = load i64, ptr %vector.i, align 8, !range !567, !alias.scope !4809, !noalias !4810
  %_23.i.i.pre.i = load ptr, ptr %vector1.sroa.4.0.vector.sroa_idx.i, align 8, !alias.scope !4809, !noalias !4810
  br label %bb8.i.i.i

bb8.i.i.i:                                        ; preds = %.noexc6.i, %bb3.i.i3.i
  %_23.i.i.i = phi ptr [ %_23.i.i.pre.i, %.noexc6.i ], [ %_23.i.i101.i, %bb3.i.i3.i ]
  %self15.i.i.i = phi i64 [ %self1.pre.i.i.i, %.noexc6.i ], [ %self1.i.i.i, %bb3.i.i3.i ]
  %dst.i.i.i = getelementptr inbounds nuw [8 x i8], ptr %_23.i.i.i, i64 %len.i.i.i
  store ptr %14, ptr %dst.i.i.i, align 8, !noalias !4813, !captures !848
  %new_len.i.i.i = add nuw nsw i64 %len.i.i.i, 1
  store i64 %new_len.i.i.i, ptr %vector1.sroa.6.0.vector.sroa_idx.i, align 8, !alias.scope !4809, !noalias !4810
  %_6.not.i.i.i.peel.i.i.i.i = icmp ult i64 %_19.sroa.20.0.i, 1024
  br i1 %_6.not.i.i.i.peel.i.i.i.i, label %bb4.peel.i.i.i.i, label %bb5.i.i

bb4.peel.i.i.i.i:                                 ; preds = %bb8.i.i.i
  %_6.i.i.i.peel.i.i.i.i = icmp eq ptr %_19.sroa.0.0.i, %_116
  br i1 %_6.i.i.i.peel.i.i.i.i, label %bb5.i, label %bb5.i.i.peel.i.i.i.i

bb5.i.i.peel.i.i.i.i:                             ; preds = %bb4.peel.i.i.i.i
  %_16.i.i.i.peel.i.i.i.i = getelementptr inbounds nuw i8, ptr %_19.sroa.0.0.i, i64 8
  %.val.i.i.peel.i.i.i.i = load i64, ptr %_19.sroa.0.0.i, align 8, !noalias !4814, !noundef !566
  %_8.i.i.i.peel.i.i.i.i = icmp ult i64 %.val.i.i.peel.i.i.i.i, %hashers.1
  br i1 %_8.i.i.i.peel.i.i.i.i, label %bb1.i.i.i.peel.i.i.i.i, label %panic.i.i.i.i.i.i9.invoke.i

bb1.i.i.i.peel.i.i.i.i:                           ; preds = %bb5.i.i.peel.i.i.i.i
  %_6.i3.i.i.peel.i.i.i.i = getelementptr inbounds nuw [18432 x i8], ptr %hashers.0, i64 %.val.i.i.peel.i.i.i.i
  %15 = getelementptr inbounds nuw i8, ptr %_6.i3.i.i.peel.i.i.i.i, i64 18368
  %_3.i.i.i.i.peel.i.i.i.i = load i64, ptr %15, align 64, !alias.scope !4827, !noalias !4830, !noundef !566
  %16 = icmp eq i64 %_3.i.i.i.i.peel.i.i.i.i, 16384
  %17 = getelementptr inbounds nuw i8, ptr %_6.i3.i.i.peel.i.i.i.i, i64 1936
  %_4.i.i.i.i.peel.i.i.i.i = load i64, ptr %17, align 16, !alias.scope !4827, !noalias !4830
  %_2.i.i.i.i.peel.i.i.i.i = icmp eq i64 %_4.i.i.i.i.peel.i.i.i.i, 0
  %or.cond.i.i.i.i.peel.i.i.i.i = select i1 %16, i1 %_2.i.i.i.i.peel.i.i.i.i, i1 false
  br i1 %or.cond.i.i.i.i.peel.i.i.i.i, label %_RINvNtNtNtCskADBYZwJmSU_4core4iter8adapters7flatten17and_then_or_clearINtNtNtB8_5slice4iter11ChunksExacthERShNvYB16_NtNtNtB6_6traits8iterator8Iterator4nextECs8b9n3vPMt31_13blake3_servil.exit.loopexit.i.i.i.i, label %bb5.i.i.i.i.i.i.invoke.i

_RINvNtNtNtCskADBYZwJmSU_4core4iter8adapters7flatten17and_then_or_clearINtNtNtB8_5slice4iter11ChunksExacthERShNvYB16_NtNtNtB6_6traits8iterator8Iterator4nextECs8b9n3vPMt31_13blake3_servil.exit.loopexit.i.i.i.i: ; preds = %bb1.i.i.i.peel.i.i.i.i
  %_20.i.i.i.i.i.peel.i.i.i.i = getelementptr inbounds nuw i8, ptr %_6.i3.i.i.peel.i.i.i.i, i64 1984
  br label %bb5.i.i

panic.i.i.i.i.i.i9.invoke.i:                      ; preds = %bb5.i.i.peel.i.i.i.i
; invoke core::panicking::panic_bounds_check
  invoke void @_RNvNtCskADBYZwJmSU_4core9panicking18panic_bounds_check(i64 noundef %.val.i.i.peel.i.i.i.i, i64 noundef %hashers.1, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(24) @alloc_3fdd5cc23695ce909cd446a3f31ef6b3) #44
          to label %panic.i.i.i.i.i.i9.cont.i unwind label %cleanup.loopexit.split-lp.i, !noalias !4778

panic.i.i.i.i.i.i9.cont.i:                        ; preds = %panic.i.i.i.i.i.i9.invoke.i
  unreachable

bb5.i.i.i.i.i.i.invoke.i:                         ; preds = %bb1.i.i.i.peel.i.i.i.i
; invoke core::option::expect_failed
  invoke void @_RNvNtCskADBYZwJmSU_4core6option13expect_failed(ptr noalias nofree noundef nonnull readonly captures(address, read_provenance) @alloc_892642cc7f6c32dc42749a5a71ace53a, i64 noundef 12, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(24) @alloc_d5960a87784418e80f2b77d70b9bc1be) #44
          to label %bb5.i.i.i.i.i.i.cont.i unwind label %cleanup.loopexit.split-lp.i, !noalias !4778

bb5.i.i.i.i.i.i.cont.i:                           ; preds = %bb5.i.i.i.i.i.i.invoke.i
  unreachable

bb5.i.i:                                          ; preds = %bb8.i.i.i, %_RINvNtNtNtCskADBYZwJmSU_4core4iter8adapters7flatten17and_then_or_clearINtNtNtB8_5slice4iter11ChunksExacthERShNvYB16_NtNtNtB6_6traits8iterator8Iterator4nextECs8b9n3vPMt31_13blake3_servil.exit.loopexit.i.i.i.i
  %_19.sroa.0.1.i = phi ptr [ %_16.i.i.i.peel.i.i.i.i, %_RINvNtNtNtCskADBYZwJmSU_4core4iter8adapters7flatten17and_then_or_clearINtNtNtB8_5slice4iter11ChunksExacthERShNvYB16_NtNtNtB6_6traits8iterator8Iterator4nextECs8b9n3vPMt31_13blake3_servil.exit.loopexit.i.i.i.i ], [ %_19.sroa.0.0.i, %bb8.i.i.i ]
  %self.1.i.i.i35.lcssa.i.i.i.i = phi i64 [ 16384, %_RINvNtNtNtCskADBYZwJmSU_4core4iter8adapters7flatten17and_then_or_clearINtNtNtB8_5slice4iter11ChunksExacthERShNvYB16_NtNtNtB6_6traits8iterator8Iterator4nextECs8b9n3vPMt31_13blake3_servil.exit.loopexit.i.i.i.i ], [ %_19.sroa.20.0.i, %bb8.i.i.i ]
  %_20.i.i.i.i.i33.lcssa.i.i.i.i = phi ptr [ %_20.i.i.i.i.i.peel.i.i.i.i, %_RINvNtNtNtCskADBYZwJmSU_4core4iter8adapters7flatten17and_then_or_clearINtNtNtB8_5slice4iter11ChunksExacthERShNvYB16_NtNtNtB6_6traits8iterator8Iterator4nextECs8b9n3vPMt31_13blake3_servil.exit.loopexit.i.i.i.i ], [ %_19.sroa.13.0.i, %bb8.i.i.i ]
  %data.i.i.i.i.i.i.i.i = getelementptr inbounds nuw i8, ptr %_20.i.i.i.i.i33.lcssa.i.i.i.i, i64 1024
  %len.i.i.i.i.i.i.i.i = add i64 %self.1.i.i.i35.lcssa.i.i.i.i, -1024
  br label %bb3.i.i3.i

cleanup.loopexit.i:                               ; preds = %bb4.i.i.i
  %lpad.loopexit.i = landingpad { ptr, i32 }
          cleanup
  br label %cleanup.i

cleanup.loopexit.split-lp.i:                      ; preds = %bb5.i.i.i.i.i.i.invoke.i, %panic.i.i.i.i.i.i9.invoke.i
  %lpad.loopexit.split-lp.i = landingpad { ptr, i32 }
          cleanup
  br label %cleanup.i

cleanup.i:                                        ; preds = %cleanup.loopexit.split-lp.i, %cleanup.loopexit.i
  %lpad.phi.i = phi { ptr, i32 } [ %lpad.loopexit.i, %cleanup.loopexit.i ], [ %lpad.loopexit.split-lp.i, %cleanup.loopexit.split-lp.i ]
  %vector.val.i = load i64, ptr %vector.i, align 8, !noalias !4778
  %18 = icmp eq i64 %vector.val.i, 0
  br i1 %18, label %bb38, label %bb2.i.i.i4.i.i

bb2.i.i.i4.i.i:                                   ; preds = %cleanup.i
  %vector.val2.i = load ptr, ptr %vector1.sroa.4.0.vector.sroa_idx.i, align 8, !noalias !4778, !nonnull !566, !noundef !566
  %alloc_size.i.i.i.i5.i.i = shl nuw i64 %vector.val.i, 3
; call __rustc::__rust_dealloc
  tail call void @_RNvCs5fGHjzWXRav_7___rustc14___rust_dealloc(ptr noundef nonnull %vector.val2.i, i64 noundef %alloc_size.i.i.i.i5.i.i, i64 noundef range(i64 1, -9223372036854775807) 8) #36, !noalias !4778
  br label %bb38

bb5.i:                                            ; preds = %bb4.peel.i.i.i.i
  %refs.sroa.0.0.copyload = load i64, ptr %vector.i, align 8, !noalias !4833
  %refs.sroa.6.0.copyload = load ptr, ptr %vector1.sroa.4.0.vector.sroa_idx.i, align 8, !noalias !4833
  call void @llvm.lifetime.end.p0(ptr nonnull %vector.i), !noalias !4778
; call __rustc::__rust_no_alloc_shim_is_unstable_v2
  tail call void @_RNvCs5fGHjzWXRav_7___rustc35___rust_no_alloc_shim_is_unstable_v2() #36, !noalias !4834
; call __rustc::__rust_alloc
  %19 = tail call noundef align 8 ptr @_RNvCs5fGHjzWXRav_7___rustc12___rust_alloc(i64 noundef range(i64 0, -9223372036854775808) %_116.idx, i64 noundef range(i64 1, 129) 8) #36, !noalias !4834
  %20 = icmp eq ptr %19, null
  br i1 %20, label %bb3.i.i72, label %bb8.i.i.i.i.i.i

bb38:                                             ; preds = %bb2.i.i.i4.i76, %bb37, %cleanup6, %bb2.i.i.i4.i.i, %cleanup.i
  %.pn35.pn.pn = phi { ptr, i32 } [ %lpad.phi.i, %cleanup.i ], [ %21, %cleanup6 ], [ %lpad.phi.i, %bb2.i.i.i4.i.i ], [ %.pn35.pn, %bb37 ], [ %.pn35.pn, %bb2.i.i.i4.i76 ]
  br i1 %4, label %bb39, label %bb2.i.i.i4.i

bb2.i.i.i4.i:                                     ; preds = %bb38
  call void @llvm.assume(i1 true) [ "nonnull"(ptr %8) ]
; call __rustc::__rust_dealloc
  call void @_RNvCs5fGHjzWXRav_7___rustc14___rust_dealloc(ptr noundef nonnull %8, i64 noundef %_16, i64 noundef range(i64 1, -9223372036854775807) 1) #36
  br label %bb39

cleanup6:                                         ; preds = %bb5.i.i.i.i.i.i, %bb3.i.i62
  %21 = landingpad { ptr, i32 }
          cleanup
  br label %bb38

bb3.i.i72:                                        ; preds = %bb5.i
; invoke alloc::raw_vec::handle_error
  invoke void @_RNvNtCsgFX3jaOk65H_5alloc7raw_vec12handle_error(i64 noundef 8, i64 %_116.idx) #41
          to label %.noexc74 unwind label %cleanup7

.noexc74:                                         ; preds = %bb3.i.i72
  unreachable

bb8.i.i.i.i.i.i:                                  ; preds = %bb5.i, %bb27.i.i.i.i.i.i
  %f.val5.i.i.i.i.i.i = phi i64 [ %30, %bb27.i.i.i.i.i.i ], [ 0, %bb5.i ]
  %_45.i.i.i.i.i.i = getelementptr inbounds nuw [8 x i8], ptr %alike.0, i64 %f.val5.i.i.i.i.i.i
  %_45.val.i.i.i.i.i.i = load i64, ptr %_45.i.i.i.i.i.i, align 8, !noalias !4840, !noundef !566
  %_7.i.i.i.i.i.i.i.i = icmp ult i64 %_45.val.i.i.i.i.i.i, %hashers.1
  br i1 %_7.i.i.i.i.i.i.i.i, label %bb1.i.i.i.i.i.i.i.i, label %panic.i.i.i.i.i.i.i.i

bb1.i.i.i.i.i.i.i.i:                              ; preds = %bb8.i.i.i.i.i.i
  %_5.i.i.i.i.i.i.i.i = getelementptr inbounds nuw [18432 x i8], ptr %hashers.0, i64 %_45.val.i.i.i.i.i.i
  %22 = getelementptr inbounds nuw i8, ptr %_5.i.i.i.i.i.i.i.i, i64 18368
  %_3.i.i.i.i.i.i.i.i.i = load i64, ptr %22, align 64, !alias.scope !4855, !noalias !4858, !noundef !566
  %23 = icmp eq i64 %_3.i.i.i.i.i.i.i.i.i, 16384
  %24 = getelementptr inbounds nuw i8, ptr %_5.i.i.i.i.i.i.i.i, i64 1936
  %_4.i.i.i.i.i.i.i.i.i = load i64, ptr %24, align 16, !alias.scope !4855, !noalias !4858
  %_2.i.i.i.i.i.i.i.i.i = icmp eq i64 %_4.i.i.i.i.i.i.i.i.i, 0
  %or.cond.i.i.i.i.i.i.i.i.i = select i1 %23, i1 %_2.i.i.i.i.i.i.i.i.i, i1 false
  br i1 %or.cond.i.i.i.i.i.i.i.i.i, label %bb27.i.i.i.i.i.i, label %bb4.i.i.i.i.i.i.i.i

panic.i.i.i.i.i.i.i.i:                            ; preds = %bb8.i.i.i.i.i.i
; invoke core::panicking::panic_bounds_check
  invoke void @_RNvNtCskADBYZwJmSU_4core9panicking18panic_bounds_check(i64 noundef %_45.val.i.i.i.i.i.i, i64 noundef %hashers.1, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(24) @alloc_bfb20d7434eebe46d8ff746f89a2adaa) #44
          to label %.noexc.i.i.i.i.i.i unwind label %cleanup.body.i, !noalias !4840

.noexc.i.i.i.i.i.i:                               ; preds = %panic.i.i.i.i.i.i.i.i
  unreachable

bb4.i.i.i.i.i.i.i.i:                              ; preds = %bb1.i.i.i.i.i.i.i.i
; invoke core::option::unwrap_failed
  invoke void @_RNvNtCskADBYZwJmSU_4core6option13unwrap_failed(ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(24) @alloc_1e21fe077f0deca3a51abddfa989120e) #44
          to label %.noexc8.i.i.i.i.i.i unwind label %cleanup.body.i, !noalias !4840

.noexc8.i.i.i.i.i.i:                              ; preds = %bb4.i.i.i.i.i.i.i.i
  unreachable

bb27.i.i.i.i.i.i:                                 ; preds = %bb1.i.i.i.i.i.i.i.i
  %25 = getelementptr inbounds nuw i8, ptr %_5.i.i.i.i.i.i.i.i, i64 105
  %_15.i.i.i.i.i.i.i.i.i.i = load i8, ptr %25, align 1, !alias.scope !4861, !noalias !4858, !noundef !566
  %_14.i.i.i.i.i.i.i.i.i.i = zext i8 %_15.i.i.i.i.i.i.i.i.i.i to i64
  %_13.i.i.i.i.i.i.i.i.i.i = shl nuw nsw i64 %_14.i.i.i.i.i.i.i.i.i.i, 6
  %26 = getelementptr inbounds nuw i8, ptr %_5.i.i.i.i.i.i.i.i, i64 104
  %_17.i.i.i.i.i.i.i.i.i.i = load i8, ptr %26, align 8, !alias.scope !4861, !noalias !4858, !noundef !566
  %_16.i.i.i.i.i.i.i.i.i.i = zext i8 %_17.i.i.i.i.i.i.i.i.i.i to i64
  %_12.i.i.i.i.i.i.i.i.i.i = add nuw nsw i64 %_13.i.i.i.i.i.i.i.i.i.i, %_16.i.i.i.i.i.i.i.i.i.i
  %27 = lshr i64 %_12.i.i.i.i.i.i.i.i.i.i, 10
  %28 = getelementptr inbounds nuw i8, ptr %_5.i.i.i.i.i.i.i.i, i64 96
  %_9.i.i.i.i.i.i.i.i.i.i = load i64, ptr %28, align 32, !alias.scope !4861, !noalias !4858, !noundef !566
  %29 = add i64 %27, %_9.i.i.i.i.i.i.i.i.i.i
  %_22.i.i.i.i.i.i.i.i.i.i = and i64 %29, 18014398509481983
  %_3.i.i3.i.i.i.i.i.i.i = getelementptr inbounds nuw [8 x i8], ptr %19, i64 %f.val5.i.i.i.i.i.i
  store i64 %_22.i.i.i.i.i.i.i.i.i.i, ptr %_3.i.i3.i.i.i.i.i.i.i, align 8, !noalias !4864
  %30 = add nuw nsw i64 %f.val5.i.i.i.i.i.i, 1
  %_28.i.i.i.i.i.i = icmp eq i64 %30, %alike.1
  br i1 %_28.i.i.i.i.i.i, label %bb44, label %bb8.i.i.i.i.i.i

cleanup.body.i:                                   ; preds = %bb4.i.i.i.i.i.i.i.i, %panic.i.i.i.i.i.i.i.i
  %31 = landingpad { ptr, i32 }
          cleanup
; call __rustc::__rust_dealloc
  tail call void @_RNvCs5fGHjzWXRav_7___rustc14___rust_dealloc(ptr noundef nonnull %19, i64 noundef %_116.idx, i64 noundef range(i64 1, -9223372036854775807) 8) #36, !noalias !4869
  br label %bb37

bb37:                                             ; preds = %bb2.i.i.i4.i78, %cleanup7, %cleanup.body.i
  %.pn35.pn = phi { ptr, i32 } [ %31, %cleanup.body.i ], [ %33, %cleanup7 ], [ %.pn35, %bb2.i.i.i4.i78 ]
  %32 = icmp eq i64 %refs.sroa.0.0.copyload, 0
  br i1 %32, label %bb38, label %bb2.i.i.i4.i76

bb2.i.i.i4.i76:                                   ; preds = %bb37
  %alloc_size.i.i.i.i5.i = shl nuw i64 %refs.sroa.0.0.copyload, 3
  call void @llvm.assume(i1 true) [ "nonnull"(ptr %refs.sroa.6.0.copyload) ]
; call __rustc::__rust_dealloc
  call void @_RNvCs5fGHjzWXRav_7___rustc14___rust_dealloc(ptr noundef nonnull %refs.sroa.6.0.copyload, i64 noundef %alloc_size.i.i.i.i5.i, i64 noundef range(i64 1, -9223372036854775807) 8) #36
  br label %bb38

cleanup7:                                         ; preds = %bb3.i.i72
  %33 = landingpad { ptr, i32 }
          cleanup
  br label %bb37

bb44:                                             ; preds = %bb27.i.i.i.i.i.i
  %_141.idx = shl nuw nsw i64 %alike.1, 3
  %_141 = getelementptr inbounds nuw i8, ptr %19, i64 %_141.idx
  br label %bb6

bb5:                                              ; preds = %bb49
  %_6.i.i = icmp eq ptr %_16.i.i, %_141
  br i1 %_6.i.i, label %bb9, label %bb6

bb2.i.i.i4.i78:                                   ; preds = %cleanup8.loopexit, %cleanup8.loopexit.split-lp, %bb35, %bb2.i.i.i4.i98
  %.pn35 = phi { ptr, i32 } [ %.pn.pn, %bb2.i.i.i4.i98 ], [ %.pn.pn, %bb35 ], [ %lpad.loopexit241, %cleanup8.loopexit ], [ %lpad.loopexit.split-lp242, %cleanup8.loopexit.split-lp ]
; call __rustc::__rust_dealloc
  call void @_RNvCs5fGHjzWXRav_7___rustc14___rust_dealloc(ptr noundef nonnull %19, i64 noundef %_116.idx, i64 noundef range(i64 1, -9223372036854775807) 8) #36
  br label %bb37

cleanup8.loopexit:                                ; preds = %bb49
  %lpad.loopexit241 = landingpad { ptr, i32 }
          cleanup
  br label %bb2.i.i.i4.i78

cleanup8.loopexit.split-lp:                       ; preds = %bb50.invoke, %bb6.i85
  %lpad.loopexit.split-lp242 = landingpad { ptr, i32 }
          cleanup
  br label %bb2.i.i.i4.i78

bb6:                                              ; preds = %bb44, %bb5
  %iter.sroa.7.0384 = phi i64 [ 0, %bb44 ], [ %_9.0.i, %bb5 ]
  %iter.sroa.0.0383 = phi ptr [ %19, %bb44 ], [ %_16.i.i, %bb5 ]
  %_16.i.i = getelementptr inbounds nuw i8, ptr %iter.sroa.0.0383, i64 8
  %_9.0.i = add nuw nsw i64 %iter.sroa.7.0384, 1
  %counter15 = load i64, ptr %iter.sroa.0.0383, align 8, !noundef !566
  %_39 = shl i64 %iter.sroa.7.0384, 4
  %_40 = add i64 %_39, 16
  %34 = or disjoint i64 %_39, 15
  %or.cond235.not.not = icmp ugt i64 %34, %len.i.i.i
  br i1 %or.cond235.not.not, label %bb50.invoke, label %bb45, !prof !1406

bb9:                                              ; preds = %bb5
  %_48 = shl i64 %alike.1, 8
  %_39.not.i.i80 = icmp slt i64 %_48, 0
  br i1 %_39.not.i.i80, label %bb6.i85, label %bb18.i.i81, !prof !2162

bb18.i.i81:                                       ; preds = %bb9
  %35 = icmp eq i64 %_48, 0
  br i1 %35, label %bb53, label %bb3.i.i82

bb3.i.i82:                                        ; preds = %bb18.i.i81
; call __rustc::__rust_no_alloc_shim_is_unstable_v2
  call void @_RNvCs5fGHjzWXRav_7___rustc35___rust_no_alloc_shim_is_unstable_v2() #36, !noalias !4870
; call __rustc::__rust_alloc_zeroed
  %36 = call noundef ptr @_RNvCs5fGHjzWXRav_7___rustc19___rust_alloc_zeroed(i64 noundef range(i64 1, -9223372036854775808) %_48, i64 noundef range(i64 1, 129) 1) #36, !noalias !4870
  %37 = icmp eq ptr %36, null
  br i1 %37, label %bb6.i85, label %bb10.i.i83

bb10.i.i83:                                       ; preds = %bb3.i.i82
  %38 = ptrtoint ptr %36 to i64
  br label %bb53

bb6.i85:                                          ; preds = %bb3.i.i82, %bb9
  %_10.sroa.4.0.ph.i86 = phi i64 [ 1, %bb3.i.i82 ], [ 0, %bb9 ]
; invoke alloc::raw_vec::handle_error
  invoke void @_RNvNtCsgFX3jaOk65H_5alloc7raw_vec12handle_error(i64 noundef %_10.sroa.4.0.ph.i86, i64 %_48) #41
          to label %.noexc87 unwind label %cleanup8.loopexit.split-lp

.noexc87:                                         ; preds = %bb6.i85
  unreachable

bb53:                                             ; preds = %bb10.i.i83, %bb18.i.i81
  %_10.sroa.10.0.i84 = phi i64 [ %38, %bb10.i.i83 ], [ 1, %bb18.i.i81 ]
  %39 = inttoptr i64 %_10.sroa.10.0.i84 to ptr
  %_51 = shl i64 %alike.1, 6
  %_39.not.i.i89 = icmp slt i64 %_51, 0
  br i1 %_39.not.i.i89, label %bb6.i94, label %bb18.i.i90, !prof !2162

bb18.i.i90:                                       ; preds = %bb53
  %40 = icmp eq i64 %_51, 0
  br i1 %40, label %bb13, label %bb3.i.i91

bb3.i.i91:                                        ; preds = %bb18.i.i90
; call __rustc::__rust_no_alloc_shim_is_unstable_v2
  call void @_RNvCs5fGHjzWXRav_7___rustc35___rust_no_alloc_shim_is_unstable_v2() #36, !noalias !4875
; call __rustc::__rust_alloc_zeroed
  %41 = call noundef ptr @_RNvCs5fGHjzWXRav_7___rustc19___rust_alloc_zeroed(i64 noundef range(i64 1, -9223372036854775808) %_51, i64 noundef range(i64 1, 129) 1) #36, !noalias !4875
  %42 = icmp eq ptr %41, null
  br i1 %42, label %bb6.i94, label %bb10.i.i92

bb10.i.i92:                                       ; preds = %bb3.i.i91
  %43 = ptrtoint ptr %41 to i64
  br label %bb13

bb6.i94:                                          ; preds = %bb3.i.i91, %bb53
  %_10.sroa.4.0.ph.i95 = phi i64 [ 1, %bb3.i.i91 ], [ 0, %bb53 ]
; invoke alloc::raw_vec::handle_error
  invoke void @_RNvNtCsgFX3jaOk65H_5alloc7raw_vec12handle_error(i64 noundef %_10.sroa.4.0.ph.i95, i64 %_51) #41
          to label %.noexc96 unwind label %cleanup9

.noexc96:                                         ; preds = %bb6.i94
  unreachable

bb35:                                             ; preds = %bb2.i.i.i4.i100, %bb34, %cleanup9
  %.pn.pn = phi { ptr, i32 } [ %44, %cleanup9 ], [ %.pn, %bb34 ], [ %.pn, %bb2.i.i.i4.i100 ]
  br i1 %35, label %bb2.i.i.i4.i78, label %bb2.i.i.i4.i98

bb2.i.i.i4.i98:                                   ; preds = %bb35
  call void @llvm.assume(i1 true) [ "nonnull"(ptr %39) ]
; call __rustc::__rust_dealloc
  call void @_RNvCs5fGHjzWXRav_7___rustc14___rust_dealloc(ptr noundef nonnull %39, i64 noundef %_48, i64 noundef range(i64 1, -9223372036854775807) 1) #36
  br label %bb2.i.i.i4.i78

cleanup9:                                         ; preds = %bb6.i94
  %44 = landingpad { ptr, i32 }
          cleanup
  br label %bb35

bb19.preheader:                                   ; preds = %bb82.3, %bb2.i.i.i4.i167.3
  %45 = getelementptr inbounds nuw i8, ptr %result, i64 32
  br label %bb19

bb34:                                             ; preds = %cleanup10.loopexit, %cleanup10.loopexit.split-lp, %bb2.i.i.i4.i162, %cleanup13
  %.pn = phi { ptr, i32 } [ %lpad.phi240, %bb2.i.i.i4.i162 ], [ %lpad.phi240, %cleanup13 ], [ %lpad.loopexit, %cleanup10.loopexit ], [ %lpad.loopexit.split-lp, %cleanup10.loopexit.split-lp ]
  br i1 %40, label %bb35, label %bb2.i.i.i4.i100

bb2.i.i.i4.i100:                                  ; preds = %bb34
  call void @llvm.assume(i1 true) [ "nonnull"(ptr %62) ]
; call __rustc::__rust_dealloc
  call void @_RNvCs5fGHjzWXRav_7___rustc14___rust_dealloc(ptr noundef nonnull %62, i64 noundef %_51, i64 noundef range(i64 1, -9223372036854775807) 1) #36
  br label %bb35

cleanup10.loopexit:                               ; preds = %bb1.i134
  %lpad.loopexit = landingpad { ptr, i32 }
          cleanup
  br label %bb34

cleanup10.loopexit.split-lp:                      ; preds = %bb86.invoke, %panic11, %bb83, %bb3.i.i157
  %lpad.loopexit.split-lp = landingpad { ptr, i32 }
          cleanup
  br label %bb34

bb19:                                             ; preds = %bb19.preheader, %bb27
  %iter1.sroa.7.0278 = phi i64 [ %_9.0.i108, %bb27 ], [ 0, %bb19.preheader ]
  %iter1.sroa.0.0277 = phi ptr [ %_16.i.i106, %bb27 ], [ %alike.0, %bb19.preheader ]
  %_16.i.i106 = getelementptr inbounds nuw i8, ptr %iter1.sroa.0.0277, i64 8
  %_9.0.i108 = add nuw nsw i64 %iter1.sroa.7.0278, 1
  %i = load i64, ptr %iter1.sroa.0.0277, align 8, !noundef !566
  %_91 = icmp ult i64 %i, %hashers.1
  br i1 %_91, label %bb21, label %panic11

bb20:                                             ; preds = %bb27
  br i1 %40, label %bb28, label %bb2.i.i.i4.i111

bb2.i.i.i4.i111:                                  ; preds = %bb20
  call void @llvm.assume(i1 true) [ "nonnull"(ptr %62) ]
; call __rustc::__rust_dealloc
  call void @_RNvCs5fGHjzWXRav_7___rustc14___rust_dealloc(ptr noundef nonnull %62, i64 noundef %_51, i64 noundef range(i64 1, -9223372036854775807) 1) #36
  br label %bb28

bb28:                                             ; preds = %bb2.i.i.i4.i111, %bb20
  br i1 %35, label %bb2.i.i.i4.i115, label %bb2.i.i.i4.i113

bb2.i.i.i4.i113:                                  ; preds = %bb28
; call __rustc::__rust_dealloc
  call void @_RNvCs5fGHjzWXRav_7___rustc14___rust_dealloc(ptr noundef nonnull %39, i64 noundef %_48, i64 noundef range(i64 1, -9223372036854775807) 1) #36
  br label %bb2.i.i.i4.i115

bb2.i.i.i4.i115:                                  ; preds = %bb28, %bb2.i.i.i4.i113
; call __rustc::__rust_dealloc
  call void @_RNvCs5fGHjzWXRav_7___rustc14___rust_dealloc(ptr noundef nonnull %19, i64 noundef %_116.idx, i64 noundef range(i64 1, -9223372036854775807) 8) #36
  %46 = icmp eq i64 %refs.sroa.0.0.copyload, 0
  br i1 %46, label %bb31, label %bb2.i.i.i4.i118

bb2.i.i.i4.i118:                                  ; preds = %bb2.i.i.i4.i115
  %alloc_size.i.i.i.i5.i119 = shl nuw i64 %refs.sroa.0.0.copyload, 3
  call void @llvm.assume(i1 true) [ "nonnull"(ptr %refs.sroa.6.0.copyload) ]
; call __rustc::__rust_dealloc
  call void @_RNvCs5fGHjzWXRav_7___rustc14___rust_dealloc(ptr noundef nonnull %refs.sroa.6.0.copyload, i64 noundef %alloc_size.i.i.i.i5.i119, i64 noundef range(i64 1, -9223372036854775807) 8) #36
  br label %bb31

bb31:                                             ; preds = %bb2.i.i.i4.i118, %bb2.i.i.i4.i115
  br i1 %4, label %bb32, label %bb2.i.i.i4.i121

bb2.i.i.i4.i121:                                  ; preds = %bb31
  call void @llvm.assume(i1 true) [ "nonnull"(ptr %8) ]
; call __rustc::__rust_dealloc
  call void @_RNvCs5fGHjzWXRav_7___rustc14___rust_dealloc(ptr noundef nonnull %8, i64 noundef %_16, i64 noundef range(i64 1, -9223372036854775807) 1) #36
  br label %bb32

bb32:                                             ; preds = %bb2.i.i.i4.i121, %bb31
  call void @llvm.lifetime.end.p0(ptr nonnull %key)
  ret void

bb21:                                             ; preds = %bb19
  %_90 = getelementptr inbounds nuw [18432 x i8], ptr %hashers.0, i64 %i
  %47 = getelementptr inbounds nuw i8, ptr %_90, i64 18368
  %_3.i = load i64, ptr %47, align 64, !alias.scope !4880, !noundef !566
  %48 = icmp eq i64 %_3.i, 16384
  %49 = getelementptr inbounds nuw i8, ptr %_90, i64 1936
  %_4.i = load i64, ptr %49, align 16, !alias.scope !4880
  %_2.i = icmp eq i64 %_4.i, 0
  %or.cond.i123 = select i1 %48, i1 %_2.i, i1 false
  br i1 %or.cond.i123, label %bb84, label %bb83

panic11:                                          ; preds = %bb19
; invoke core::panicking::panic_bounds_check
  invoke void @_RNvNtCskADBYZwJmSU_4core9panicking18panic_bounds_check(i64 noundef %i, i64 noundef %hashers.1, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(24) @alloc_cb94eec82dcea402543dd4081e9e6a86) #41
          to label %unreachable unwind label %cleanup10.loopexit.split-lp

unreachable:                                      ; preds = %bb71, %bb75, %bb83, %panic11
  unreachable

bb84:                                             ; preds = %bb21
  %50 = getelementptr inbounds nuw i8, ptr %_90, i64 105
  %_15.i.i = load i8, ptr %50, align 1, !alias.scope !4883, !noundef !566
  %_14.i.i = zext i8 %_15.i.i to i64
  %_13.i.i = shl nuw nsw i64 %_14.i.i, 6
  %51 = getelementptr inbounds nuw i8, ptr %_90, i64 104
  %_17.i.i = load i8, ptr %51, align 8, !alias.scope !4883, !noundef !566
  %_16.i.i126 = zext i8 %_17.i.i to i64
  %_12.i.i = add nuw nsw i64 %_13.i.i, %_16.i.i126
  %52 = lshr i64 %_12.i.i, 10
  %53 = getelementptr inbounds nuw i8, ptr %_90, i64 96
  %_9.i.i = load i64, ptr %53, align 32, !alias.scope !4883, !noundef !566
  %54 = add i64 %52, %_9.i.i
  %_22.i.i = and i64 %54, 18014398509481983
  call void @llvm.lifetime.start.p0(ptr nonnull %result)
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 1 dereferenceable(32) %45, i8 0, i64 32, i1 false)
  %55 = icmp eq i64 %_22.i.i, 0
  br i1 %55, label %bb23, label %bb24

bb83:                                             ; preds = %bb21
; invoke core::option::unwrap_failed
  invoke void @_RNvNtCskADBYZwJmSU_4core6option13unwrap_failed(ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(24) @alloc_d29a5a3cb87f27bdae32a5f06b1bc4e8) #41
          to label %unreachable unwind label %cleanup10.loopexit.split-lp

bb23:                                             ; preds = %bb84
  %_97 = shl i64 %iter1.sroa.7.0278, 6
  %56 = or disjoint i64 %_97, 63
  %or.cond.not = icmp ult i64 %56, %_51
  br i1 %or.cond.not, label %_RINvNtCskADBYZwJmSU_4core5slice20copy_from_slice_implhECs8b9n3vPMt31_13blake3_servil.exit, label %bb86, !prof !838

bb24:                                             ; preds = %bb84
  %_104 = shl i64 %iter1.sroa.7.0278, 5
  %57 = or disjoint i64 %_104, 31
  %or.cond40.not = icmp ult i64 %57, %_16
  br i1 %or.cond40.not, label %_RINvNtCskADBYZwJmSU_4core5slice20copy_from_slice_implhECs8b9n3vPMt31_13blake3_servil.exit133, label %bb91, !prof !838

bb86:                                             ; preds = %bb23
  %_98 = add i64 %_97, 64
  br label %bb86.invoke

bb86.invoke:                                      ; preds = %bb13, %bb12.3, %bb91, %bb86
  %58 = phi i64 [ %_97, %bb86 ], [ %_104, %bb91 ], [ 0, %bb12.3 ], [ 0, %bb13 ]
  %59 = phi i64 [ %_98, %bb86 ], [ %_105, %bb91 ], [ %_51, %bb12.3 ], [ %_62, %bb13 ]
  %60 = phi i64 [ %_51, %bb86 ], [ %_16, %bb91 ], [ %_16, %bb12.3 ], [ %_16, %bb13 ]
  %61 = phi ptr [ @alloc_895242000bcfe3a8e15bde52c37180d8, %bb86 ], [ @alloc_fbaac5fb15f1bba0b6063aa88294f251, %bb91 ], [ @alloc_c7347c64da837652b3ca03f03289602f, %bb12.3 ], [ @alloc_59efabd63ff22f8f3e0d80a1a2f7607a, %bb13 ]
; invoke core::slice::index::slice_index_fail
  invoke void @_RNvNtNtCskADBYZwJmSU_4core5slice5index16slice_index_fail(i64 noundef %58, i64 noundef %59, i64 noundef %60, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(24) %61) #41
          to label %bb86.cont unwind label %cleanup10.loopexit.split-lp

bb86.cont:                                        ; preds = %bb86.invoke
  unreachable

_RINvNtCskADBYZwJmSU_4core5slice20copy_from_slice_implhECs8b9n3vPMt31_13blake3_servil.exit: ; preds = %bb23
  %_259 = getelementptr inbounds nuw i8, ptr %62, i64 %_97
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(64) %result, ptr noundef nonnull readonly align 1 dereferenceable(64) %_259, i64 64, i1 false), !alias.scope !4886, !noalias !4890
  br label %bb1.i134

bb91:                                             ; preds = %bb24
  %_105 = add i64 %_104, 32
  br label %bb86.invoke

_RINvNtCskADBYZwJmSU_4core5slice20copy_from_slice_implhECs8b9n3vPMt31_13blake3_servil.exit133: ; preds = %bb24
  %_275 = getelementptr inbounds nuw i8, ptr %8, i64 %_104
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(32) %result, ptr noundef nonnull readonly align 1 dereferenceable(32) %_275, i64 32, i1 false), !alias.scope !4892, !noalias !4896
  br label %bb1.i134

bb1.i134:                                         ; preds = %_RINvNtCskADBYZwJmSU_4core5slice20copy_from_slice_implhECs8b9n3vPMt31_13blake3_servil.exit, %_RINvNtCskADBYZwJmSU_4core5slice20copy_from_slice_implhECs8b9n3vPMt31_13blake3_servil.exit133
  store i64 0, ptr %47, align 64, !alias.scope !4898, !noalias !4901
; invoke <blake3_servil::incremental::HasherCore>::push_group
  invoke fastcc void @_RNvMs1_NtCs8b9n3vPMt31_13blake3_servil11incrementalNtB5_10HasherCore10push_group(ptr noalias nofree noundef nonnull align 64 dereferenceable(18432) %_90, ptr noalias nofree noundef nonnull readonly captures(address, read_provenance) dereferenceable(64) %result)
          to label %bb27 unwind label %cleanup10.loopexit

bb27:                                             ; preds = %bb1.i134
  call void @llvm.lifetime.end.p0(ptr nonnull %result)
  %_6.i.i104 = icmp eq ptr %_16.i.i106, %_116
  br i1 %_6.i.i104, label %bb20, label %bb19

bb13:                                             ; preds = %bb10.i.i92, %bb18.i.i90
  %_10.sroa.10.0.i93 = phi i64 [ %43, %bb10.i.i92 ], [ 1, %bb18.i.i90 ]
  %62 = inttoptr i64 %_10.sroa.10.0.i93 to ptr
  %_186.not = icmp ugt i64 %_51, %_16
  %_68 = or i8 %flags, 4
  %_62 = shl i64 %alike.1, 9
  %_196.not = icmp ugt i64 %_62, %_16
  br i1 %_196.not, label %bb86.invoke, label %bb3.i145, !prof !1406

bb3.i145:                                         ; preds = %bb13
  %n.i.i.i237 = lshr exact i64 %_62, 6
  %63 = icmp eq i64 %_62, 0
  br i1 %63, label %bb69, label %bb3.i.i.i151

bb3.i.i.i151:                                     ; preds = %bb3.i145
  %_34.0.i.i.i146 = lshr exact i64 %_62, 3
; call __rustc::__rust_no_alloc_shim_is_unstable_v2
  call void @_RNvCs5fGHjzWXRav_7___rustc35___rust_no_alloc_shim_is_unstable_v2() #36, !noalias !4903
; call __rustc::__rust_alloc
  %64 = call noundef align 8 ptr @_RNvCs5fGHjzWXRav_7___rustc12___rust_alloc(i64 noundef range(i64 0, -9223372036854775808) %_34.0.i.i.i146, i64 noundef range(i64 1, 129) 8) #36, !noalias !4903
  %65 = icmp eq ptr %64, null
  br i1 %65, label %bb3.i.i157, label %bb3.us.i.i.i.i.i.i.preheader

bb3.i.i157:                                       ; preds = %bb3.i.i.i151.3, %bb3.i.i.i151.2, %bb3.i.i.i151.1, %bb3.i.i.i151
  %_34.0.i.i.i146.lcssa = phi i64 [ %_34.0.i.i.i146, %bb3.i.i.i151 ], [ %_34.0.i.i.i146.1, %bb3.i.i.i151.1 ], [ %_34.0.i.i.i146.2, %bb3.i.i.i151.2 ], [ %_34.0.i.i.i146.3, %bb3.i.i.i151.3 ]
; invoke alloc::raw_vec::handle_error
  invoke void @_RNvNtCsgFX3jaOk65H_5alloc7raw_vec12handle_error(i64 noundef 8, i64 %_34.0.i.i.i146.lcssa) #41
          to label %.noexc160 unwind label %cleanup10.loopexit.split-lp

.noexc160:                                        ; preds = %bb3.i.i157
  unreachable

bb3.us.i.i.i.i.i.i.preheader:                     ; preds = %bb3.i.i.i151
  %66 = add nsw i64 %_16, -64
  %67 = lshr exact i64 %66, 6
  %68 = add nuw nsw i64 %67, 1
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %bb3.us.i.i.i.i.i.i.preheader
  %index = phi i64 [ 0, %bb3.us.i.i.i.i.i.i.preheader ], [ %index.next, %vector.body ]
  %pointer.phi = phi ptr [ %8, %bb3.us.i.i.i.i.i.i.preheader ], [ %ptr.ind, %vector.body ]
  %vector.gep = getelementptr i8, ptr %pointer.phi, <2 x i64> <i64 0, i64 64>
  %step.add438 = getelementptr i8, <2 x ptr> %vector.gep, i64 128
  %69 = getelementptr inbounds nuw [8 x i8], ptr %64, i64 %index
  %70 = getelementptr inbounds nuw i8, ptr %69, i64 16
  store <2 x ptr> %vector.gep, ptr %69, align 8, !noalias !4909
  store <2 x ptr> %step.add438, ptr %70, align 8, !noalias !4909
  %index.next = add nuw i64 %index, 4
  %ptr.ind = getelementptr i8, ptr %pointer.phi, i64 256
  %71 = icmp eq i64 %index.next, %68
  br i1 %71, label %bb69, label %vector.body, !llvm.loop !4934

bb69:                                             ; preds = %vector.body, %bb3.i145
  %_4.sroa.10.0.i.i331 = phi ptr [ inttoptr (i64 8 to ptr), %bb3.i145 ], [ %64, %vector.body ]
  %_4.sroa.4.0.i.i330 = phi i64 [ 0, %bb3.i145 ], [ %n.i.i.i237, %vector.body ]
  %f.val4.i.i.i.i.i.i = phi i64 [ 0, %bb3.i145 ], [ %68, %vector.body ]
  %_70 = shl i64 %alike.1, 8
  %_211.not = icmp ugt i64 %_70, %_48
  br i1 %_211.not, label %bb71, label %bb70, !prof !1406

bb71:                                             ; preds = %bb69.3, %bb69.2, %bb69.1, %bb69
  %_70.lcssa = phi i64 [ %_70, %bb69 ], [ %_70.1, %bb69.1 ], [ %_70.2, %bb69.2 ], [ %_70.3, %bb69.3 ]
  %_4.sroa.4.0.i.i.lcssa = phi i64 [ %_4.sroa.4.0.i.i330, %bb69 ], [ %_4.sroa.4.0.i.i.1336, %bb69.1 ], [ %_4.sroa.4.0.i.i.2342, %bb69.2 ], [ %n.i.i.i237.3, %bb69.3 ]
  %_4.sroa.10.0.i.i.lcssa = phi ptr [ %_4.sroa.10.0.i.i331, %bb69 ], [ %_4.sroa.10.0.i.i.1337, %bb69.1 ], [ %_4.sroa.10.0.i.i.2343, %bb69.2 ], [ %_4.sroa.10.0.i.i.3, %bb69.3 ]
; invoke core::slice::index::slice_index_fail
  invoke void @_RNvNtNtCskADBYZwJmSU_4core5slice5index16slice_index_fail(i64 noundef 0, i64 noundef %_70.lcssa, i64 noundef %_48, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(24) @alloc_603feb3b0746a0541a010e559f1b16f6) #41
          to label %unreachable unwind label %cleanup13.loopexit.split-lp

bb70:                                             ; preds = %bb69
; invoke <blake3_servil::platform::Platform>::hash_many::<64>
  invoke fastcc void @_RINvMs0_NtCs8b9n3vPMt31_13blake3_servil8platformNtB6_8Platform9hash_manyKj40_EB8_(i8 %_12, ptr noalias nofree noundef nonnull readonly align 8 captures(address, read_provenance) %_4.sroa.10.0.i.i331, i64 noundef %f.val4.i.i.i.i.i.i, ptr noalias nofree noundef readonly align 4 captures(address, read_provenance) dereferenceable(32) %key, i8 noundef %_68, ptr noalias nofree noundef nonnull %39, i64 noundef %_70)
          to label %bb15 unwind label %cleanup13.loopexit

cleanup13.loopexit:                               ; preds = %bb70, %bb70.1, %bb70.2, %bb70.3
  %_4.sroa.4.0.i.i.lcssa294 = phi i64 [ %_4.sroa.4.0.i.i330, %bb70 ], [ %_4.sroa.4.0.i.i.1336, %bb70.1 ], [ %_4.sroa.4.0.i.i.2342, %bb70.2 ], [ %n.i.i.i237.3, %bb70.3 ]
  %_4.sroa.10.0.i.i.lcssa289 = phi ptr [ %_4.sroa.10.0.i.i331, %bb70 ], [ %_4.sroa.10.0.i.i.1337, %bb70.1 ], [ %_4.sroa.10.0.i.i.2343, %bb70.2 ], [ %_4.sroa.10.0.i.i.3, %bb70.3 ]
  %lpad.loopexit238 = landingpad { ptr, i32 }
          cleanup
  br label %cleanup13

cleanup13.loopexit.split-lp:                      ; preds = %bb75, %bb71
  %_4.sroa.4.0.i.i298 = phi i64 [ %_4.sroa.4.0.i.i.lcssa295, %bb75 ], [ %_4.sroa.4.0.i.i.lcssa, %bb71 ]
  %_4.sroa.10.0.i.i293 = phi ptr [ %_4.sroa.10.0.i.i.lcssa290, %bb75 ], [ %_4.sroa.10.0.i.i.lcssa, %bb71 ]
  %lpad.loopexit.split-lp239 = landingpad { ptr, i32 }
          cleanup
  br label %cleanup13

cleanup13:                                        ; preds = %cleanup13.loopexit.split-lp, %cleanup13.loopexit
  %_4.sroa.4.0.i.i297 = phi i64 [ %_4.sroa.4.0.i.i.lcssa294, %cleanup13.loopexit ], [ %_4.sroa.4.0.i.i298, %cleanup13.loopexit.split-lp ]
  %_4.sroa.10.0.i.i292 = phi ptr [ %_4.sroa.10.0.i.i.lcssa289, %cleanup13.loopexit ], [ %_4.sroa.10.0.i.i293, %cleanup13.loopexit.split-lp ]
  %lpad.phi240 = phi { ptr, i32 } [ %lpad.loopexit238, %cleanup13.loopexit ], [ %lpad.loopexit.split-lp239, %cleanup13.loopexit.split-lp ]
  %72 = icmp eq i64 %_4.sroa.4.0.i.i297, 0
  br i1 %72, label %bb34, label %bb2.i.i.i4.i162

bb2.i.i.i4.i162:                                  ; preds = %cleanup13
  %alloc_size.i.i.i.i5.i163 = shl nuw nsw i64 %_4.sroa.4.0.i.i297, 3
; call __rustc::__rust_dealloc
  call void @_RNvCs5fGHjzWXRav_7___rustc14___rust_dealloc(ptr noundef nonnull %_4.sroa.10.0.i.i292, i64 noundef %alloc_size.i.i.i.i5.i163, i64 noundef range(i64 1, -9223372036854775807) 8) #36
  br label %bb34

bb15:                                             ; preds = %bb70
  %_222.not = icmp ugt i64 %_70, %_16
  br i1 %_222.not, label %bb75, label %bb82, !prof !1406

bb75:                                             ; preds = %bb15.3, %bb15.2, %bb15.1, %bb15
  %_70.lcssa300 = phi i64 [ %_70, %bb15 ], [ %_70.1, %bb15.1 ], [ %_70.2, %bb15.2 ], [ %_70.3, %bb15.3 ]
  %_4.sroa.4.0.i.i.lcssa295 = phi i64 [ %_4.sroa.4.0.i.i330, %bb15 ], [ %_4.sroa.4.0.i.i.1336, %bb15.1 ], [ %_4.sroa.4.0.i.i.2342, %bb15.2 ], [ %n.i.i.i237.3, %bb15.3 ]
  %_4.sroa.10.0.i.i.lcssa290 = phi ptr [ %_4.sroa.10.0.i.i331, %bb15 ], [ %_4.sroa.10.0.i.i.1337, %bb15.1 ], [ %_4.sroa.10.0.i.i.2343, %bb15.2 ], [ %_4.sroa.10.0.i.i.3, %bb15.3 ]
; invoke core::slice::index::slice_index_fail
  invoke void @_RNvNtNtCskADBYZwJmSU_4core5slice5index16slice_index_fail(i64 noundef 0, i64 noundef %_70.lcssa300, i64 noundef %_16, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(24) @alloc_12fe65e09f81e95d09580a0e34ab8071) #41
          to label %unreachable unwind label %cleanup13.loopexit.split-lp

bb82:                                             ; preds = %bb15
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %8, ptr nonnull readonly align 1 %39, i64 range(i64 0, -9223372036854775808) %_70, i1 false), !alias.scope !4935, !noalias !4939
  %73 = icmp eq i64 %_4.sroa.4.0.i.i330, 0
  br i1 %73, label %bb3.i145.1, label %bb2.i.i.i4.i167

bb2.i.i.i4.i167:                                  ; preds = %bb82
  %alloc_size.i.i.i.i5.i168 = shl nuw nsw i64 %_4.sroa.4.0.i.i330, 3
; call __rustc::__rust_dealloc
  call void @_RNvCs5fGHjzWXRav_7___rustc14___rust_dealloc(ptr noundef nonnull %_4.sroa.10.0.i.i331, i64 noundef %alloc_size.i.i.i.i5.i168, i64 noundef range(i64 1, -9223372036854775807) 8) #36
  br label %bb3.i145.1

bb3.i145.1:                                       ; preds = %bb2.i.i.i4.i167, %bb82
  %n.i.i.i237.1 = lshr exact i64 %_70, 6
  %74 = icmp eq i64 %_70, 0
  br i1 %74, label %bb69.1, label %bb3.i.i.i151.1

bb3.i.i.i151.1:                                   ; preds = %bb3.i145.1
  %_34.0.i.i.i146.1 = lshr exact i64 %_70, 3
; call __rustc::__rust_no_alloc_shim_is_unstable_v2
  call void @_RNvCs5fGHjzWXRav_7___rustc35___rust_no_alloc_shim_is_unstable_v2() #36, !noalias !4903
; call __rustc::__rust_alloc
  %75 = call noundef align 8 ptr @_RNvCs5fGHjzWXRav_7___rustc12___rust_alloc(i64 noundef range(i64 0, -9223372036854775808) %_34.0.i.i.i146.1, i64 noundef range(i64 1, 129) 8) #36, !noalias !4903
  %76 = icmp eq ptr %75, null
  br i1 %76, label %bb3.i.i157, label %bb3.us.i.i.i.i.i.i.preheader.1

bb3.us.i.i.i.i.i.i.preheader.1:                   ; preds = %bb3.i.i.i151.1
  %77 = add i64 %_70, -64
  %78 = lshr exact i64 %77, 6
  %79 = add nuw nsw i64 %78, 1
  br label %vector.body392

vector.body392:                                   ; preds = %vector.body392, %bb3.us.i.i.i.i.i.i.preheader.1
  %index393 = phi i64 [ 0, %bb3.us.i.i.i.i.i.i.preheader.1 ], [ %index.next397, %vector.body392 ]
  %pointer.phi394 = phi ptr [ %8, %bb3.us.i.i.i.i.i.i.preheader.1 ], [ %ptr.ind398, %vector.body392 ]
  %vector.gep395 = getelementptr i8, ptr %pointer.phi394, <2 x i64> <i64 0, i64 64>
  %step.add396439 = getelementptr i8, <2 x ptr> %vector.gep395, i64 128
  %80 = getelementptr inbounds nuw [8 x i8], ptr %75, i64 %index393
  %81 = getelementptr inbounds nuw i8, ptr %80, i64 16
  store <2 x ptr> %vector.gep395, ptr %80, align 8, !noalias !4909
  store <2 x ptr> %step.add396439, ptr %81, align 8, !noalias !4909
  %index.next397 = add nuw i64 %index393, 4
  %ptr.ind398 = getelementptr i8, ptr %pointer.phi394, i64 256
  %82 = icmp eq i64 %index.next397, %79
  br i1 %82, label %bb69.1, label %vector.body392, !llvm.loop !4941

bb69.1:                                           ; preds = %vector.body392, %bb3.i145.1
  %_4.sroa.10.0.i.i.1337 = phi ptr [ inttoptr (i64 8 to ptr), %bb3.i145.1 ], [ %75, %vector.body392 ]
  %_4.sroa.4.0.i.i.1336 = phi i64 [ 0, %bb3.i145.1 ], [ %n.i.i.i237.1, %vector.body392 ]
  %f.val4.i.i.i.i.i.i.1 = phi i64 [ 0, %bb3.i145.1 ], [ %79, %vector.body392 ]
  %_70.1 = shl i64 %alike.1, 7
  %_211.not.1 = icmp ugt i64 %_70.1, %_48
  br i1 %_211.not.1, label %bb71, label %bb70.1, !prof !1406

bb70.1:                                           ; preds = %bb69.1
; invoke <blake3_servil::platform::Platform>::hash_many::<64>
  invoke fastcc void @_RINvMs0_NtCs8b9n3vPMt31_13blake3_servil8platformNtB6_8Platform9hash_manyKj40_EB8_(i8 %_12, ptr noalias nofree noundef nonnull readonly align 8 captures(address, read_provenance) %_4.sroa.10.0.i.i.1337, i64 noundef %f.val4.i.i.i.i.i.i.1, ptr noalias nofree noundef readonly align 4 captures(address, read_provenance) dereferenceable(32) %key, i8 noundef %_68, ptr noalias nofree noundef nonnull %39, i64 noundef %_70.1)
          to label %bb15.1 unwind label %cleanup13.loopexit

bb15.1:                                           ; preds = %bb70.1
  %_222.not.1 = icmp ugt i64 %_70.1, %_16
  br i1 %_222.not.1, label %bb75, label %bb82.1, !prof !1406

bb82.1:                                           ; preds = %bb15.1
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %8, ptr nonnull readonly align 1 %39, i64 range(i64 0, -9223372036854775808) %_70.1, i1 false), !alias.scope !4935, !noalias !4939
  %83 = icmp eq i64 %_4.sroa.4.0.i.i.1336, 0
  br i1 %83, label %bb3.i145.2, label %bb2.i.i.i4.i167.1

bb2.i.i.i4.i167.1:                                ; preds = %bb82.1
  %alloc_size.i.i.i.i5.i168.1 = shl nuw nsw i64 %_4.sroa.4.0.i.i.1336, 3
; call __rustc::__rust_dealloc
  call void @_RNvCs5fGHjzWXRav_7___rustc14___rust_dealloc(ptr noundef nonnull %_4.sroa.10.0.i.i.1337, i64 noundef %alloc_size.i.i.i.i5.i168.1, i64 noundef range(i64 1, -9223372036854775807) 8) #36
  br label %bb3.i145.2

bb3.i145.2:                                       ; preds = %bb2.i.i.i4.i167.1, %bb82.1
  %n.i.i.i237.2 = lshr exact i64 %_70.1, 6
  %84 = icmp eq i64 %_70.1, 0
  br i1 %84, label %bb69.2, label %bb3.i.i.i151.2

bb3.i.i.i151.2:                                   ; preds = %bb3.i145.2
  %_34.0.i.i.i146.2 = lshr exact i64 %_70.1, 3
; call __rustc::__rust_no_alloc_shim_is_unstable_v2
  call void @_RNvCs5fGHjzWXRav_7___rustc35___rust_no_alloc_shim_is_unstable_v2() #36, !noalias !4903
; call __rustc::__rust_alloc
  %85 = call noundef align 8 ptr @_RNvCs5fGHjzWXRav_7___rustc12___rust_alloc(i64 noundef range(i64 0, -9223372036854775808) %_34.0.i.i.i146.2, i64 noundef range(i64 1, 129) 8) #36, !noalias !4903
  %86 = icmp eq ptr %85, null
  br i1 %86, label %bb3.i.i157, label %bb3.us.i.i.i.i.i.i.preheader.2

bb3.us.i.i.i.i.i.i.preheader.2:                   ; preds = %bb3.i.i.i151.2
  %87 = add i64 %_70.1, -64
  %88 = lshr exact i64 %87, 6
  %89 = add nuw nsw i64 %88, 1
  %min.iters.check405 = icmp ult i64 %87, 192
  br i1 %min.iters.check405, label %bb3.us.i.i.i.i.i.i.2.preheader, label %vector.ph406

vector.ph406:                                     ; preds = %bb3.us.i.i.i.i.i.i.preheader.2
  %n.vec408 = and i64 %89, 576460752303423484
  %90 = shl i64 %n.vec408, 6
  %91 = sub i64 %_70.1, %90
  %92 = shl i64 %n.vec408, 6
  %93 = getelementptr i8, ptr %8, i64 %92
  br label %vector.body409

vector.body409:                                   ; preds = %vector.body409, %vector.ph406
  %index410 = phi i64 [ 0, %vector.ph406 ], [ %index.next414, %vector.body409 ]
  %pointer.phi411 = phi ptr [ %8, %vector.ph406 ], [ %ptr.ind415, %vector.body409 ]
  %vector.gep412 = getelementptr i8, ptr %pointer.phi411, <2 x i64> <i64 0, i64 64>
  %step.add413440 = getelementptr i8, <2 x ptr> %vector.gep412, i64 128
  %94 = getelementptr inbounds nuw [8 x i8], ptr %85, i64 %index410
  %95 = getelementptr inbounds nuw i8, ptr %94, i64 16
  store <2 x ptr> %vector.gep412, ptr %94, align 8, !noalias !4909
  store <2 x ptr> %step.add413440, ptr %95, align 8, !noalias !4909
  %index.next414 = add nuw i64 %index410, 4
  %ptr.ind415 = getelementptr i8, ptr %pointer.phi411, i64 256
  %96 = icmp eq i64 %index.next414, %n.vec408
  br i1 %96, label %middle.block416, label %vector.body409, !llvm.loop !4942

middle.block416:                                  ; preds = %vector.body409
  %cmp.n417 = icmp eq i64 %89, %n.vec408
  br i1 %cmp.n417, label %bb69.2, label %bb3.us.i.i.i.i.i.i.2.preheader

bb3.us.i.i.i.i.i.i.2.preheader:                   ; preds = %bb3.us.i.i.i.i.i.i.preheader.2, %middle.block416
  %.ph448 = phi i64 [ 0, %bb3.us.i.i.i.i.i.i.preheader.2 ], [ %n.vec408, %middle.block416 ]
  %len.i.i711.us.i.i.i.i.i.i.2.ph = phi i64 [ %_70.1, %bb3.us.i.i.i.i.i.i.preheader.2 ], [ %91, %middle.block416 ]
  %data.i.i810.us.i.i.i.i.i.i.2.ph = phi ptr [ %8, %bb3.us.i.i.i.i.i.i.preheader.2 ], [ %93, %middle.block416 ]
  br label %bb3.us.i.i.i.i.i.i.2

bb3.us.i.i.i.i.i.i.2:                             ; preds = %bb3.us.i.i.i.i.i.i.2.preheader, %bb3.us.i.i.i.i.i.i.2
  %97 = phi i64 [ %98, %bb3.us.i.i.i.i.i.i.2 ], [ %.ph448, %bb3.us.i.i.i.i.i.i.2.preheader ]
  %len.i.i711.us.i.i.i.i.i.i.2 = phi i64 [ %len.i.i.us.i.i.i.i.i.i.2, %bb3.us.i.i.i.i.i.i.2 ], [ %len.i.i711.us.i.i.i.i.i.i.2.ph, %bb3.us.i.i.i.i.i.i.2.preheader ]
  %data.i.i810.us.i.i.i.i.i.i.2 = phi ptr [ %data.i.i.us.i.i.i.i.i.i.2, %bb3.us.i.i.i.i.i.i.2 ], [ %data.i.i810.us.i.i.i.i.i.i.2.ph, %bb3.us.i.i.i.i.i.i.2.preheader ]
  %data.i.i.us.i.i.i.i.i.i.2 = getelementptr inbounds nuw i8, ptr %data.i.i810.us.i.i.i.i.i.i.2, i64 64
  %len.i.i.us.i.i.i.i.i.i.2 = add i64 %len.i.i711.us.i.i.i.i.i.i.2, -64
  %_3.i.i.i.us.i.i.i.i.i.i.2 = getelementptr inbounds nuw [8 x i8], ptr %85, i64 %97
  store ptr %data.i.i810.us.i.i.i.i.i.i.2, ptr %_3.i.i.i.us.i.i.i.i.i.i.2, align 8, !noalias !4909, !captures !848
  %98 = add nuw nsw i64 %97, 1
  %_6.not.i.us.i.i.i.i.i.i.2 = icmp eq i64 %len.i.i.us.i.i.i.i.i.i.2, 0
  br i1 %_6.not.i.us.i.i.i.i.i.i.2, label %bb69.2, label %bb3.us.i.i.i.i.i.i.2, !llvm.loop !4943

bb69.2:                                           ; preds = %bb3.us.i.i.i.i.i.i.2, %middle.block416, %bb3.i145.2
  %_4.sroa.10.0.i.i.2343 = phi ptr [ inttoptr (i64 8 to ptr), %bb3.i145.2 ], [ %85, %middle.block416 ], [ %85, %bb3.us.i.i.i.i.i.i.2 ]
  %_4.sroa.4.0.i.i.2342 = phi i64 [ 0, %bb3.i145.2 ], [ %n.i.i.i237.2, %middle.block416 ], [ %n.i.i.i237.2, %bb3.us.i.i.i.i.i.i.2 ]
  %f.val4.i.i.i.i.i.i.2 = phi i64 [ 0, %bb3.i145.2 ], [ %n.vec408, %middle.block416 ], [ %98, %bb3.us.i.i.i.i.i.i.2 ]
  %_70.2 = shl i64 %alike.1, 6
  %_211.not.2 = icmp ugt i64 %_70.2, %_48
  br i1 %_211.not.2, label %bb71, label %bb70.2, !prof !1406

bb70.2:                                           ; preds = %bb69.2
; invoke <blake3_servil::platform::Platform>::hash_many::<64>
  invoke fastcc void @_RINvMs0_NtCs8b9n3vPMt31_13blake3_servil8platformNtB6_8Platform9hash_manyKj40_EB8_(i8 %_12, ptr noalias nofree noundef nonnull readonly align 8 captures(address, read_provenance) %_4.sroa.10.0.i.i.2343, i64 noundef %f.val4.i.i.i.i.i.i.2, ptr noalias nofree noundef readonly align 4 captures(address, read_provenance) dereferenceable(32) %key, i8 noundef %_68, ptr noalias nofree noundef nonnull %39, i64 noundef %_70.2)
          to label %bb15.2 unwind label %cleanup13.loopexit

bb15.2:                                           ; preds = %bb70.2
  %_222.not.2 = icmp ugt i64 %_70.2, %_16
  br i1 %_222.not.2, label %bb75, label %bb82.2, !prof !1406

bb82.2:                                           ; preds = %bb15.2
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %8, ptr nonnull readonly align 1 %39, i64 range(i64 0, -9223372036854775808) %_70.2, i1 false), !alias.scope !4935, !noalias !4939
  %99 = icmp eq i64 %_4.sroa.4.0.i.i.2342, 0
  br i1 %99, label %bb12.3, label %bb2.i.i.i4.i167.2

bb2.i.i.i4.i167.2:                                ; preds = %bb82.2
  %alloc_size.i.i.i.i5.i168.2 = shl nuw nsw i64 %_4.sroa.4.0.i.i.2342, 3
; call __rustc::__rust_dealloc
  call void @_RNvCs5fGHjzWXRav_7___rustc14___rust_dealloc(ptr noundef nonnull %_4.sroa.10.0.i.i.2343, i64 noundef %alloc_size.i.i.i.i5.i168.2, i64 noundef range(i64 1, -9223372036854775807) 8) #36
  br label %bb12.3

bb12.3:                                           ; preds = %bb82.2, %bb2.i.i.i4.i167.2
  br i1 %_186.not, label %bb86.invoke, label %bb3.i145.3, !prof !1406

bb3.i145.3:                                       ; preds = %bb12.3
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %62, ptr nonnull readonly align 1 %8, i64 range(i64 0, -9223372036854775808) %_51, i1 false), !alias.scope !4944, !noalias !4948
  %n.i.i.i237.3 = and i64 %alike.1, 288230376151711743
  %100 = icmp eq i64 %n.i.i.i237.3, 0
  br i1 %100, label %_RNvMs_NtCsgFX3jaOk65H_5alloc3vecINtB4_3VecRAhj40_E7reserveCs8b9n3vPMt31_13blake3_servil.exit.i.i.i.3, label %bb3.i.i.i151.3

bb3.i.i.i151.3:                                   ; preds = %bb3.i145.3
  %_34.0.i.i.i146.3 = shl nuw nsw i64 %n.i.i.i237.3, 3
; call __rustc::__rust_no_alloc_shim_is_unstable_v2
  call void @_RNvCs5fGHjzWXRav_7___rustc35___rust_no_alloc_shim_is_unstable_v2() #36, !noalias !4903
; call __rustc::__rust_alloc
  %101 = call noundef align 8 ptr @_RNvCs5fGHjzWXRav_7___rustc12___rust_alloc(i64 noundef range(i64 0, -9223372036854775808) %_34.0.i.i.i146.3, i64 noundef range(i64 1, 129) 8) #36, !noalias !4903
  %102 = icmp eq ptr %101, null
  br i1 %102, label %bb3.i.i157, label %_RNvMs_NtCsgFX3jaOk65H_5alloc3vecINtB4_3VecRAhj40_E7reserveCs8b9n3vPMt31_13blake3_servil.exit.i.i.i.3

_RNvMs_NtCsgFX3jaOk65H_5alloc3vecINtB4_3VecRAhj40_E7reserveCs8b9n3vPMt31_13blake3_servil.exit.i.i.i.3: ; preds = %bb3.i.i.i151.3, %bb3.i145.3
  %_4.sroa.10.0.i.i.3 = phi ptr [ inttoptr (i64 8 to ptr), %bb3.i145.3 ], [ %101, %bb3.i.i.i151.3 ]
  %_6.not.i9.i.i.i.i.i.i.3 = icmp eq i64 %_70.2, 0
  br i1 %_6.not.i9.i.i.i.i.i.i.3, label %bb69.3, label %bb3.us.i.i.i.i.i.i.3.preheader

bb3.us.i.i.i.i.i.i.3.preheader:                   ; preds = %_RNvMs_NtCsgFX3jaOk65H_5alloc3vecINtB4_3VecRAhj40_E7reserveCs8b9n3vPMt31_13blake3_servil.exit.i.i.i.3
  %103 = add nsw i64 %_51, -64
  %104 = lshr exact i64 %103, 6
  %105 = add nuw nsw i64 %104, 1
  %min.iters.check422 = icmp ult i64 %103, 192
  br i1 %min.iters.check422, label %bb3.us.i.i.i.i.i.i.3.preheader447, label %vector.ph423

vector.ph423:                                     ; preds = %bb3.us.i.i.i.i.i.i.3.preheader
  %n.vec425 = and i64 %105, 576460752303423484
  %106 = sub nsw i64 %alike.1, %n.vec425
  %107 = shl i64 %106, 6
  %108 = shl i64 %n.vec425, 6
  %109 = getelementptr i8, ptr %8, i64 %108
  br label %vector.body426

vector.body426:                                   ; preds = %vector.body426, %vector.ph423
  %index427 = phi i64 [ 0, %vector.ph423 ], [ %index.next431, %vector.body426 ]
  %pointer.phi428 = phi ptr [ %8, %vector.ph423 ], [ %ptr.ind432, %vector.body426 ]
  %vector.gep429 = getelementptr i8, ptr %pointer.phi428, <2 x i64> <i64 0, i64 64>
  %step.add430441 = getelementptr i8, <2 x ptr> %vector.gep429, i64 128
  %110 = getelementptr inbounds nuw [8 x i8], ptr %_4.sroa.10.0.i.i.3, i64 %index427
  %111 = getelementptr inbounds nuw i8, ptr %110, i64 16
  store <2 x ptr> %vector.gep429, ptr %110, align 8, !noalias !4909
  store <2 x ptr> %step.add430441, ptr %111, align 8, !noalias !4909
  %index.next431 = add nuw i64 %index427, 4
  %ptr.ind432 = getelementptr i8, ptr %pointer.phi428, i64 256
  %112 = icmp eq i64 %index.next431, %n.vec425
  br i1 %112, label %middle.block433, label %vector.body426, !llvm.loop !4950

middle.block433:                                  ; preds = %vector.body426
  %cmp.n434 = icmp eq i64 %105, %n.vec425
  br i1 %cmp.n434, label %bb69.3, label %bb3.us.i.i.i.i.i.i.3.preheader447

bb3.us.i.i.i.i.i.i.3.preheader447:                ; preds = %bb3.us.i.i.i.i.i.i.3.preheader, %middle.block433
  %.ph = phi i64 [ 0, %bb3.us.i.i.i.i.i.i.3.preheader ], [ %n.vec425, %middle.block433 ]
  %len.i.i711.us.i.i.i.i.i.i.3.ph = phi i64 [ %_70.2, %bb3.us.i.i.i.i.i.i.3.preheader ], [ %107, %middle.block433 ]
  %data.i.i810.us.i.i.i.i.i.i.3.ph = phi ptr [ %8, %bb3.us.i.i.i.i.i.i.3.preheader ], [ %109, %middle.block433 ]
  br label %bb3.us.i.i.i.i.i.i.3

bb3.us.i.i.i.i.i.i.3:                             ; preds = %bb3.us.i.i.i.i.i.i.3.preheader447, %bb3.us.i.i.i.i.i.i.3
  %113 = phi i64 [ %114, %bb3.us.i.i.i.i.i.i.3 ], [ %.ph, %bb3.us.i.i.i.i.i.i.3.preheader447 ]
  %len.i.i711.us.i.i.i.i.i.i.3 = phi i64 [ %len.i.i.us.i.i.i.i.i.i.3, %bb3.us.i.i.i.i.i.i.3 ], [ %len.i.i711.us.i.i.i.i.i.i.3.ph, %bb3.us.i.i.i.i.i.i.3.preheader447 ]
  %data.i.i810.us.i.i.i.i.i.i.3 = phi ptr [ %data.i.i.us.i.i.i.i.i.i.3, %bb3.us.i.i.i.i.i.i.3 ], [ %data.i.i810.us.i.i.i.i.i.i.3.ph, %bb3.us.i.i.i.i.i.i.3.preheader447 ]
  %data.i.i.us.i.i.i.i.i.i.3 = getelementptr inbounds nuw i8, ptr %data.i.i810.us.i.i.i.i.i.i.3, i64 64
  %len.i.i.us.i.i.i.i.i.i.3 = add i64 %len.i.i711.us.i.i.i.i.i.i.3, -64
  %_3.i.i.i.us.i.i.i.i.i.i.3 = getelementptr inbounds nuw [8 x i8], ptr %_4.sroa.10.0.i.i.3, i64 %113
  store ptr %data.i.i810.us.i.i.i.i.i.i.3, ptr %_3.i.i.i.us.i.i.i.i.i.i.3, align 8, !noalias !4909, !captures !848
  %114 = add nuw nsw i64 %113, 1
  %_6.not.i.us.i.i.i.i.i.i.3 = icmp eq i64 %len.i.i.us.i.i.i.i.i.i.3, 0
  br i1 %_6.not.i.us.i.i.i.i.i.i.3, label %bb69.3, label %bb3.us.i.i.i.i.i.i.3, !llvm.loop !4951

bb69.3:                                           ; preds = %bb3.us.i.i.i.i.i.i.3, %middle.block433, %_RNvMs_NtCsgFX3jaOk65H_5alloc3vecINtB4_3VecRAhj40_E7reserveCs8b9n3vPMt31_13blake3_servil.exit.i.i.i.3
  %f.val4.i.i.i.i.i.i.3 = phi i64 [ 0, %_RNvMs_NtCsgFX3jaOk65H_5alloc3vecINtB4_3VecRAhj40_E7reserveCs8b9n3vPMt31_13blake3_servil.exit.i.i.i.3 ], [ %n.vec425, %middle.block433 ], [ %114, %bb3.us.i.i.i.i.i.i.3 ]
  %_70.3 = shl i64 %alike.1, 5
  %_211.not.3 = icmp ugt i64 %_70.3, %_48
  br i1 %_211.not.3, label %bb71, label %bb70.3, !prof !1406

bb70.3:                                           ; preds = %bb69.3
; invoke <blake3_servil::platform::Platform>::hash_many::<64>
  invoke fastcc void @_RINvMs0_NtCs8b9n3vPMt31_13blake3_servil8platformNtB6_8Platform9hash_manyKj40_EB8_(i8 %_12, ptr noalias nofree noundef nonnull readonly align 8 captures(address, read_provenance) %_4.sroa.10.0.i.i.3, i64 noundef %f.val4.i.i.i.i.i.i.3, ptr noalias nofree noundef readonly align 4 captures(address, read_provenance) dereferenceable(32) %key, i8 noundef %_68, ptr noalias nofree noundef nonnull %39, i64 noundef %_70.3)
          to label %bb15.3 unwind label %cleanup13.loopexit

bb15.3:                                           ; preds = %bb70.3
  %_222.not.3 = icmp ugt i64 %_70.3, %_16
  br i1 %_222.not.3, label %bb75, label %bb82.3, !prof !1406

bb82.3:                                           ; preds = %bb15.3
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %8, ptr nonnull readonly align 1 %39, i64 range(i64 0, -9223372036854775808) %_70.3, i1 false), !alias.scope !4935, !noalias !4939
  %115 = icmp eq i64 %n.i.i.i237.3, 0
  br i1 %115, label %bb19.preheader, label %bb2.i.i.i4.i167.3

bb2.i.i.i4.i167.3:                                ; preds = %bb82.3
  %alloc_size.i.i.i.i5.i168.3 = shl nuw nsw i64 %n.i.i.i237.3, 3
; call __rustc::__rust_dealloc
  call void @_RNvCs5fGHjzWXRav_7___rustc14___rust_dealloc(ptr noundef nonnull %_4.sroa.10.0.i.i.3, i64 noundef %alloc_size.i.i.i.i5.i168.3, i64 noundef range(i64 1, -9223372036854775807) 8) #36
  br label %bb19.preheader

bb45:                                             ; preds = %bb6
  %_44 = shl i64 %iter.sroa.7.0384, 9
  %_45 = shl i64 %_40, 5
  %_167 = icmp ult i64 %_45, %_44
  %_163.not = icmp ugt i64 %_45, %_16
  %or.cond41 = or i1 %_167, %_163.not
  br i1 %or.cond41, label %bb50.invoke, label %bb49, !prof !1406

bb50.invoke:                                      ; preds = %bb45, %bb6
  %116 = phi i64 [ %_39, %bb6 ], [ %_44, %bb45 ]
  %117 = phi i64 [ %_40, %bb6 ], [ %_45, %bb45 ]
  %118 = phi i64 [ %new_len.i.i.i, %bb6 ], [ %_16, %bb45 ]
  %119 = phi ptr [ @alloc_978192397292649c630fb2fa175af959, %bb6 ], [ @alloc_a4860947a77946894616af7f11fb606f, %bb45 ]
; invoke core::slice::index::slice_index_fail
  invoke void @_RNvNtNtCskADBYZwJmSU_4core5slice5index16slice_index_fail(i64 noundef %116, i64 noundef %117, i64 noundef %118, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(24) %119) #41
          to label %bb50.cont unwind label %cleanup8.loopexit.split-lp

bb50.cont:                                        ; preds = %bb50.invoke
  unreachable

bb49:                                             ; preds = %bb45
  %_157 = getelementptr inbounds nuw [8 x i8], ptr %refs.sroa.6.0.copyload, i64 %_39
  %_170 = getelementptr inbounds nuw i8, ptr %8, i64 %_44
; invoke <blake3_servil::platform::Platform>::hash_many::<1024>
  invoke fastcc void @_RINvMs0_NtCs8b9n3vPMt31_13blake3_servil8platformNtB6_8Platform9hash_manyKj400_EB8_(i8 %_12, ptr noalias nofree noundef nonnull readonly align 8 captures(address, read_provenance) %_157, i64 noundef 16, ptr noalias nofree noundef readonly align 4 captures(address, read_provenance) dereferenceable(32) %key, i64 noundef %counter15, i1 noundef zeroext false, i8 noundef %flags, i8 noundef 2, ptr noalias nofree noundef nonnull %_170, i64 noundef 512)
          to label %bb5 unwind label %cleanup8.loopexit

bb39:                                             ; preds = %bb38, %bb2.i.i.i4.i
  resume { ptr, i32 } %.pn35.pn.pn
}

define internal fastcc void @_RNvNtCs8b9n3vPMt31_13blake3_servil4each11update_turn(ptr noalias nofree noundef nonnull align 64 %hashers.0, i64 noundef range(i64 0, 500399958596722) %hashers.1, ptr noalias nofree noundef nonnull readonly align 8 captures(none) %0, i64 noundef range(i64 0, 384307168202282326) %1, i1 noundef zeroext %pooled) unnamed_addr #2 personality ptr @rust_eh_personality !guid !4953 {
start:
  %args.i.i = alloca [48 x i8], align 8
  %_16.i.i69 = alloca [8 x i8], align 8
  %max.i.i = alloca [8 x i8], align 8
  %input_offset.i.i = alloca [8 x i8], align 8
  %vector.i.i = alloca [24 x i8], align 8
  %p.i.i.i = alloca [384 x i8], align 64
  %array.i.i.i = alloca [384 x i8], align 8
  %result.i.i = alloca [64 x i8], align 1
  %cv.i.i = alloca [32 x i8], align 4
  %inputs2.i.i = alloca [192 x i8], align 8
  %inputs.i.i = alloca [384 x i8], align 8
  %refs.i.i = alloca [128 x i8], align 8
  %_32.i = alloca [8 x i8], align 8
  %args = alloca [64 x i8], align 8
  %_74 = alloca [8 x i8], align 8
  %_72 = alloca [8 x i8], align 8
  %after = alloca [8 x i8], align 8
  %before = alloca [8 x i8], align 8
  %held = alloca [24 x i8], align 8
  %waiting = alloca [24 x i8], align 8
  %_4 = icmp samesign ugt i64 %hashers.1, 7
  br i1 %_4, label %bb1, label %bb25

bb1:                                              ; preds = %start
  %2 = load atomic i8, ptr @_RNvNtCs8b9n3vPMt31_13blake3_servil8platform8DETECTED monotonic, align 1
  %3 = icmp eq i8 %2, 0
  br i1 %3, label %bb1.i, label %_RNvMs0_NtCs8b9n3vPMt31_13blake3_servil8platformNtB5_8Platform6detect.exit, !prof !575

bb1.i:                                            ; preds = %bb1
; call blake3_servil::platform::not_initialized
  %4 = tail call noundef i8 @_RNvNtCs8b9n3vPMt31_13blake3_servil8platform15not_initialized() #40
  unreachable

_RNvMs0_NtCs8b9n3vPMt31_13blake3_servil8platformNtB5_8Platform6detect.exit: ; preds = %bb1
  %5 = add nsw i8 %2, -3
  %6 = icmp slt i8 %2, 6
  tail call void @llvm.assume(i1 %6)
  %switch.idx.cast.i = zext nneg i8 %5 to i64
  %switch.idx.mult.i = shl nuw nsw i64 %switch.idx.cast.i, 3
  %7 = load atomic i8, ptr @_RNvNvNtCs8b9n3vPMt31_13blake3_servil8platform12x86_features8FEATURES.0 monotonic, align 1
  %8 = icmp eq i8 %7, 0
  br i1 %8, label %bb2.i.i, label %_RNvNtCs8b9n3vPMt31_13blake3_servil8platform13avx2_detected.exit, !prof !575

bb2.i.i:                                          ; preds = %_RNvMs0_NtCs8b9n3vPMt31_13blake3_servil8platformNtB5_8Platform6detect.exit
; call blake3_servil::platform::read_x86_features
  %9 = tail call fastcc noundef i8 @_RNvNtCs8b9n3vPMt31_13blake3_servil8platform17read_x86_features()
  store atomic i8 %9, ptr @_RNvNvNtCs8b9n3vPMt31_13blake3_servil8platform12x86_features8FEATURES.0 monotonic, align 1
  br label %_RNvNtCs8b9n3vPMt31_13blake3_servil8platform13avx2_detected.exit

_RNvNtCs8b9n3vPMt31_13blake3_servil8platform13avx2_detected.exit: ; preds = %_RNvMs0_NtCs8b9n3vPMt31_13blake3_servil8platformNtB5_8Platform6detect.exit, %bb2.i.i
  %features.sroa.0.0.i.i = phi i8 [ %9, %bb2.i.i ], [ %7, %_RNvMs0_NtCs8b9n3vPMt31_13blake3_servil8platformNtB5_8Platform6detect.exit ]
  %_1.i = and i8 %features.sroa.0.0.i.i, 4
  %_0.i.not = icmp eq i8 %_1.i, 0
  %..i = tail call i64 @llvm.umin.i64(i64 %switch.idx.mult.i, i64 8)
  %width.sroa.0.0 = select i1 %_0.i.not, i64 %switch.idx.mult.i, i64 %..i
  %10 = add nsw i64 %width.sroa.0.0, -1
  %or.cond = icmp ult i64 %10, %hashers.1
  br i1 %or.cond, label %bb10.preheader, label %bb25

bb10.preheader:                                   ; preds = %_RNvNtCs8b9n3vPMt31_13blake3_servil8platform13avx2_detected.exit
  %_13934.not = icmp eq i64 %1, 0
  br i1 %_13934.not, label %bb65, label %bb12

bb25:                                             ; preds = %bb65, %_RNvNtCs8b9n3vPMt31_13blake3_servil8platform13avx2_detected.exit, %start
  %pieces.sroa.9.0 = phi i64 [ %_89, %bb65 ], [ %1, %_RNvNtCs8b9n3vPMt31_13blake3_servil8platform13avx2_detected.exit ], [ %1, %start ]
  %pieces.sroa.0.0 = phi ptr [ %_93, %bb65 ], [ %0, %_RNvNtCs8b9n3vPMt31_13blake3_servil8platform13avx2_detected.exit ], [ %0, %start ]
  %_24 = icmp eq i64 %pieces.sroa.9.0, 0
  br i1 %_24, label %bb59, label %bb3.i

bb19:                                             ; preds = %bb8.i, %bb13.i, %bb14
  %_87 = icmp samesign ugt i64 %gathered.sroa.0.0935, %1
  br i1 %_87, label %bb64, label %bb65, !prof !4954

bb12:                                             ; preds = %bb10.preheader, %bb16
  %gathered.sroa.0.0935 = phi i64 [ %30, %bb16 ], [ 0, %bb10.preheader ]
  %11 = getelementptr inbounds nuw [24 x i8], ptr %0, i64 %gathered.sroa.0.0935
  %_18 = load i64, ptr %11, align 8, !noundef !566
  %_21 = icmp ult i64 %_18, %hashers.1
  br i1 %_21, label %bb14, label %panic1

panic1:                                           ; preds = %bb12
; call core::panicking::panic_bounds_check
  tail call void @_RNvNtCskADBYZwJmSU_4core9panicking18panic_bounds_check(i64 noundef %_18, i64 noundef %hashers.1, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(24) @alloc_c6ce6cb4e75d9cbf0cf1adbdcf76bc9c) #44
  unreachable

bb14:                                             ; preds = %bb12
  %_17 = getelementptr inbounds nuw [18432 x i8], ptr %hashers.0, i64 %_18
  %12 = getelementptr inbounds nuw i8, ptr %11, i64 8
  %_84.0 = load ptr, ptr %12, align 8, !nonnull !566, !noundef !566
  %13 = getelementptr inbounds nuw i8, ptr %11, i64 16
  %_84.1 = load i64, ptr %13, align 8, !noundef !566
  tail call void @llvm.experimental.noalias.scope.decl(metadata !4955)
  tail call void @llvm.experimental.noalias.scope.decl(metadata !4958)
  %14 = getelementptr inbounds nuw i8, ptr %_17, i64 1936
  %_4.i = load i64, ptr %14, align 16, !alias.scope !4955, !noalias !4958, !noundef !566
  %15 = icmp eq i64 %_4.i, 0
  %16 = getelementptr inbounds nuw i8, ptr %_17, i64 96
  %_5.i = load i64, ptr %16, align 32, !alias.scope !4955, !noalias !4958
  %17 = icmp eq i64 %_5.i, 0
  %or.cond.i = select i1 %15, i1 %17, i1 false
  %18 = getelementptr inbounds nuw i8, ptr %_17, i64 105
  %_6.i = load i8, ptr %18, align 1, !alias.scope !4955, !noalias !4958
  %19 = icmp eq i8 %_6.i, 0
  %or.cond4.i = select i1 %or.cond.i, i1 %19, i1 false
  %20 = getelementptr inbounds nuw i8, ptr %_17, i64 160
  %_7.i = load i64, ptr %20, align 32, !alias.scope !4955, !noalias !4958
  %21 = icmp eq i64 %_7.i, 0
  %or.cond6.i = select i1 %or.cond4.i, i1 %21, i1 false
  br i1 %or.cond6.i, label %bb8.i, label %bb19

bb8.i:                                            ; preds = %bb14
  %22 = getelementptr inbounds nuw i8, ptr %_17, i64 18368
  %_8.i = load i64, ptr %22, align 64, !alias.scope !4955, !noalias !4958, !noundef !566
  %23 = icmp eq i64 %_8.i, 0
  %24 = getelementptr inbounds nuw i8, ptr %_17, i64 104
  %_10.i = load i8, ptr %24, align 8, !alias.scope !4955, !noalias !4958
  %_9.i = zext i8 %_10.i to i64
  %25 = icmp eq i8 %_10.i, 64
  %or.cond8.i = select i1 %23, i1 true, i1 %25
  br i1 %or.cond8.i, label %bb13.i, label %bb19

bb13.i:                                           ; preds = %bb8.i
  %_13.i = add i64 %_8.i, %_84.1
  %_12.i = add i64 %_13.i, %_9.i
  %_11.i = icmp ugt i64 %_12.i, 1024
  br i1 %_11.i, label %bb19, label %bb16.i

bb16.i:                                           ; preds = %bb13.i
  %_19.i = sub nsw i64 64, %_9.i
  %..i.i = tail call noundef i64 @llvm.umin.i64(i64 %_19.i, i64 range(i64 0, -9223372036854775808) %_84.1)
  %_27.i = add nuw i64 %..i.i, %_9.i
  %_33.i = icmp ult i64 %_27.i, 65
  br i1 %_33.i, label %bb16, label %bb21.i, !prof !838

bb21.i:                                           ; preds = %bb16.i
; call core::slice::index::slice_index_fail
  tail call void @_RNvNtNtCskADBYZwJmSU_4core5slice5index16slice_index_fail(i64 noundef %_9.i, i64 noundef %_27.i, i64 noundef 64, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(24) @alloc_78b60beb4ccee4df3e3a673faf9be03d) #44, !noalias !4960
  unreachable

bb16:                                             ; preds = %bb16.i
  %_40.i = getelementptr inbounds nuw i8, ptr %_17, i64 %_9.i
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %_40.i, ptr nonnull readonly align 1 %_84.0, i64 range(i64 0, -9223372036854775808) %..i.i, i1 false), !alias.scope !4961, !noalias !4965
  %_29.i = trunc nuw i64 %..i.i to i8
  %26 = load i8, ptr %24, align 8, !alias.scope !4955, !noalias !4958, !noundef !566
  %27 = add i8 %26, %_29.i
  store i8 %27, ptr %24, align 8, !alias.scope !4955, !noalias !4958
  %_49.i = sub nuw nsw i64 %_84.1, %..i.i
  %_53.i = getelementptr inbounds nuw i8, ptr %_84.0, i64 %..i.i
  tail call void @llvm.experimental.noalias.scope.decl(metadata !4967)
  %_7.i.i = getelementptr inbounds nuw i8, ptr %_17, i64 1984
  %_8.i.i = load i64, ptr %22, align 64, !alias.scope !4970, !noalias !4972, !noundef !566
  %_4.i.i = getelementptr inbounds nuw i8, ptr %_7.i.i, i64 %_8.i.i
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %_4.i.i, ptr nonnull readonly align 1 %_53.i, i64 range(i64 0, -9223372036854775808) %_49.i, i1 false), !alias.scope !4973, !noalias !4977
  %28 = load i64, ptr %22, align 64, !alias.scope !4970, !noalias !4972, !noundef !566
  %29 = add i64 %28, %_49.i
  store i64 %29, ptr %22, align 64, !alias.scope !4970, !noalias !4972
  %30 = add nuw nsw i64 %gathered.sroa.0.0935, 1
  %exitcond.not = icmp eq i64 %30, %1
  br i1 %exitcond.not, label %bb65, label %bb12

bb65:                                             ; preds = %bb16, %bb10.preheader, %bb19
  %gathered.sroa.0.0.lcssa1651 = phi i64 [ %gathered.sroa.0.0935, %bb19 ], [ 0, %bb10.preheader ], [ %1, %bb16 ]
  %_89 = sub nuw nsw i64 %1, %gathered.sroa.0.0.lcssa1651
  %_93 = getelementptr inbounds nuw [24 x i8], ptr %0, i64 %gathered.sroa.0.0.lcssa1651
  br label %bb25

bb64:                                             ; preds = %bb19
; call core::slice::index::slice_index_fail
  tail call void @_RNvNtNtCskADBYZwJmSU_4core5slice5index16slice_index_fail(i64 noundef %gathered.sroa.0.0935, i64 noundef %1, i64 noundef %1, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(24) @alloc_97704351fb5e4069852e0a43be8d32bd) #44
  unreachable

bb3.i:                                            ; preds = %bb25
  %31 = mul nuw nsw i64 %pieces.sroa.9.0, 24
; call __rustc::__rust_no_alloc_shim_is_unstable_v2
  tail call void @_RNvCs5fGHjzWXRav_7___rustc35___rust_no_alloc_shim_is_unstable_v2() #36, !noalias !4979
; call __rustc::__rust_alloc
  %32 = tail call noundef align 8 ptr @_RNvCs5fGHjzWXRav_7___rustc12___rust_alloc(i64 noundef range(i64 0, -9223372036854775808) %31, i64 noundef range(i64 1, 129) 8) #36, !noalias !4979
  %33 = icmp eq ptr %32, null
  br i1 %33, label %bb69, label %bb10.i

bb10.i:                                           ; preds = %bb3.i
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 8 %32, ptr align 8 %pieces.sroa.0.0, i64 %31, i1 false)
  call void @llvm.lifetime.start.p0(ptr nonnull %waiting)
  store i64 0, ptr %waiting, align 8
  %34 = getelementptr inbounds nuw i8, ptr %waiting, i64 8
  store ptr inttoptr (i64 8 to ptr), ptr %34, align 8
  %35 = getelementptr inbounds nuw i8, ptr %waiting, i64 16
  store i64 0, ptr %35, align 8
  call void @llvm.lifetime.start.p0(ptr nonnull %held)
  store i64 0, ptr %held, align 8
  %36 = getelementptr inbounds nuw i8, ptr %held, i64 8
  store ptr inttoptr (i64 8 to ptr), ptr %36, align 8
  %37 = getelementptr inbounds nuw i8, ptr %held, i64 16
  store i64 0, ptr %37, align 8
  %vector1.sroa.4.0.vector.sroa_idx.i.i = getelementptr inbounds nuw i8, ptr %vector.i.i, i64 8
  %vector1.sroa.6.0.vector.sroa_idx.i.i = getelementptr inbounds nuw i8, ptr %vector.i.i, i64 16
  %_154.sroa.4.0.refs.sroa_idx.i.i = getelementptr inbounds nuw i8, ptr %refs.i.i, i64 8
  %_154.sroa.5.0.refs.sroa_idx.i.i = getelementptr inbounds nuw i8, ptr %refs.i.i, i64 16
  %_154.sroa.6.0.refs.sroa_idx.i.i = getelementptr inbounds nuw i8, ptr %refs.i.i, i64 24
  %_154.sroa.7.0.refs.sroa_idx.i.i = getelementptr inbounds nuw i8, ptr %refs.i.i, i64 32
  %_154.sroa.8.0.refs.sroa_idx.i.i = getelementptr inbounds nuw i8, ptr %refs.i.i, i64 40
  %_154.sroa.9.0.refs.sroa_idx.i.i = getelementptr inbounds nuw i8, ptr %refs.i.i, i64 48
  %_154.sroa.10.0.refs.sroa_idx.i.i = getelementptr inbounds nuw i8, ptr %refs.i.i, i64 56
  %_154.sroa.11.0.refs.sroa_idx.i.i = getelementptr inbounds nuw i8, ptr %refs.i.i, i64 64
  %_154.sroa.12.0.refs.sroa_idx.i.i = getelementptr inbounds nuw i8, ptr %refs.i.i, i64 72
  %_154.sroa.13.0.refs.sroa_idx.i.i = getelementptr inbounds nuw i8, ptr %refs.i.i, i64 80
  %_154.sroa.14.0.refs.sroa_idx.i.i = getelementptr inbounds nuw i8, ptr %refs.i.i, i64 88
  %_154.sroa.15.0.refs.sroa_idx.i.i = getelementptr inbounds nuw i8, ptr %refs.i.i, i64 96
  %_154.sroa.16.0.refs.sroa_idx.i.i = getelementptr inbounds nuw i8, ptr %refs.i.i, i64 104
  %_154.sroa.17.0.refs.sroa_idx.i.i = getelementptr inbounds nuw i8, ptr %refs.i.i, i64 112
  %_154.sroa.18.0.refs.sroa_idx.i.i = getelementptr inbounds nuw i8, ptr %refs.i.i, i64 120
  %_20.sroa.4.0.p.sroa_idx.i.i.i = getelementptr inbounds nuw i8, ptr %p.i.i.i, i64 8
  %_20.sroa.5.0.p.sroa_idx.i.i.i = getelementptr inbounds nuw i8, ptr %p.i.i.i, i64 16
  %_20.sroa.6.0.p.sroa_idx.i.i.i = getelementptr inbounds nuw i8, ptr %p.i.i.i, i64 24
  %_20.sroa.7.0.p.sroa_idx.i.i.i = getelementptr inbounds nuw i8, ptr %p.i.i.i, i64 32
  %_20.sroa.8.0.p.sroa_idx.i.i.i = getelementptr inbounds nuw i8, ptr %p.i.i.i, i64 40
  %_20.sroa.9.0.p.sroa_idx.i.i.i = getelementptr inbounds nuw i8, ptr %p.i.i.i, i64 48
  %_20.sroa.10.0.p.sroa_idx.i.i.i = getelementptr inbounds nuw i8, ptr %p.i.i.i, i64 56
  %38 = getelementptr inbounds nuw i8, ptr %p.i.i.i, i64 64
  %_22.sroa.4.0..sroa_idx.i.i.i = getelementptr inbounds nuw i8, ptr %p.i.i.i, i64 68
  %_22.sroa.5.0..sroa_idx.i.i.i = getelementptr inbounds nuw i8, ptr %p.i.i.i, i64 72
  %_22.sroa.6.0..sroa_idx.i.i.i = getelementptr inbounds nuw i8, ptr %p.i.i.i, i64 76
  %_22.sroa.7.0..sroa_idx.i.i.i = getelementptr inbounds nuw i8, ptr %p.i.i.i, i64 80
  %_22.sroa.8.0..sroa_idx.i.i.i = getelementptr inbounds nuw i8, ptr %p.i.i.i, i64 84
  %_22.sroa.9.0..sroa_idx.i.i.i = getelementptr inbounds nuw i8, ptr %p.i.i.i, i64 88
  %_22.sroa.10.0..sroa_idx.i.i.i = getelementptr inbounds nuw i8, ptr %p.i.i.i, i64 92
  %_22.sroa.11.0..sroa_idx.i.i.i = getelementptr inbounds nuw i8, ptr %p.i.i.i, i64 96
  %_22.sroa.12.0..sroa_idx.i.i.i = getelementptr inbounds nuw i8, ptr %p.i.i.i, i64 100
  %_22.sroa.13.0..sroa_idx.i.i.i = getelementptr inbounds nuw i8, ptr %p.i.i.i, i64 104
  %_22.sroa.14.0..sroa_idx.i.i.i = getelementptr inbounds nuw i8, ptr %p.i.i.i, i64 108
  %_22.sroa.15.0..sroa_idx.i.i.i = getelementptr inbounds nuw i8, ptr %p.i.i.i, i64 112
  %_22.sroa.16.0..sroa_idx.i.i.i = getelementptr inbounds nuw i8, ptr %p.i.i.i, i64 116
  %_22.sroa.17.0..sroa_idx.i.i.i = getelementptr inbounds nuw i8, ptr %p.i.i.i, i64 120
  %_22.sroa.18.0..sroa_idx.i.i.i = getelementptr inbounds nuw i8, ptr %p.i.i.i, i64 124
  %_22.sroa.19.0..sroa_idx.i.i.i = getelementptr inbounds nuw i8, ptr %p.i.i.i, i64 128
  %_22.sroa.20.0..sroa_idx.i.i.i = getelementptr inbounds nuw i8, ptr %p.i.i.i, i64 132
  %_22.sroa.21.0..sroa_idx.i.i.i = getelementptr inbounds nuw i8, ptr %p.i.i.i, i64 136
  %_22.sroa.22.0..sroa_idx.i.i.i = getelementptr inbounds nuw i8, ptr %p.i.i.i, i64 140
  %_22.sroa.23.0..sroa_idx.i.i.i = getelementptr inbounds nuw i8, ptr %p.i.i.i, i64 144
  %_22.sroa.24.0..sroa_idx.i.i.i = getelementptr inbounds nuw i8, ptr %p.i.i.i, i64 148
  %_22.sroa.25.0..sroa_idx.i.i.i = getelementptr inbounds nuw i8, ptr %p.i.i.i, i64 152
  %_22.sroa.26.0..sroa_idx.i.i.i = getelementptr inbounds nuw i8, ptr %p.i.i.i, i64 156
  %_22.sroa.27.0..sroa_idx.i.i.i = getelementptr inbounds nuw i8, ptr %p.i.i.i, i64 160
  %_22.sroa.28.0..sroa_idx.i.i.i = getelementptr inbounds nuw i8, ptr %p.i.i.i, i64 164
  %_22.sroa.29.0..sroa_idx.i.i.i = getelementptr inbounds nuw i8, ptr %p.i.i.i, i64 168
  %_22.sroa.30.0..sroa_idx.i.i.i = getelementptr inbounds nuw i8, ptr %p.i.i.i, i64 172
  %_22.sroa.31.0..sroa_idx.i.i.i = getelementptr inbounds nuw i8, ptr %p.i.i.i, i64 176
  %_22.sroa.32.0..sroa_idx.i.i.i = getelementptr inbounds nuw i8, ptr %p.i.i.i, i64 180
  %_22.sroa.33.0..sroa_idx.i.i.i = getelementptr inbounds nuw i8, ptr %p.i.i.i, i64 184
  %_22.sroa.34.0..sroa_idx.i.i.i = getelementptr inbounds nuw i8, ptr %p.i.i.i, i64 188
  %_22.sroa.35.0..sroa_idx.i.i.i = getelementptr inbounds nuw i8, ptr %p.i.i.i, i64 192
  %_22.sroa.36.0..sroa_idx.i.i.i = getelementptr inbounds nuw i8, ptr %p.i.i.i, i64 196
  %_22.sroa.37.0..sroa_idx.i.i.i = getelementptr inbounds nuw i8, ptr %p.i.i.i, i64 200
  %_22.sroa.38.0..sroa_idx.i.i.i = getelementptr inbounds nuw i8, ptr %p.i.i.i, i64 204
  %_22.sroa.39.0..sroa_idx.i.i.i = getelementptr inbounds nuw i8, ptr %p.i.i.i, i64 208
  %_22.sroa.40.0..sroa_idx.i.i.i = getelementptr inbounds nuw i8, ptr %p.i.i.i, i64 212
  %_22.sroa.41.0..sroa_idx.i.i.i = getelementptr inbounds nuw i8, ptr %p.i.i.i, i64 216
  %_22.sroa.42.0..sroa_idx.i.i.i = getelementptr inbounds nuw i8, ptr %p.i.i.i, i64 220
  %_22.sroa.43.0..sroa_idx.i.i.i = getelementptr inbounds nuw i8, ptr %p.i.i.i, i64 224
  %_22.sroa.44.0..sroa_idx.i.i.i = getelementptr inbounds nuw i8, ptr %p.i.i.i, i64 228
  %_22.sroa.45.0..sroa_idx.i.i.i = getelementptr inbounds nuw i8, ptr %p.i.i.i, i64 232
  %_22.sroa.46.0..sroa_idx.i.i.i = getelementptr inbounds nuw i8, ptr %p.i.i.i, i64 236
  %_22.sroa.47.0..sroa_idx.i.i.i = getelementptr inbounds nuw i8, ptr %p.i.i.i, i64 240
  %_22.sroa.48.0..sroa_idx.i.i.i = getelementptr inbounds nuw i8, ptr %p.i.i.i, i64 244
  %_22.sroa.49.0..sroa_idx.i.i.i = getelementptr inbounds nuw i8, ptr %p.i.i.i, i64 248
  %_22.sroa.50.0..sroa_idx.i.i.i = getelementptr inbounds nuw i8, ptr %p.i.i.i, i64 252
  %_22.sroa.51.0..sroa_idx.i.i.i = getelementptr inbounds nuw i8, ptr %p.i.i.i, i64 256
  %_22.sroa.52.0..sroa_idx.i.i.i = getelementptr inbounds nuw i8, ptr %p.i.i.i, i64 260
  %_22.sroa.53.0..sroa_idx.i.i.i = getelementptr inbounds nuw i8, ptr %p.i.i.i, i64 264
  %_22.sroa.54.0..sroa_idx.i.i.i = getelementptr inbounds nuw i8, ptr %p.i.i.i, i64 268
  %_22.sroa.55.0..sroa_idx.i.i.i = getelementptr inbounds nuw i8, ptr %p.i.i.i, i64 272
  %_22.sroa.56.0..sroa_idx.i.i.i = getelementptr inbounds nuw i8, ptr %p.i.i.i, i64 276
  %_22.sroa.57.0..sroa_idx.i.i.i = getelementptr inbounds nuw i8, ptr %p.i.i.i, i64 280
  %_22.sroa.58.0..sroa_idx.i.i.i = getelementptr inbounds nuw i8, ptr %p.i.i.i, i64 284
  %_22.sroa.59.0..sroa_idx.i.i.i = getelementptr inbounds nuw i8, ptr %p.i.i.i, i64 288
  %_22.sroa.60.0..sroa_idx.i.i.i = getelementptr inbounds nuw i8, ptr %p.i.i.i, i64 292
  %_22.sroa.61.0..sroa_idx.i.i.i = getelementptr inbounds nuw i8, ptr %p.i.i.i, i64 296
  %_22.sroa.62.0..sroa_idx.i.i.i = getelementptr inbounds nuw i8, ptr %p.i.i.i, i64 300
  %_22.sroa.63.0..sroa_idx.i.i.i = getelementptr inbounds nuw i8, ptr %p.i.i.i, i64 304
  %_22.sroa.64.0..sroa_idx.i.i.i = getelementptr inbounds nuw i8, ptr %p.i.i.i, i64 308
  %_22.sroa.65.0..sroa_idx.i.i.i = getelementptr inbounds nuw i8, ptr %p.i.i.i, i64 312
  %_22.sroa.66.0..sroa_idx.i.i.i = getelementptr inbounds nuw i8, ptr %p.i.i.i, i64 316
  %39 = getelementptr inbounds nuw i8, ptr %p.i.i.i, i64 320
  %_24.sroa.7.0..sroa_idx.i.i.i = getelementptr inbounds nuw i8, ptr %p.i.i.i, i64 336
  %40 = getelementptr inbounds nuw i8, ptr %p.i.i.i, i64 352
  %_26.sroa.7.0..sroa_idx.i.i.i = getelementptr inbounds nuw i8, ptr %p.i.i.i, i64 368
  %_225.sroa.4.0.inputs2.sroa_idx.i.i = getelementptr inbounds nuw i8, ptr %inputs2.i.i, i64 8
  %_225.sroa.5.0.inputs2.sroa_idx.i.i = getelementptr inbounds nuw i8, ptr %inputs2.i.i, i64 16
  %_225.sroa.6.0.inputs2.sroa_idx.i.i = getelementptr inbounds nuw i8, ptr %inputs2.i.i, i64 17
  %_225.sroa.7407.0.inputs2.sroa_idx.i.i = getelementptr inbounds nuw i8, ptr %inputs2.i.i, i64 24
  %_225.sroa.8.0.inputs2.sroa_idx.i.i = getelementptr inbounds nuw i8, ptr %inputs2.i.i, i64 32
  %_225.sroa.9.0.inputs2.sroa_idx.i.i = getelementptr inbounds nuw i8, ptr %inputs2.i.i, i64 40
  %_225.sroa.10.0.inputs2.sroa_idx.i.i = getelementptr inbounds nuw i8, ptr %inputs2.i.i, i64 41
  %_225.sroa.11408.0.inputs2.sroa_idx.i.i = getelementptr inbounds nuw i8, ptr %inputs2.i.i, i64 48
  %_225.sroa.12.0.inputs2.sroa_idx.i.i = getelementptr inbounds nuw i8, ptr %inputs2.i.i, i64 56
  %_225.sroa.13.0.inputs2.sroa_idx.i.i = getelementptr inbounds nuw i8, ptr %inputs2.i.i, i64 64
  %_225.sroa.14.0.inputs2.sroa_idx.i.i = getelementptr inbounds nuw i8, ptr %inputs2.i.i, i64 65
  %_225.sroa.15409.0.inputs2.sroa_idx.i.i = getelementptr inbounds nuw i8, ptr %inputs2.i.i, i64 72
  %_225.sroa.16.0.inputs2.sroa_idx.i.i = getelementptr inbounds nuw i8, ptr %inputs2.i.i, i64 80
  %_225.sroa.17.0.inputs2.sroa_idx.i.i = getelementptr inbounds nuw i8, ptr %inputs2.i.i, i64 88
  %_225.sroa.18.0.inputs2.sroa_idx.i.i = getelementptr inbounds nuw i8, ptr %inputs2.i.i, i64 89
  %_225.sroa.19410.0.inputs2.sroa_idx.i.i = getelementptr inbounds nuw i8, ptr %inputs2.i.i, i64 96
  %_225.sroa.20.0.inputs2.sroa_idx.i.i = getelementptr inbounds nuw i8, ptr %inputs2.i.i, i64 104
  %_225.sroa.21.0.inputs2.sroa_idx.i.i = getelementptr inbounds nuw i8, ptr %inputs2.i.i, i64 112
  %_225.sroa.22.0.inputs2.sroa_idx.i.i = getelementptr inbounds nuw i8, ptr %inputs2.i.i, i64 113
  %_225.sroa.23411.0.inputs2.sroa_idx.i.i = getelementptr inbounds nuw i8, ptr %inputs2.i.i, i64 120
  %_225.sroa.24.0.inputs2.sroa_idx.i.i = getelementptr inbounds nuw i8, ptr %inputs2.i.i, i64 128
  %_225.sroa.25.0.inputs2.sroa_idx.i.i = getelementptr inbounds nuw i8, ptr %inputs2.i.i, i64 136
  %_225.sroa.26.0.inputs2.sroa_idx.i.i = getelementptr inbounds nuw i8, ptr %inputs2.i.i, i64 137
  %_225.sroa.27412.0.inputs2.sroa_idx.i.i = getelementptr inbounds nuw i8, ptr %inputs2.i.i, i64 144
  %_225.sroa.28.0.inputs2.sroa_idx.i.i = getelementptr inbounds nuw i8, ptr %inputs2.i.i, i64 152
  %_225.sroa.29.0.inputs2.sroa_idx.i.i = getelementptr inbounds nuw i8, ptr %inputs2.i.i, i64 160
  %_225.sroa.30.0.inputs2.sroa_idx.i.i = getelementptr inbounds nuw i8, ptr %inputs2.i.i, i64 161
  %_225.sroa.31413.0.inputs2.sroa_idx.i.i = getelementptr inbounds nuw i8, ptr %inputs2.i.i, i64 168
  %_225.sroa.32.0.inputs2.sroa_idx.i.i = getelementptr inbounds nuw i8, ptr %inputs2.i.i, i64 176
  %_225.sroa.33.0.inputs2.sroa_idx.i.i = getelementptr inbounds nuw i8, ptr %inputs2.i.i, i64 184
  %_225.sroa.34.0.inputs2.sroa_idx.i.i = getelementptr inbounds nuw i8, ptr %inputs2.i.i, i64 185
  br label %bb72.preheader

bb69:                                             ; preds = %bb3.i
; call alloc::raw_vec::handle_error
  tail call void @_RNvNtCsgFX3jaOk65H_5alloc7raw_vec12handle_error(i64 noundef 8, i64 %31) #41
  unreachable

bb72.preheader:                                   ; preds = %bb55, %bb10.i
  %waiting.val37 = phi i64 [ %pieces.sroa.9.0, %bb10.i ], [ %_4.sroa.0.0.copyload.i.i.i.i.i, %bb55 ]
  %turn.sroa.7.0943.in = phi ptr [ %32, %bb10.i ], [ %_181, %bb55 ]
  %turn.sroa.15.0942 = phi i64 [ %pieces.sroa.9.0, %bb10.i ], [ %_180, %bb55 ]
  %turn.sroa.7.0943 = ptrtoint ptr %turn.sroa.7.0943.in to i64
  %_121.idx = mul nuw nsw i64 %turn.sroa.15.0942, 24
  %_121 = getelementptr inbounds nuw i8, ptr %turn.sroa.7.0943.in, i64 %_121.idx
  br label %bb72

bb29:                                             ; preds = %bb55
  %held.val = load i64, ptr %held, align 8
  %41 = icmp eq i64 %held.val, 0
  br i1 %41, label %bb56, label %bb2.i.i.i4.i

bb2.i.i.i4.i:                                     ; preds = %bb29
  %alloc_size.i.i.i.i5.i = shl nuw i64 %held.val, 3
; call __rustc::__rust_dealloc
  call void @_RNvCs5fGHjzWXRav_7___rustc14___rust_dealloc(ptr noundef nonnull %_148, i64 noundef %alloc_size.i.i.i.i5.i, i64 noundef range(i64 1, -9223372036854775807) 8) #36
  br label %bb56

bb72:                                             ; preds = %bb72.preheader, %bb31.backedge
  %iter.sroa.0.0940 = phi ptr [ %_133, %bb31.backedge ], [ %turn.sroa.7.0943.in, %bb72.preheader ]
  %_133 = getelementptr inbounds nuw i8, ptr %iter.sroa.0.0940, i64 24
  %i = load i64, ptr %iter.sroa.0.0940, align 8, !noundef !566
  %42 = getelementptr inbounds nuw i8, ptr %iter.sroa.0.0940, i64 8
  %bytes.0 = load ptr, ptr %42, align 8, !nonnull !566, !noundef !566
  %43 = getelementptr inbounds nuw i8, ptr %iter.sroa.0.0940, i64 16
  %bytes.1 = load i64, ptr %43, align 8, !noundef !566
  %_37 = icmp ult i64 %i, %hashers.1
  br i1 %_37, label %bb33, label %panic3

bb71:                                             ; preds = %bb31.backedge
  %_138 = load ptr, ptr %36, align 8, !nonnull !566, !noundef !566
  %_137 = load i64, ptr %37, align 8, !noundef !566
  call void @llvm.experimental.noalias.scope.decl(metadata !4982)
  call void @llvm.experimental.noalias.scope.decl(metadata !4985)
  %_36.not.i = icmp eq i64 %_137, 0
  br i1 %_36.not.i, label %bb46, label %bb23.i

bb23.i:                                           ; preds = %bb71
  %_first.i = load i64, ptr %_138, align 8, !alias.scope !4985, !noalias !4982, !noundef !566
  %_41.idx.i = shl nuw nsw i64 %_137, 3
  %_41.i = getelementptr inbounds nuw i8, ptr %_138, i64 %_41.idx.i
  call void @llvm.experimental.noalias.scope.decl(metadata !4987)
  br label %bb13.i.i

bb1.i.i:                                          ; preds = %_RNCNvNtCs8b9n3vPMt31_13blake3_servil4each9hash_held0B5_.exit.i.i
  %_22.i.i = getelementptr inbounds nuw i8, ptr %_223.i.i3062, i64 8
  %_12.i.i = icmp eq ptr %_22.i.i, %_41.i
  br i1 %_12.i.i, label %bb2.i48, label %bb13.i.i

bb13.i.i:                                         ; preds = %bb23.i, %bb1.i.i
  %_223.i.i3062 = phi ptr [ %_138, %bb23.i ], [ %_22.i.i, %bb1.i.i ]
  %ptr.val.i.i = load i64, ptr %_223.i.i3062, align 8, !alias.scope !4985, !noalias !4990, !noundef !566
  %_6.i.i.i = icmp ult i64 %ptr.val.i.i, %hashers.1
  br i1 %_6.i.i.i, label %_RNCNvNtCs8b9n3vPMt31_13blake3_servil4each9hash_held0B5_.exit.i.i, label %panic.i.i.i.invoke

panic.i.i.i.invoke:                               ; preds = %bb4.i, %bb13.i.i, %bb3.i.i.i.i.i.i, %bb13.i133
  %44 = phi i64 [ %ptr.val.i.i, %bb13.i.i ], [ %ptr.val.i, %bb13.i133 ], [ %.val.i.i.i.i.i.i, %bb3.i.i.i.i.i.i ], [ %_first.i, %bb4.i ]
  %45 = phi ptr [ @alloc_de5677d598f96fab83bb6e164da38b0e, %bb13.i.i ], [ @alloc_8f03386cea946c1c0643608dbb76005a, %bb13.i133 ], [ @alloc_761526eea504fb7d2dcacf55bdabfbaf, %bb3.i.i.i.i.i.i ], [ @alloc_93218d9d0919b55aae090af3fd23460b, %bb4.i ]
; invoke core::panicking::panic_bounds_check
  invoke void @_RNvNtCskADBYZwJmSU_4core9panicking18panic_bounds_check(i64 noundef %44, i64 noundef range(i64 0, 500399958596722) %hashers.1, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(24) %45) #44
          to label %panic.i.i.i.cont unwind label %cleanup.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp

panic.i.i.i.cont:                                 ; preds = %panic.i.i.i.invoke
  unreachable

_RNCNvNtCs8b9n3vPMt31_13blake3_servil4each9hash_held0B5_.exit.i.i: ; preds = %bb13.i.i
  %46 = getelementptr inbounds nuw [18432 x i8], ptr %hashers.0, i64 %ptr.val.i.i
  %47 = getelementptr inbounds nuw i8, ptr %46, i64 106
  %_4.i.i.i = load i8, ptr %47, align 2, !alias.scope !4992, !noalias !4993, !noundef !566
  %_0.i.i.i = icmp eq i8 %_4.i.i.i, 0
  br i1 %_0.i.i.i, label %bb1.i.i, label %bb4.i

bb4.i:                                            ; preds = %_RNCNvNtCs8b9n3vPMt31_13blake3_servil4each9hash_held0B5_.exit.i.i
  %_13.i41 = icmp ult i64 %_first.i, %hashers.1
  br i1 %_13.i41, label %bb5.i, label %panic.i.i.i.invoke

bb2.i48:                                          ; preds = %bb1.i.i
; invoke blake3_servil::each::hash_cohort
  invoke fastcc void @_RNvNtCs8b9n3vPMt31_13blake3_servil4each11hash_cohort(ptr noalias nofree noundef nonnull align 64 %hashers.0, i64 noundef range(i64 0, 500399958596722) %hashers.1, ptr noalias nofree noundef nonnull readonly align 8 captures(address, read_provenance) %_138, i64 noundef range(i64 0, 1152921504606846976) %_137)
          to label %bb46 unwind label %cleanup.loopexit.split-lp.loopexit.split-lp.loopexit

bb5.i:                                            ; preds = %bb4.i
  %48 = getelementptr inbounds nuw [18432 x i8], ptr %hashers.0, i64 %_first.i
  %49 = getelementptr inbounds nuw i8, ptr %48, i64 107
  %platform.i = load i8, ptr %49, align 1, !range !891, !alias.scope !4982, !noalias !4985, !noundef !566
  call void @llvm.experimental.noalias.scope.decl(metadata !4994)
  call void @llvm.experimental.noalias.scope.decl(metadata !4997)
  switch i8 %platform.i, label %default.unreachable [
    i8 4, label %bb104.i.i
    i8 5, label %bb53.i.i
    i8 3, label %bb8.i42
  ]

default.unreachable:                              ; preds = %bb5.i
  unreachable

bb53.i.i:                                         ; preds = %bb5.i
  br label %bb104.i.i

bb104.i.i:                                        ; preds = %bb53.i.i, %bb5.i
  %50 = phi i1 [ true, %bb53.i.i ], [ false, %bb5.i ]
  %width.sroa.0.0.i.i = phi i64 [ 16, %bb53.i.i ], [ 8, %bb5.i ]
  %_7.i.i47 = shl nuw i64 %_137, 4
  %_34.0.i.i.i.i.i = shl i64 %_137, 9
  %_34.1.i.i.i.i.i = icmp samesign ugt i64 %_137, 36028797018963967
  %_39.not.i.i.i.i.i = icmp slt i64 %_34.0.i.i.i.i.i, 0
  %or.cond.i.i.i.i.i = or i1 %_34.1.i.i.i.i.i, %_39.not.i.i.i.i.i
  br i1 %or.cond.i.i.i.i.i, label %bb3.i.i.i.i.invoke, label %bb3.i.i.i.i.i, !prof !2162

bb3.i.i.i.i.i:                                    ; preds = %bb104.i.i
; call __rustc::__rust_no_alloc_shim_is_unstable_v2
  call void @_RNvCs5fGHjzWXRav_7___rustc35___rust_no_alloc_shim_is_unstable_v2() #36, !noalias !4999
; call __rustc::__rust_alloc
  %51 = call noundef ptr @_RNvCs5fGHjzWXRav_7___rustc12___rust_alloc(i64 noundef range(i64 0, -9223372036854775808) %_34.0.i.i.i.i.i, i64 noundef range(i64 1, 129) 1) #36, !noalias !4999
  %52 = icmp eq ptr %51, null
  br i1 %52, label %bb3.i.i.i.i.invoke, label %bb3.i2.i.i.preheader.i

bb3.i2.i.i.preheader.i:                           ; preds = %bb3.i.i.i.i.i
  %53 = add nsw i64 %_34.0.i.i.i.i.i, -32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 1 dereferenceable(1) %51, i8 0, i64 %53, i1 false), !noalias !5005
  %scevgep.i = getelementptr i8, ptr %51, i64 %53
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 1 dereferenceable(32) %scevgep.i, i8 0, i64 32, i1 false), !noalias !5005
  %54 = ptrtoint ptr %51 to i64
  %_34.0.i.i.i53.i.i = shl nuw nsw i64 %_137, 8
; call __rustc::__rust_no_alloc_shim_is_unstable_v2
  call void @_RNvCs5fGHjzWXRav_7___rustc35___rust_no_alloc_shim_is_unstable_v2() #36, !noalias !5006
; call __rustc::__rust_alloc
  %55 = call noundef ptr @_RNvCs5fGHjzWXRav_7___rustc12___rust_alloc(i64 noundef range(i64 0, -9223372036854775808) %_34.0.i.i.i53.i.i, i64 noundef range(i64 1, 129) 1) #36, !noalias !5006
  %56 = icmp eq ptr %55, null
  br i1 %56, label %bb3.i.i74.i.i, label %bb3.i2.i68.i.preheader.i

bb3.i.i.i.i.invoke:                               ; preds = %bb3.i.i.i9.i, %bb104.i.i, %bb3.i.i.i.i.i
  %57 = phi i64 [ 0, %bb104.i.i ], [ 1, %bb3.i.i.i.i.i ], [ 8, %bb3.i.i.i9.i ]
  %58 = phi i64 [ %_34.0.i.i.i.i.i, %bb104.i.i ], [ %_34.0.i.i.i.i.i, %bb3.i.i.i.i.i ], [ 32, %bb3.i.i.i9.i ]
; invoke alloc::raw_vec::handle_error
  invoke void @_RNvNtCsgFX3jaOk65H_5alloc7raw_vec12handle_error(i64 noundef %57, i64 %58) #41
          to label %bb3.i.i.i.i.cont unwind label %cleanup.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp

bb3.i.i.i.i.cont:                                 ; preds = %bb3.i.i.i.i.invoke
  unreachable

bb3.i2.i68.i.preheader.i:                         ; preds = %bb3.i2.i.i.preheader.i
  %59 = add nsw i64 %_34.0.i.i.i53.i.i, -32
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 1 dereferenceable(1) %55, i8 0, i64 %59, i1 false), !noalias !5005
  %scevgep456.i = getelementptr i8, ptr %55, i64 %59
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 1 dereferenceable(32) %scevgep456.i, i8 0, i64 32, i1 false), !noalias !5005
  %60 = ptrtoint ptr %55 to i64
  br label %bb6.i.i

bb3.i.i74.i.i:                                    ; preds = %bb3.i2.i.i.preheader.i
; invoke alloc::raw_vec::handle_error
  invoke void @_RNvNtCsgFX3jaOk65H_5alloc7raw_vec12handle_error(i64 noundef 1, i64 %_34.0.i.i.i53.i.i) #41
          to label %.noexc76.i.i unwind label %cleanup.i.i, !noalias !5005

.noexc76.i.i:                                     ; preds = %bb3.i.i74.i.i
  unreachable

cleanup.i.i:                                      ; preds = %bb3.i.i74.i.i
  %61 = landingpad { ptr, i32 }
          cleanup
  br label %bb50.i.i

bb12.preheader.i.i:                               ; preds = %bb11.i.i
  %62 = call range(i64 3, 65) i64 @llvm.cttz.i64(i64 %width.sroa.0.0.i.i, i1 true)
  %63 = icmp eq i8 %platform.i, 5
  br label %bb67.i.i

cleanup9.loopexit.i.i:                            ; preds = %bb1.i102.i.i
  %lpad.loopexit.i.i = landingpad { ptr, i32 }
          cleanup
  br label %bb2.i.i.i4.i78.i.i

cleanup9.loopexit.split-lp.loopexit.i.i:          ; preds = %bb82.i.i
  %lpad.loopexit462.i.i = landingpad { ptr, i32 }
          cleanup
  br label %bb2.i.i.i4.i78.i.i

cleanup9.loopexit.split-lp.loopexit.split-lp.loopexit.i.i: ; preds = %bb10.i.i
  %lpad.loopexit465.i.i = landingpad { ptr, i32 }
          cleanup
  br label %bb2.i.i.i4.i78.i.i

cleanup9.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.i.i: ; preds = %panic2.i.i.i.i.i191.i.i.invoke, %bb8.i.i.i.i.i197.i.i.invoke, %bb77.i.i.invoke, %bb60.i.i, %bb56.i.i, %panic17.i.i, %bb98.i.i, %bb95.i.i, %panic.invoke.i.i
  %level.sroa.7.1.ph.ph.ph.i.i = phi i64 [ %next.sroa.7.1652.i.i, %bb98.i.i ], [ %next.sroa.7.1652.i.i, %bb95.i.i ], [ %next.sroa.7.1652.i.i, %panic.invoke.i.i ], [ %level.sroa.7.2646.i.i, %panic2.i.i.i.i.i191.i.i.invoke ], [ %level.sroa.7.2646.i.i, %bb8.i.i.i.i.i197.i.i.invoke ], [ %level.sroa.7.2646.i.i, %bb77.i.i.invoke ], [ %54, %panic17.i.i ], [ %54, %bb56.i.i ], [ %54, %bb60.i.i ]
  %level.sroa.0.1.ph.ph.ph.i.i = phi i64 [ %next.sroa.0.1654.i.i, %bb98.i.i ], [ %next.sroa.0.1654.i.i, %bb95.i.i ], [ %next.sroa.0.1654.i.i, %panic.invoke.i.i ], [ %level.sroa.0.2648.i.i, %panic2.i.i.i.i.i191.i.i.invoke ], [ %level.sroa.0.2648.i.i, %bb8.i.i.i.i.i197.i.i.invoke ], [ %level.sroa.0.2648.i.i, %bb77.i.i.invoke ], [ %_7.i.i47, %panic17.i.i ], [ %_7.i.i47, %bb56.i.i ], [ %_7.i.i47, %bb60.i.i ]
  %next.sroa.7.0.ph.ph.ph.i.i = phi i64 [ %level.sroa.7.2646.i.i, %bb98.i.i ], [ %level.sroa.7.2646.i.i, %bb95.i.i ], [ %level.sroa.7.2646.i.i, %panic.invoke.i.i ], [ %next.sroa.7.1652.i.i, %panic2.i.i.i.i.i191.i.i.invoke ], [ %next.sroa.7.1652.i.i, %bb8.i.i.i.i.i197.i.i.invoke ], [ %next.sroa.7.1652.i.i, %bb77.i.i.invoke ], [ %60, %panic17.i.i ], [ %60, %bb56.i.i ], [ %60, %bb60.i.i ]
  %next.sroa.0.0.ph.ph.ph.i.i = phi i64 [ %level.sroa.0.2648.i.i, %bb98.i.i ], [ %level.sroa.0.2648.i.i, %bb95.i.i ], [ %level.sroa.0.2648.i.i, %panic.invoke.i.i ], [ %next.sroa.0.1654.i.i, %panic2.i.i.i.i.i191.i.i.invoke ], [ %next.sroa.0.1654.i.i, %bb8.i.i.i.i.i197.i.i.invoke ], [ %next.sroa.0.1654.i.i, %bb77.i.i.invoke ], [ %_41.idx.i, %panic17.i.i ], [ %_41.idx.i, %bb56.i.i ], [ %_41.idx.i, %bb60.i.i ]
  %lpad.loopexit.split-lp.i.i = landingpad { ptr, i32 }
          cleanup
  br label %bb2.i.i.i4.i78.i.i

bb2.i.i.i4.i78.i.i:                               ; preds = %cleanup9.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.i.i, %cleanup9.loopexit.split-lp.loopexit.split-lp.loopexit.i.i, %cleanup9.loopexit.split-lp.loopexit.i.i, %cleanup9.loopexit.i.i
  %level.sroa.7.1.i.i = phi i64 [ %next.sroa.7.1652.i.i, %cleanup9.loopexit.i.i ], [ %level.sroa.7.2646.i.i, %cleanup9.loopexit.split-lp.loopexit.i.i ], [ %54, %cleanup9.loopexit.split-lp.loopexit.split-lp.loopexit.i.i ], [ %level.sroa.7.1.ph.ph.ph.i.i, %cleanup9.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.i.i ]
  %level.sroa.0.1.i.i = phi i64 [ %next.sroa.0.1654.i.i, %cleanup9.loopexit.i.i ], [ %level.sroa.0.2648.i.i, %cleanup9.loopexit.split-lp.loopexit.i.i ], [ %_7.i.i47, %cleanup9.loopexit.split-lp.loopexit.split-lp.loopexit.i.i ], [ %level.sroa.0.1.ph.ph.ph.i.i, %cleanup9.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.i.i ]
  %next.sroa.7.0.i.i = phi i64 [ %level.sroa.7.2646.i.i, %cleanup9.loopexit.i.i ], [ %next.sroa.7.1652.i.i, %cleanup9.loopexit.split-lp.loopexit.i.i ], [ %60, %cleanup9.loopexit.split-lp.loopexit.split-lp.loopexit.i.i ], [ %next.sroa.7.0.ph.ph.ph.i.i, %cleanup9.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.i.i ]
  %next.sroa.0.0.i.i = phi i64 [ %level.sroa.0.2648.i.i, %cleanup9.loopexit.i.i ], [ %next.sroa.0.1654.i.i, %cleanup9.loopexit.split-lp.loopexit.i.i ], [ %_41.idx.i, %cleanup9.loopexit.split-lp.loopexit.split-lp.loopexit.i.i ], [ %next.sroa.0.0.ph.ph.ph.i.i, %cleanup9.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.i.i ]
  %lpad.phi.i.i = phi { ptr, i32 } [ %lpad.loopexit.i.i, %cleanup9.loopexit.i.i ], [ %lpad.loopexit462.i.i, %cleanup9.loopexit.split-lp.loopexit.i.i ], [ %lpad.loopexit465.i.i, %cleanup9.loopexit.split-lp.loopexit.split-lp.loopexit.i.i ], [ %lpad.loopexit.split-lp.i.i, %cleanup9.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.i.i ]
  %64 = inttoptr i64 %next.sroa.7.0.i.i to ptr
  %alloc_size.i.i.i.i5.i79.i.i = shl nuw i64 %next.sroa.0.0.i.i, 5
  call void @llvm.assume(i1 true) [ "nonnull"(ptr %64) ]
; call __rustc::__rust_dealloc
  call void @_RNvCs5fGHjzWXRav_7___rustc14___rust_dealloc(ptr noundef nonnull %64, i64 noundef %alloc_size.i.i.i.i5.i79.i.i, i64 noundef range(i64 1, -9223372036854775807) 1) #36, !noalias !5005
  %65 = inttoptr i64 %level.sroa.7.1.i.i to ptr
  br label %bb50.i.i

bb6.i.i:                                          ; preds = %bb11.i.i, %bb3.i2.i68.i.preheader.i
  %iter.sroa.0.0619.i.i = phi ptr [ %_138, %bb3.i2.i68.i.preheader.i ], [ %_16.i.i.i.i, %bb11.i.i ]
  %iter.sroa.7.0618.i.i = phi i64 [ 0, %bb3.i2.i68.i.preheader.i ], [ %_9.0.i.i.i, %bb11.i.i ]
  %_16.i.i.i.i = getelementptr inbounds nuw i8, ptr %iter.sroa.0.0619.i.i, i64 8
  %_9.0.i.i.i = add nuw nsw i64 %iter.sroa.7.0618.i.i, 1
  %i16.i.i = load i64, ptr %iter.sroa.0.0619.i.i, align 8, !alias.scope !5005, !noalias !5012, !noundef !566
  %_20.i.i = icmp ult i64 %i16.i.i, %hashers.1
  br i1 %_20.i.i, label %bb8.i.i, label %panic17.i.i

bb35.i.i:                                         ; preds = %bb29.i.i, %bb44.i.i
  %iter5.sroa.7.0659.i.i = phi i64 [ %_9.0.i87.i.i, %bb44.i.i ], [ 0, %bb29.i.i ]
  %iter5.sroa.0.0658.i.i = phi ptr [ %_16.i.i85.i.i, %bb44.i.i ], [ %_138, %bb29.i.i ]
  %_16.i.i85.i.i = getelementptr inbounds nuw i8, ptr %iter5.sroa.0.0658.i.i, i64 8
  %_9.0.i87.i.i = add nuw nsw i64 %iter5.sroa.7.0659.i.i, 1
  %i.i.i = load i64, ptr %iter5.sroa.0.0658.i.i, align 8, !alias.scope !5005, !noalias !5012, !noundef !566
  %_121.i.i = icmp ult i64 %i.i.i, %hashers.1
  br i1 %_121.i.i, label %bb37.i.i, label %panic.invoke.i.i

_RNvNtCs8b9n3vPMt31_13blake3_servil10ffi_output11held_groups.exit.thread.i: ; preds = %bb44.i.i
  %alloc_size.i.i.i.i5.i92.i.i = shl nuw i64 %level.sroa.0.2648.i.i, 5
  call void @llvm.assume(i1 true) [ "nonnull"(ptr %144) ]
; call __rustc::__rust_dealloc
  call void @_RNvCs5fGHjzWXRav_7___rustc14___rust_dealloc(ptr noundef nonnull %144, i64 noundef %alloc_size.i.i.i.i5.i92.i.i, i64 noundef range(i64 1, -9223372036854775807) 1) #36, !noalias !5005
  %alloc_size.i.i.i.i5.i95.i.i = shl nuw i64 %next.sroa.0.1654.i.i, 5
  call void @llvm.assume(i1 true) [ "nonnull"(ptr %145) ]
; call __rustc::__rust_dealloc
  call void @_RNvCs5fGHjzWXRav_7___rustc14___rust_dealloc(ptr noundef nonnull %145, i64 noundef %alloc_size.i.i.i.i5.i95.i.i, i64 noundef range(i64 1, -9223372036854775807) 1) #36, !noalias !5005
  br label %bb46

bb37.i.i:                                         ; preds = %bb35.i.i
  %_119.i.i = getelementptr inbounds nuw [18432 x i8], ptr %hashers.0, i64 %i.i.i
  %66 = getelementptr inbounds nuw i8, ptr %_119.i.i, i64 18368
  %_3.i.i.i = load i64, ptr %66, align 64, !alias.scope !5013, !noalias !5005, !noundef !566
  %67 = icmp eq i64 %_3.i.i.i, 16384
  %68 = getelementptr inbounds nuw i8, ptr %_119.i.i, i64 1936
  %_4.i.i5.i = load i64, ptr %68, align 16, !alias.scope !5013, !noalias !5005
  %_2.i.i.i = icmp eq i64 %_4.i.i5.i, 0
  %or.cond.i.i.i = select i1 %67, i1 %_2.i.i.i, i1 false
  br i1 %or.cond.i.i.i, label %bb96.i.i, label %bb95.i.i

panic.invoke.i.i:                                 ; preds = %bb41.i.i, %bb35.i.i
  %69 = phi i64 [ %i.i.i, %bb35.i.i ], [ %iter5.sroa.7.0659.i.i, %bb41.i.i ]
  %70 = phi i64 [ %hashers.1, %bb35.i.i ], [ %next.sroa.17.0650.i.i, %bb41.i.i ]
  %71 = phi ptr [ @alloc_c5c24ed619da09cd5b468792f8e56fa1, %bb35.i.i ], [ @alloc_1856be1f7989eb1e214f5d4b04ef6691, %bb41.i.i ]
; invoke core::panicking::panic_bounds_check
  invoke void @_RNvNtCskADBYZwJmSU_4core9panicking18panic_bounds_check(i64 noundef %69, i64 noundef %70, ptr noalias nofree noundef nonnull readonly align 8 captures(address, read_provenance) dereferenceable(24) %71) #41
          to label %panic.cont.i.i unwind label %cleanup9.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.i.i, !noalias !5005

panic.cont.i.i:                                   ; preds = %panic.invoke.i.i
  unreachable

unreachable.i.i:                                  ; preds = %bb60.i.i, %bb56.i.i, %panic17.i.i, %bb98.i.i, %bb95.i.i
  unreachable

bb96.i.i:                                         ; preds = %bb37.i.i
  %72 = getelementptr inbounds nuw i8, ptr %_119.i.i, i64 105
  %_15.i.i98.i.i = load i8, ptr %72, align 1, !alias.scope !5016, !noalias !5005, !noundef !566
  %_14.i.i.i.i = zext i8 %_15.i.i98.i.i to i64
  %_13.i.i.i.i = shl nuw nsw i64 %_14.i.i.i.i, 6
  %73 = getelementptr inbounds nuw i8, ptr %_119.i.i, i64 104
  %_17.i.i.i.i = load i8, ptr %73, align 8, !alias.scope !5016, !noalias !5005, !noundef !566
  %_16.i.i99.i.i = zext i8 %_17.i.i.i.i to i64
  %_12.i.i.i.i = add nuw nsw i64 %_13.i.i.i.i, %_16.i.i99.i.i
  %74 = lshr i64 %_12.i.i.i.i, 10
  %75 = getelementptr inbounds nuw i8, ptr %_119.i.i, i64 96
  %_9.i.i.i.i = load i64, ptr %75, align 32, !alias.scope !5016, !noalias !5005, !noundef !566
  %76 = add i64 %74, %_9.i.i.i.i
  %_22.i.i.i.i = and i64 %76, 18014398509481983
  call void @llvm.lifetime.start.p0(ptr nonnull %result.i.i), !noalias !5019
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 1 dereferenceable(64) %result.i.i, i8 0, i64 64, i1 false), !noalias !5019
  %77 = icmp eq i64 %_22.i.i.i.i, 0
  br i1 %77, label %bb39.i.i, label %bb41.i.i

bb95.i.i:                                         ; preds = %bb37.i.i
; invoke core::option::unwrap_failed
  invoke void @_RNvNtCskADBYZwJmSU_4core6option13unwrap_failed(ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(24) @alloc_013618e3c58638fdc47e9a187cf56171) #41
          to label %unreachable.i.i unwind label %cleanup9.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.i.i, !noalias !5005

bb39.i.i:                                         ; preds = %bb96.i.i
  %_128.i.i = shl nuw i64 %iter5.sroa.7.0659.i.i, 1
  %78 = or disjoint i64 %_128.i.i, 1
  %or.cond.not.i.i = icmp ult i64 %78, %level.sroa.18.0645.i.i
  br i1 %or.cond.not.i.i, label %_RINvNtCskADBYZwJmSU_4core5slice20copy_from_slice_implhECs8b9n3vPMt31_13blake3_servil.exit.i.i, label %bb98.i.i, !prof !838

bb41.i.i:                                         ; preds = %bb96.i.i
  %_282.i.i = icmp ult i64 %iter5.sroa.7.0659.i.i, %next.sroa.17.0650.i.i
  br i1 %_282.i.i, label %bb102.i.i, label %panic.invoke.i.i

bb98.i.i:                                         ; preds = %bb39.i.i
  %_129.i.i = add i64 %_128.i.i, 2
; invoke core::slice::index::slice_index_fail
  invoke void @_RNvNtNtCskADBYZwJmSU_4core5slice5index16slice_index_fail(i64 noundef %_128.i.i, i64 noundef %_129.i.i, i64 noundef %level.sroa.18.0645.i.i, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(24) @alloc_32632a7682cc1b282305ccd4efd54e56) #41
          to label %unreachable.i.i unwind label %cleanup9.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.i.i, !noalias !5005

_RINvNtCskADBYZwJmSU_4core5slice20copy_from_slice_implhECs8b9n3vPMt31_13blake3_servil.exit.i.i: ; preds = %bb39.i.i
  %_273.i.i = getelementptr inbounds nuw [32 x i8], ptr %144, i64 %_128.i.i
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(64) %result.i.i, ptr noundef nonnull readonly align 1 dereferenceable(64) %_273.i.i, i64 64, i1 false), !alias.scope !5020, !noalias !5024
  br label %bb1.i102.i.i

bb102.i.i:                                        ; preds = %bb41.i.i
  %_134.i.i = getelementptr inbounds nuw [32 x i8], ptr %145, i64 %iter5.sroa.7.0659.i.i
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(32) %result.i.i, ptr noundef nonnull readonly align 1 dereferenceable(32) %_134.i.i, i64 32, i1 false), !alias.scope !5026, !noalias !5030
  br label %bb1.i102.i.i

bb1.i102.i.i:                                     ; preds = %bb102.i.i, %_RINvNtCskADBYZwJmSU_4core5slice20copy_from_slice_implhECs8b9n3vPMt31_13blake3_servil.exit.i.i
  store i64 0, ptr %66, align 64, !alias.scope !5032, !noalias !5035
; invoke <blake3_servil::incremental::HasherCore>::push_group
  invoke fastcc void @_RNvMs1_NtCs8b9n3vPMt31_13blake3_servil11incrementalNtB5_10HasherCore10push_group(ptr noalias nofree noundef nonnull align 64 dereferenceable(18432) %_119.i.i, ptr noalias nofree noundef nonnull readonly captures(address, read_provenance) dereferenceable(64) %result.i.i)
          to label %bb44.i.i unwind label %cleanup9.loopexit.i.i, !noalias !5005

bb44.i.i:                                         ; preds = %bb1.i102.i.i
  call void @llvm.lifetime.end.p0(ptr nonnull %result.i.i), !noalias !5019
  %_6.i.i83.i.i = icmp eq ptr %_16.i.i85.i.i, %_41.i
  br i1 %_6.i.i83.i.i, label %_RNvNtCs8b9n3vPMt31_13blake3_servil10ffi_output11held_groups.exit.thread.i, label %bb35.i.i

bb67.i.i:                                         ; preds = %bb29.i.i, %bb12.preheader.i.i
  %indvars.iv.i.i = phi i64 [ 0, %bb12.preheader.i.i ], [ %indvars.iv.next.i.i, %bb29.i.i ]
  %next.sroa.0.1654.i.i = phi i64 [ %_41.idx.i, %bb12.preheader.i.i ], [ %level.sroa.0.2648.i.i, %bb29.i.i ]
  %next.sroa.7.1652.i.i = phi i64 [ %60, %bb12.preheader.i.i ], [ %level.sroa.7.2646.i.i, %bb29.i.i ]
  %next.sroa.17.0650.i.i = phi i64 [ %_41.idx.i, %bb12.preheader.i.i ], [ %level.sroa.18.0645.i.i, %bb29.i.i ]
  %level.sroa.0.2648.i.i = phi i64 [ %_7.i.i47, %bb12.preheader.i.i ], [ %next.sroa.0.1654.i.i, %bb29.i.i ]
  %level.sroa.7.2646.i.i = phi i64 [ %54, %bb12.preheader.i.i ], [ %next.sroa.7.1652.i.i, %bb29.i.i ]
  %level.sroa.18.0645.i.i = phi i64 [ %_7.i.i47, %bb12.preheader.i.i ], [ %next.sroa.17.0650.i.i, %bb29.i.i ]
  %indvars.iv.next.i.i = add nuw nsw i64 %indvars.iv.i.i, 1
  %79 = lshr i64 8, %indvars.iv.i.i
  %count.i.i = mul nuw nsw i64 %79, %_137
  %_4533.i.i = lshr i64 %count.i.i, %62
  %80 = mul nuw nsw i64 %_4533.i.i, %width.sroa.0.0.i.i
  %_187.not620.i.i = icmp eq i64 %_4533.i.i, 0
  br i1 %_187.not620.i.i, label %bb69.i.i, label %bb68.lr.ph.i.i

bb68.lr.ph.i.i:                                   ; preds = %bb67.i.i
  %81 = sub nuw nsw i64 3, %indvars.iv.i.i
  %82 = shl i64 %level.sroa.18.0645.i.i, 5
  %83 = inttoptr i64 %level.sroa.7.2646.i.i to ptr
  %84 = inttoptr i64 %next.sroa.7.1652.i.i to ptr
  br i1 %50, label %bb68.us.i.i, label %bb68.i.i

bb68.us.i.i:                                      ; preds = %bb68.lr.ph.i.i, %bb16.us.i.i
  %iter8.sroa.0.0622.us.i.i = phi i64 [ %86, %bb16.us.i.i ], [ %_4533.i.i, %bb68.lr.ph.i.i ]
  %iter7.sroa.0.0621.us.i.i = phi i64 [ %85, %bb16.us.i.i ], [ 0, %bb68.lr.ph.i.i ]
  %85 = add i64 %iter7.sroa.0.0621.us.i.i, %width.sroa.0.0.i.i
  %86 = add nsw i64 %iter8.sroa.0.0622.us.i.i, -1
  call void @llvm.lifetime.start.p0(ptr nonnull %inputs.i.i), !noalias !5019
  call void @llvm.lifetime.start.p0(ptr nonnull %array.i.i.i), !noalias !5037
  call void @llvm.experimental.noalias.scope.decl(metadata !5041)
  br label %bb2.i.i.us.i.i

bb2.i.i.us.i.i:                                   ; preds = %bb4.i.i161.us.i.i, %bb68.us.i.i
  %storemerge15.i.i.us.i.i = phi i64 [ %_22.i.i168.us.i.i, %bb4.i.i161.us.i.i ], [ 0, %bb68.us.i.i ]
  %_4.i.i.i.i.us.i.i = add i64 %storemerge15.i.i.us.i.i, %iter7.sroa.0.0621.us.i.i
  %_5.i.i.i.i.i148450.us.i.i = lshr i64 %_4.i.i.i.i.us.i.i, %81
  %_9.i.i.i.i.i149.us.i.i = icmp ult i64 %_5.i.i.i.i.i148450.us.i.i, %_137
  br i1 %_9.i.i.i.i.i149.us.i.i, label %bb2.i.i.i.i.i151.us.i.i, label %panic2.i.i.i.i.i191.i.i.invoke

bb2.i.i.i.i.i151.us.i.i:                          ; preds = %bb2.i.i.us.i.i
  %87 = getelementptr inbounds nuw [8 x i8], ptr %_138, i64 %_5.i.i.i.i.i148450.us.i.i
  %_4.i.i.i.i.i152.us.i.i = load i64, ptr %87, align 8, !alias.scope !5005, !noalias !5044, !noundef !566
  %_11.i.i.i.i.i153.us.i.i = icmp ult i64 %_4.i.i.i.i.i152.us.i.i, %hashers.1
  br i1 %_11.i.i.i.i.i153.us.i.i, label %bb3.i.i.i.i.i155.us.i.i, label %panic2.i.i.i.i.i191.i.i.invoke

bb3.i.i.i.i.i155.us.i.i:                          ; preds = %bb2.i.i.i.i.i151.us.i.i
  %_16.i.i.i.i.i157.us.i.i = shl i64 %_4.i.i.i.i.us.i.i, 6
  %88 = or disjoint i64 %_16.i.i.i.i.i157.us.i.i, 63
  %or.cond.not.i.i.i.i.i158.us.i.i = icmp ult i64 %88, %82
  br i1 %or.cond.not.i.i.i.i.i158.us.i.i, label %bb4.i.i161.us.i.i, label %bb8.i.i.i.i.i197.i.i.invoke, !prof !838

bb4.i.i161.us.i.i:                                ; preds = %bb3.i.i.i.i.i155.us.i.i
  %_41.i.i.i.i.i163.us.i.i = getelementptr inbounds nuw i8, ptr %83, i64 %_16.i.i.i.i.i157.us.i.i
  %h.i.i.i.i.i164.us.i.i = getelementptr inbounds nuw [18432 x i8], ptr %hashers.0, i64 %_4.i.i.i.i.i152.us.i.i
  %_19.i.i.i.i.i165.us.i.i = getelementptr inbounds nuw i8, ptr %h.i.i.i.i.i164.us.i.i, i64 128
  %89 = getelementptr inbounds nuw i8, ptr %h.i.i.i.i.i164.us.i.i, i64 106
  %_21.i.i.i.i.i166.us.i.i = load i8, ptr %89, align 2, !alias.scope !5012, !noalias !5054, !noundef !566
  %_20.i.i.i.i.i167.us.i.i = or i8 %_21.i.i.i.i.i166.us.i.i, 4
  %self1.i.i.us.i.i = getelementptr inbounds nuw [24 x i8], ptr %array.i.i.i, i64 %storemerge15.i.i.us.i.i
  store ptr %_41.i.i.i.i.i163.us.i.i, ptr %self1.i.i.us.i.i, align 8, !alias.scope !5041, !noalias !5055
  %_28.sroa.4.0.self1.sroa_idx.i.i.us.i.i = getelementptr inbounds nuw i8, ptr %self1.i.i.us.i.i, i64 8
  store ptr %_19.i.i.i.i.i165.us.i.i, ptr %_28.sroa.4.0.self1.sroa_idx.i.i.us.i.i, align 8, !alias.scope !5041, !noalias !5055
  %_28.sroa.5.0.self1.sroa_idx.i.i.us.i.i = getelementptr inbounds nuw i8, ptr %self1.i.i.us.i.i, i64 16
  store i8 64, ptr %_28.sroa.5.0.self1.sroa_idx.i.i.us.i.i, align 8, !alias.scope !5041, !noalias !5055
  %_28.sroa.6.0.self1.sroa_idx.i.i.us.i.i = getelementptr inbounds nuw i8, ptr %self1.i.i.us.i.i, i64 17
  store i8 %_20.i.i.i.i.i167.us.i.i, ptr %_28.sroa.6.0.self1.sroa_idx.i.i.us.i.i, align 1, !alias.scope !5041, !noalias !5055
  %_22.i.i168.us.i.i = add nuw nsw i64 %storemerge15.i.i.us.i.i, 1
  %exitcond.not.i.i169.us.i.i = icmp eq i64 %_22.i.i168.us.i.i, 16
  br i1 %exitcond.not.i.i169.us.i.i, label %bb70.us.i.i, label %bb2.i.i.us.i.i

bb70.us.i.i:                                      ; preds = %bb4.i.i161.us.i.i
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(384) %inputs.i.i, ptr noundef nonnull align 8 dereferenceable(384) %array.i.i.i, i64 384, i1 false), !noalias !5019
  call void @llvm.lifetime.end.p0(ptr nonnull %array.i.i.i), !noalias !5037
  %_63.us.i.i = add i64 %iter7.sroa.0.0621.us.i.i, 16
  %_204.us.i.i = icmp ugt i64 %iter7.sroa.0.0621.us.i.i, -17
  %_200.not.us.i.i = icmp ugt i64 %_63.us.i.i, %next.sroa.17.0650.i.i
  %or.cond41.us.i.i = or i1 %_204.us.i.i, %_200.not.us.i.i
  br i1 %or.cond41.us.i.i, label %bb77.i.i.invoke, label %bb16.us.i.i, !prof !1406

bb16.us.i.i:                                      ; preds = %bb70.us.i.i
  %_207.us.i.i = getelementptr inbounds nuw [32 x i8], ptr %84, i64 %iter7.sroa.0.0621.us.i.i
  call void @blake3_servil_output16(ptr noundef nonnull readonly align 8 dereferenceable(384) %inputs.i.i, ptr noundef nonnull %_207.us.i.i) #36, !noalias !5005
  call void @llvm.lifetime.end.p0(ptr nonnull %inputs.i.i), !noalias !5019
  %_187.not.us.i.i = icmp eq i64 %86, 0
  br i1 %_187.not.us.i.i, label %bb69.i.i, label %bb68.us.i.i

bb69.i.i:                                         ; preds = %bb18.i.i, %bb16.us.i.i, %bb67.i.i
  %_74.i.i = sub nsw i64 %count.i.i, %80
  %_73.i.i = icmp ugt i64 %_74.i.i, 7
  %or.cond39.i.i = and i1 %50, %_73.i.i
  br i1 %or.cond39.i.i, label %.noexc.i.i, label %bb26.i.i

bb68.i.i:                                         ; preds = %bb68.lr.ph.i.i, %bb18.i.i
  %iter8.sroa.0.0622.i.i = phi i64 [ %91, %bb18.i.i ], [ %_4533.i.i, %bb68.lr.ph.i.i ]
  %iter7.sroa.0.0621.i.i = phi i64 [ %90, %bb18.i.i ], [ 0, %bb68.lr.ph.i.i ]
  %90 = add i64 %iter7.sroa.0.0621.i.i, %width.sroa.0.0.i.i
  %91 = add nsw i64 %iter8.sroa.0.0622.i.i, -1
  %_5.i.i.i.i.i184442.i.i = lshr exact i64 %iter7.sroa.0.0621.i.i, %81
  %_9.i.i.i.i.i185.i.i = icmp ult i64 %_5.i.i.i.i.i184442.i.i, %_137
  br i1 %_9.i.i.i.i.i185.i.i, label %bb2.i.i.i.i.i188.i.i, label %panic2.i.i.i.i.i191.i.i.invoke

.noexc.i.i:                                       ; preds = %bb69.i.i
  %92 = load atomic i8, ptr @_RNvNvNtCs8b9n3vPMt31_13blake3_servil8platform12x86_features8FEATURES.0 monotonic, align 1, !noalias !5019
  %93 = icmp eq i8 %92, 0
  br i1 %93, label %bb2.i.i.i, label %bb80.i.i, !prof !575

bb2.i.i.i:                                        ; preds = %.noexc.i.i
; call blake3_servil::platform::read_x86_features
  %94 = call fastcc noundef i8 @_RNvNtCs8b9n3vPMt31_13blake3_servil8platform17read_x86_features(), !noalias !5005
  store atomic i8 %94, ptr @_RNvNvNtCs8b9n3vPMt31_13blake3_servil8platform12x86_features8FEATURES.0 monotonic, align 1, !noalias !5019
  br label %bb80.i.i

bb26.i.i:                                         ; preds = %bb80.i.i, %bb69.i.i
  %95 = inttoptr i64 %next.sroa.7.1652.i.i to ptr
  %_246.idx.i.i = shl nuw nsw i64 %next.sroa.17.0650.i.i, 5
  %_246.i.i = getelementptr inbounds nuw i8, ptr %95, i64 %_246.idx.i.i
  %96 = sub nuw nsw i64 3, %indvars.iv.i.i
  %97 = shl i64 %level.sroa.18.0645.i.i, 5
  %98 = inttoptr i64 %level.sroa.7.2646.i.i to ptr
  br i1 %_187.not620.i.i, label %bb86.peel.i.i, label %bb88.peel.i.i, !prof !5056

bb88.peel.i.i:                                    ; preds = %bb26.thread.i.i, %bb26.i.i
  %99 = phi ptr [ %119, %bb26.thread.i.i ], [ %98, %bb26.i.i ]
  %100 = phi i64 [ %117, %bb26.thread.i.i ], [ %97, %bb26.i.i ]
  %101 = phi i64 [ %115, %bb26.thread.i.i ], [ %96, %bb26.i.i ]
  %_246871.i.i = phi ptr [ %_246869.i.i, %bb26.thread.i.i ], [ %_246.i.i, %bb26.i.i ]
  %102 = phi ptr [ %142, %bb26.thread.i.i ], [ %95, %bb26.i.i ]
  %103 = phi i64 [ %_85.i.i, %bb26.thread.i.i ], [ %80, %bb26.i.i ]
  %_3.i110.peel.i.i = icmp ugt i64 %count.i.i, %103
  br i1 %_3.i110.peel.i.i, label %bb1.i113.peel.i.i, label %bb4.i.peel.i.i

bb4.i.peel.i.i:                                   ; preds = %bb88.peel.i.i
  call void @llvm.assume(i1 true) [ "nonnull"(ptr %102) ]
  br label %bb29.i.i

bb1.i113.peel.i.i:                                ; preds = %bb88.peel.i.i
  %104 = ptrtoint ptr %_246871.i.i to i64
  call void @llvm.assume(i1 true) [ "nonnull"(ptr %102) ]
  %105 = sub nuw i64 %104, %next.sroa.7.1652.i.i
  %106 = lshr exact i64 %105, 5
  %_3.not.i.not.i.i.peel.i.i = icmp ult i64 %103, %106
  br i1 %_3.not.i.not.i.i.peel.i.i, label %bb86.peel.thread883.i.i, label %bb29.i.i

bb86.peel.thread883.i.i:                          ; preds = %bb1.i113.peel.i.i
  %_5.neg.i.peel.i.i = xor i64 %103, -1
  %_34.i.i.i.peel.i.i = getelementptr inbounds nuw [32 x i8], ptr %102, i64 %103
  %_12.0.i.i.peel.i.i = add nuw nsw i64 %103, 1
  br label %bb1.i126.peel.i.i

bb86.peel.i.i:                                    ; preds = %bb26.i.i
  call void @llvm.assume(i1 true) [ "nonnull"(ptr %95) ]
  %.not35.peel.i.i = icmp eq i64 %next.sroa.7.1652.i.i, 0
  br i1 %.not35.peel.i.i, label %bb29.i.i, label %bb1.i126.peel.i.i

bb1.i126.peel.i.i:                                ; preds = %bb86.peel.i.i, %bb86.peel.thread883.i.i
  %_0.sroa.2.0.i122.pn.peel896.i.i = phi ptr [ %_34.i.i.i.peel.i.i, %bb86.peel.thread883.i.i ], [ %95, %bb86.peel.i.i ]
  %_0.sroa.0.0.i123.pn.peel895.i.i = phi i64 [ %103, %bb86.peel.thread883.i.i ], [ 0, %bb86.peel.i.i ]
  %_5.neg.i.peel.pn.i.i = phi i64 [ %_5.neg.i.peel.i.i, %bb86.peel.thread883.i.i ], [ -1, %bb86.peel.i.i ]
  %iter3.sroa.13.1.peel893.i.i = phi i64 [ %_12.0.i.i.peel.i.i, %bb86.peel.thread883.i.i ], [ 1, %bb86.peel.i.i ]
  %107 = phi ptr [ %102, %bb86.peel.thread883.i.i ], [ %95, %bb86.peel.i.i ]
  %_246872891.i.i = phi ptr [ %_246871.i.i, %bb86.peel.thread883.i.i ], [ %_246.i.i, %bb86.peel.i.i ]
  %108 = phi i64 [ %101, %bb86.peel.thread883.i.i ], [ %96, %bb86.peel.i.i ]
  %109 = phi i64 [ %100, %bb86.peel.thread883.i.i ], [ %97, %bb86.peel.i.i ]
  %110 = phi ptr [ %99, %bb86.peel.thread883.i.i ], [ %98, %bb86.peel.i.i ]
  %iter3.sroa.20.1.peel894.i.i = add nsw i64 %_5.neg.i.peel.pn.i.i, %count.i.i
  %_5.i461.peel.i.i = lshr i64 %_0.sroa.0.0.i123.pn.peel895.i.i, %108
  %_9.i.peel.i.i = icmp ult i64 %_5.i461.peel.i.i, %_137
  br i1 %_9.i.peel.i.i, label %bb2.i127.peel.i.i, label %panic2.i.i.i.i.i191.i.i.invoke

bb2.i127.peel.i.i:                                ; preds = %bb1.i126.peel.i.i
  %111 = getelementptr inbounds nuw [8 x i8], ptr %_138, i64 %_5.i461.peel.i.i
  %_4.i128.peel.i.i = load i64, ptr %111, align 8, !alias.scope !5005, !noalias !5057, !noundef !566
  %_11.i129.peel.i.i = icmp ult i64 %_4.i128.peel.i.i, %hashers.1
  br i1 %_11.i129.peel.i.i, label %bb3.i130.peel.i.i, label %panic2.i.i.i.i.i191.i.i.invoke

bb3.i130.peel.i.i:                                ; preds = %bb2.i127.peel.i.i
  %_16.i.peel.i.i = shl nuw i64 %_0.sroa.0.0.i123.pn.peel895.i.i, 6
  %112 = or disjoint i64 %_16.i.peel.i.i, 63
  %or.cond.not.i.peel.i.i = icmp ult i64 %112, %109
  br i1 %or.cond.not.i.peel.i.i, label %bb30.peel.i.i, label %bb8.i.i.i.i.i197.i.i.invoke, !prof !838

bb30.peel.i.i:                                    ; preds = %bb3.i130.peel.i.i
  %_41.i.peel.i.i = getelementptr inbounds nuw i8, ptr %110, i64 %_16.i.peel.i.i
  %h.i.peel.i.i = getelementptr inbounds nuw [18432 x i8], ptr %hashers.0, i64 %_4.i128.peel.i.i
  %_19.i.peel.i.i = getelementptr inbounds nuw i8, ptr %h.i.peel.i.i, i64 128
  %113 = getelementptr inbounds nuw i8, ptr %h.i.peel.i.i, i64 106
  %_21.i.peel.i.i = load i8, ptr %113, align 2, !alias.scope !5012, !noalias !5061, !noundef !566
  %_20.i.peel.i.i = or i8 %_21.i.peel.i.i, 4
  call void @llvm.lifetime.start.p0(ptr nonnull %cv.i.i), !noalias !5019
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 4 dereferenceable(32) %cv.i.i, ptr noundef nonnull align 64 dereferenceable(32) %_19.i.peel.i.i, i64 32, i1 false), !noalias !5005
  br i1 %63, label %bb2.i139.peel.i.i, label %bb3.i137.peel.i.i

bb3.i137.peel.i.i:                                ; preds = %bb30.peel.i.i
  call void @blake3_servil_compress_in_place_sse41(ptr noundef nonnull align 4 dereferenceable(32) %cv.i.i, ptr noundef nonnull readonly dereferenceable(64) %_41.i.peel.i.i, i8 noundef zeroext 64, i64 noundef 0, i8 noundef zeroext %_20.i.peel.i.i) #36, !noalias !5062
  br label %bb32.peel.i.i

bb2.i139.peel.i.i:                                ; preds = %bb30.peel.i.i
  call void @blake3_servil_compress_in_place_avx512(ptr noundef nonnull align 4 dereferenceable(32) %cv.i.i, ptr noundef nonnull readonly dereferenceable(64) %_41.i.peel.i.i, i8 noundef zeroext 64, i64 noundef 0, i8 noundef zeroext %_20.i.peel.i.i) #36, !noalias !5062
  br label %bb32.peel.i.i

bb32.peel.i.i:                                    ; preds = %bb2.i139.peel.i.i, %bb3.i137.peel.i.i
  call void @llvm.memmove.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(32) %_0.sroa.2.0.i122.pn.peel896.i.i, ptr noundef nonnull align 4 dereferenceable(32) %cv.i.i, i64 32, i1 false), !noalias !5005
  call void @llvm.lifetime.end.p0(ptr nonnull %cv.i.i), !noalias !5019
  %114 = icmp eq i64 %iter3.sroa.20.1.peel894.i.i, 0
  br i1 %114, label %bb29.i.i, label %bb91.i.i

bb80.i.i:                                         ; preds = %bb2.i.i.i, %.noexc.i.i
  %features.sroa.0.0.i.i.i = phi i8 [ %94, %bb2.i.i.i ], [ %92, %.noexc.i.i ]
  %_223.i6.i = and i8 %features.sroa.0.0.i.i.i, 4
  %_76.not.i.i = icmp eq i8 %_223.i6.i, 0
  br i1 %_76.not.i.i, label %bb26.i.i, label %bb23.i.i

bb23.i.i:                                         ; preds = %bb80.i.i
  call void @llvm.lifetime.start.p0(ptr nonnull %inputs2.i.i), !noalias !5019
  %115 = sub nuw nsw i64 3, %indvars.iv.i.i
  %_5.i.i.i.i.i451.i.i = lshr exact i64 %80, %115
  %_9.i.i.i.i.i.i.i = icmp samesign ult i64 %_5.i.i.i.i.i451.i.i, %_137
  br i1 %_9.i.i.i.i.i.i.i, label %bb2.i.i.i.i.i.i.i, label %panic2.i.i.i.i.i191.i.i.invoke

bb2.i.i.i.i.i.i.i:                                ; preds = %bb23.i.i
  %116 = getelementptr inbounds nuw [8 x i8], ptr %_138, i64 %_5.i.i.i.i.i451.i.i
  %_4.i.i.i.i.i.i.i = load i64, ptr %116, align 8, !alias.scope !5005, !noalias !5065, !noundef !566
  %_11.i.i.i.i.i.i.i = icmp ult i64 %_4.i.i.i.i.i.i.i, %hashers.1
  br i1 %_11.i.i.i.i.i.i.i, label %bb3.i.i.i.i.i.i.i, label %panic2.i.i.i.i.i191.i.i.invoke

bb3.i.i.i.i.i.i.i:                                ; preds = %bb2.i.i.i.i.i.i.i
  %117 = shl i64 %level.sroa.18.0645.i.i, 5
  %_16.i.i.i.i.i.i.i = shl i64 %80, 6
  %118 = or disjoint i64 %_16.i.i.i.i.i.i.i, 63
  %or.cond.not.i.i.i.i.i.i.i = icmp ult i64 %118, %117
  br i1 %or.cond.not.i.i.i.i.i.i.i, label %bb4.i.i.i.i, label %bb8.i.i.i.i.i197.i.i.invoke, !prof !838

bb4.i.i.i.i:                                      ; preds = %bb3.i.i.i.i.i.i.i
  %119 = inttoptr i64 %level.sroa.7.2646.i.i to ptr
  %h.i.i.i.i.i.i.i = getelementptr inbounds nuw [18432 x i8], ptr %hashers.0, i64 %_4.i.i.i.i.i.i.i
  %120 = getelementptr inbounds nuw i8, ptr %h.i.i.i.i.i.i.i, i64 106
  %_21.i.i.i.i.i.i.i = load i8, ptr %120, align 2, !alias.scope !5012, !noalias !5080, !noundef !566
  %_4.i.i.1.i.i.i.i = or disjoint i64 %80, 1
  %_5.i.i.i.1.i.i452.i.i = lshr i64 %_4.i.i.1.i.i.i.i, %115
  %_9.i.i.i.1.i.i.i.i = icmp samesign ult i64 %_5.i.i.i.1.i.i452.i.i, %_137
  br i1 %_9.i.i.i.1.i.i.i.i, label %bb2.i.i.i.1.i.i.i.i, label %panic2.i.i.i.i.i191.i.i.invoke

bb2.i.i.i.1.i.i.i.i:                              ; preds = %bb4.i.i.i.i
  %121 = getelementptr inbounds nuw [8 x i8], ptr %_138, i64 %_5.i.i.i.1.i.i452.i.i
  %_4.i.i.i.1.i.i.i.i = load i64, ptr %121, align 8, !alias.scope !5005, !noalias !5081, !noundef !566
  %_11.i.i.i.1.i.i.i.i = icmp ult i64 %_4.i.i.i.1.i.i.i.i, %hashers.1
  br i1 %_11.i.i.i.1.i.i.i.i, label %bb3.i.i.i.1.i.i.i.i, label %panic2.i.i.i.i.i191.i.i.invoke

bb3.i.i.i.1.i.i.i.i:                              ; preds = %bb2.i.i.i.1.i.i.i.i
  %_16.i.i.i.1.i.i.i.i = shl i64 %_4.i.i.1.i.i.i.i, 6
  %122 = or disjoint i64 %_16.i.i.i.1.i.i.i.i, 63
  %or.cond.not.i.i.i.1.i.i.i.i = icmp ult i64 %122, %117
  br i1 %or.cond.not.i.i.i.1.i.i.i.i, label %bb4.1.i.i.i.i, label %bb8.i.i.i.i.i197.i.i.invoke, !prof !838

bb4.1.i.i.i.i:                                    ; preds = %bb3.i.i.i.1.i.i.i.i
  %h.i.i.i.1.i.i.i.i = getelementptr inbounds nuw [18432 x i8], ptr %hashers.0, i64 %_4.i.i.i.1.i.i.i.i
  %123 = getelementptr inbounds nuw i8, ptr %h.i.i.i.1.i.i.i.i, i64 106
  %_21.i.i.i.1.i.i.i.i = load i8, ptr %123, align 2, !alias.scope !5012, !noalias !5083, !noundef !566
  %_4.i.i.2.i.i.i.i = or disjoint i64 %80, 2
  %_5.i.i.i.2.i.i453.i.i = lshr i64 %_4.i.i.2.i.i.i.i, %115
  %_9.i.i.i.2.i.i.i.i = icmp samesign ult i64 %_5.i.i.i.2.i.i453.i.i, %_137
  br i1 %_9.i.i.i.2.i.i.i.i, label %bb2.i.i.i.2.i.i.i.i, label %panic2.i.i.i.i.i191.i.i.invoke

bb2.i.i.i.2.i.i.i.i:                              ; preds = %bb4.1.i.i.i.i
  %124 = getelementptr inbounds nuw [8 x i8], ptr %_138, i64 %_5.i.i.i.2.i.i453.i.i
  %_4.i.i.i.2.i.i.i.i = load i64, ptr %124, align 8, !alias.scope !5005, !noalias !5084, !noundef !566
  %_11.i.i.i.2.i.i.i.i = icmp ult i64 %_4.i.i.i.2.i.i.i.i, %hashers.1
  br i1 %_11.i.i.i.2.i.i.i.i, label %bb3.i.i.i.2.i.i.i.i, label %panic2.i.i.i.i.i191.i.i.invoke

bb3.i.i.i.2.i.i.i.i:                              ; preds = %bb2.i.i.i.2.i.i.i.i
  %_16.i.i.i.2.i.i.i.i = shl i64 %_4.i.i.2.i.i.i.i, 6
  %125 = or disjoint i64 %_16.i.i.i.2.i.i.i.i, 63
  %or.cond.not.i.i.i.2.i.i.i.i = icmp ult i64 %125, %117
  br i1 %or.cond.not.i.i.i.2.i.i.i.i, label %bb4.2.i.i.i.i, label %bb8.i.i.i.i.i197.i.i.invoke, !prof !838

bb4.2.i.i.i.i:                                    ; preds = %bb3.i.i.i.2.i.i.i.i
  %h.i.i.i.2.i.i.i.i = getelementptr inbounds nuw [18432 x i8], ptr %hashers.0, i64 %_4.i.i.i.2.i.i.i.i
  %126 = getelementptr inbounds nuw i8, ptr %h.i.i.i.2.i.i.i.i, i64 106
  %_21.i.i.i.2.i.i.i.i = load i8, ptr %126, align 2, !alias.scope !5012, !noalias !5086, !noundef !566
  %_4.i.i.3.i.i.i.i = or disjoint i64 %80, 3
  %_5.i.i.i.3.i.i454.i.i = lshr i64 %_4.i.i.3.i.i.i.i, %115
  %_9.i.i.i.3.i.i.i.i = icmp samesign ult i64 %_5.i.i.i.3.i.i454.i.i, %_137
  br i1 %_9.i.i.i.3.i.i.i.i, label %bb2.i.i.i.3.i.i.i.i, label %panic2.i.i.i.i.i191.i.i.invoke

bb2.i.i.i.3.i.i.i.i:                              ; preds = %bb4.2.i.i.i.i
  %127 = getelementptr inbounds nuw [8 x i8], ptr %_138, i64 %_5.i.i.i.3.i.i454.i.i
  %_4.i.i.i.3.i.i.i.i = load i64, ptr %127, align 8, !alias.scope !5005, !noalias !5087, !noundef !566
  %_11.i.i.i.3.i.i.i.i = icmp ult i64 %_4.i.i.i.3.i.i.i.i, %hashers.1
  br i1 %_11.i.i.i.3.i.i.i.i, label %bb3.i.i.i.3.i.i.i.i, label %panic2.i.i.i.i.i191.i.i.invoke

bb3.i.i.i.3.i.i.i.i:                              ; preds = %bb2.i.i.i.3.i.i.i.i
  %_16.i.i.i.3.i.i.i.i = shl i64 %_4.i.i.3.i.i.i.i, 6
  %128 = or disjoint i64 %_16.i.i.i.3.i.i.i.i, 63
  %or.cond.not.i.i.i.3.i.i.i.i = icmp ult i64 %128, %117
  br i1 %or.cond.not.i.i.i.3.i.i.i.i, label %bb4.3.i.i.i.i, label %bb8.i.i.i.i.i197.i.i.invoke, !prof !838

bb4.3.i.i.i.i:                                    ; preds = %bb3.i.i.i.3.i.i.i.i
  %h.i.i.i.3.i.i.i.i = getelementptr inbounds nuw [18432 x i8], ptr %hashers.0, i64 %_4.i.i.i.3.i.i.i.i
  %129 = getelementptr inbounds nuw i8, ptr %h.i.i.i.3.i.i.i.i, i64 106
  %_21.i.i.i.3.i.i.i.i = load i8, ptr %129, align 2, !alias.scope !5012, !noalias !5089, !noundef !566
  %_4.i.i.4.i.i.i.i = or disjoint i64 %80, 4
  %_5.i.i.i.4.i.i455.i.i = lshr i64 %_4.i.i.4.i.i.i.i, %115
  %_9.i.i.i.4.i.i.i.i = icmp samesign ult i64 %_5.i.i.i.4.i.i455.i.i, %_137
  br i1 %_9.i.i.i.4.i.i.i.i, label %bb2.i.i.i.4.i.i.i.i, label %panic2.i.i.i.i.i191.i.i.invoke

bb2.i.i.i.4.i.i.i.i:                              ; preds = %bb4.3.i.i.i.i
  %130 = getelementptr inbounds nuw [8 x i8], ptr %_138, i64 %_5.i.i.i.4.i.i455.i.i
  %_4.i.i.i.4.i.i.i.i = load i64, ptr %130, align 8, !alias.scope !5005, !noalias !5090, !noundef !566
  %_11.i.i.i.4.i.i.i.i = icmp ult i64 %_4.i.i.i.4.i.i.i.i, %hashers.1
  br i1 %_11.i.i.i.4.i.i.i.i, label %bb3.i.i.i.4.i.i.i.i, label %panic2.i.i.i.i.i191.i.i.invoke

bb3.i.i.i.4.i.i.i.i:                              ; preds = %bb2.i.i.i.4.i.i.i.i
  %_16.i.i.i.4.i.i.i.i = shl i64 %_4.i.i.4.i.i.i.i, 6
  %131 = or disjoint i64 %_16.i.i.i.4.i.i.i.i, 63
  %or.cond.not.i.i.i.4.i.i.i.i = icmp ult i64 %131, %117
  br i1 %or.cond.not.i.i.i.4.i.i.i.i, label %bb4.4.i.i.i.i, label %bb8.i.i.i.i.i197.i.i.invoke, !prof !838

bb4.4.i.i.i.i:                                    ; preds = %bb3.i.i.i.4.i.i.i.i
  %h.i.i.i.4.i.i.i.i = getelementptr inbounds nuw [18432 x i8], ptr %hashers.0, i64 %_4.i.i.i.4.i.i.i.i
  %132 = getelementptr inbounds nuw i8, ptr %h.i.i.i.4.i.i.i.i, i64 106
  %_21.i.i.i.4.i.i.i.i = load i8, ptr %132, align 2, !alias.scope !5012, !noalias !5092, !noundef !566
  %_4.i.i.5.i.i.i.i = or disjoint i64 %80, 5
  %_5.i.i.i.5.i.i456.i.i = lshr i64 %_4.i.i.5.i.i.i.i, %115
  %_9.i.i.i.5.i.i.i.i = icmp samesign ult i64 %_5.i.i.i.5.i.i456.i.i, %_137
  br i1 %_9.i.i.i.5.i.i.i.i, label %bb2.i.i.i.5.i.i.i.i, label %panic2.i.i.i.i.i191.i.i.invoke

bb2.i.i.i.5.i.i.i.i:                              ; preds = %bb4.4.i.i.i.i
  %133 = getelementptr inbounds nuw [8 x i8], ptr %_138, i64 %_5.i.i.i.5.i.i456.i.i
  %_4.i.i.i.5.i.i.i.i = load i64, ptr %133, align 8, !alias.scope !5005, !noalias !5093, !noundef !566
  %_11.i.i.i.5.i.i.i.i = icmp ult i64 %_4.i.i.i.5.i.i.i.i, %hashers.1
  br i1 %_11.i.i.i.5.i.i.i.i, label %bb3.i.i.i.5.i.i.i.i, label %panic2.i.i.i.i.i191.i.i.invoke

bb3.i.i.i.5.i.i.i.i:                              ; preds = %bb2.i.i.i.5.i.i.i.i
  %_16.i.i.i.5.i.i.i.i = shl i64 %_4.i.i.5.i.i.i.i, 6
  %134 = or disjoint i64 %_16.i.i.i.5.i.i.i.i, 63
  %or.cond.not.i.i.i.5.i.i.i.i = icmp ult i64 %134, %117
  br i1 %or.cond.not.i.i.i.5.i.i.i.i, label %bb4.5.i.i.i.i, label %bb8.i.i.i.i.i197.i.i.invoke, !prof !838

bb4.5.i.i.i.i:                                    ; preds = %bb3.i.i.i.5.i.i.i.i
  %h.i.i.i.5.i.i.i.i = getelementptr inbounds nuw [18432 x i8], ptr %hashers.0, i64 %_4.i.i.i.5.i.i.i.i
  %135 = getelementptr inbounds nuw i8, ptr %h.i.i.i.5.i.i.i.i, i64 106
  %_21.i.i.i.5.i.i.i.i = load i8, ptr %135, align 2, !alias.scope !5012, !noalias !5095, !noundef !566
  %_4.i.i.6.i.i.i.i = or disjoint i64 %80, 6
  %_5.i.i.i.6.i.i457.i.i = lshr i64 %_4.i.i.6.i.i.i.i, %115
  %_9.i.i.i.6.i.i.i.i = icmp samesign ult i64 %_5.i.i.i.6.i.i457.i.i, %_137
  br i1 %_9.i.i.i.6.i.i.i.i, label %bb2.i.i.i.6.i.i.i.i, label %panic2.i.i.i.i.i191.i.i.invoke

bb2.i.i.i.6.i.i.i.i:                              ; preds = %bb4.5.i.i.i.i
  %136 = getelementptr inbounds nuw [8 x i8], ptr %_138, i64 %_5.i.i.i.6.i.i457.i.i
  %_4.i.i.i.6.i.i.i.i = load i64, ptr %136, align 8, !alias.scope !5005, !noalias !5096, !noundef !566
  %_11.i.i.i.6.i.i.i.i = icmp ult i64 %_4.i.i.i.6.i.i.i.i, %hashers.1
  br i1 %_11.i.i.i.6.i.i.i.i, label %bb3.i.i.i.6.i.i.i.i, label %panic2.i.i.i.i.i191.i.i.invoke

bb3.i.i.i.6.i.i.i.i:                              ; preds = %bb2.i.i.i.6.i.i.i.i
  %_16.i.i.i.6.i.i.i.i = shl i64 %_4.i.i.6.i.i.i.i, 6
  %137 = or disjoint i64 %_16.i.i.i.6.i.i.i.i, 63
  %or.cond.not.i.i.i.6.i.i.i.i = icmp ult i64 %137, %117
  br i1 %or.cond.not.i.i.i.6.i.i.i.i, label %bb4.6.i.i.i.i, label %bb8.i.i.i.i.i197.i.i.invoke, !prof !838

bb4.6.i.i.i.i:                                    ; preds = %bb3.i.i.i.6.i.i.i.i
  %h.i.i.i.6.i.i.i.i = getelementptr inbounds nuw [18432 x i8], ptr %hashers.0, i64 %_4.i.i.i.6.i.i.i.i
  %138 = getelementptr inbounds nuw i8, ptr %h.i.i.i.6.i.i.i.i, i64 106
  %_21.i.i.i.6.i.i.i.i = load i8, ptr %138, align 2, !alias.scope !5012, !noalias !5098, !noundef !566
  %_4.i.i.7.i.i.i.i = or disjoint i64 %80, 7
  %_5.i.i.i.7.i.i458.i.i = lshr i64 %_4.i.i.7.i.i.i.i, %115
  %_9.i.i.i.7.i.i.i.i = icmp samesign ult i64 %_5.i.i.i.7.i.i458.i.i, %_137
  br i1 %_9.i.i.i.7.i.i.i.i, label %bb2.i.i.i.7.i.i.i.i, label %panic2.i.i.i.i.i191.i.i.invoke

bb2.i.i.i.7.i.i.i.i:                              ; preds = %bb4.6.i.i.i.i
  %139 = getelementptr inbounds nuw [8 x i8], ptr %_138, i64 %_5.i.i.i.7.i.i458.i.i
  %_4.i.i.i.7.i.i.i.i = load i64, ptr %139, align 8, !alias.scope !5005, !noalias !5099, !noundef !566
  %_11.i.i.i.7.i.i.i.i = icmp ult i64 %_4.i.i.i.7.i.i.i.i, %hashers.1
  br i1 %_11.i.i.i.7.i.i.i.i, label %bb3.i.i.i.7.i.i.i.i, label %panic2.i.i.i.i.i191.i.i.invoke

bb3.i.i.i.7.i.i.i.i:                              ; preds = %bb2.i.i.i.7.i.i.i.i
  %_16.i.i.i.7.i.i.i.i = shl i64 %_4.i.i.7.i.i.i.i, 6
  %140 = or disjoint i64 %_16.i.i.i.7.i.i.i.i, 63
  %or.cond.not.i.i.i.7.i.i.i.i = icmp ult i64 %140, %117
  br i1 %or.cond.not.i.i.i.7.i.i.i.i, label %bb81.i.i, label %bb8.i.i.i.i.i197.i.i.invoke, !prof !838

bb81.i.i:                                         ; preds = %bb3.i.i.i.7.i.i.i.i
  %_20.i.i.i.6.i.i.i.i = or i8 %_21.i.i.i.6.i.i.i.i, 4
  %_19.i.i.i.6.i.i.i.i = getelementptr inbounds nuw i8, ptr %h.i.i.i.6.i.i.i.i, i64 128
  %_41.i.i.i.6.i.i.i.i = getelementptr inbounds nuw i8, ptr %119, i64 %_16.i.i.i.6.i.i.i.i
  %_20.i.i.i.5.i.i.i.i = or i8 %_21.i.i.i.5.i.i.i.i, 4
  %_19.i.i.i.5.i.i.i.i = getelementptr inbounds nuw i8, ptr %h.i.i.i.5.i.i.i.i, i64 128
  %_41.i.i.i.5.i.i.i.i = getelementptr inbounds nuw i8, ptr %119, i64 %_16.i.i.i.5.i.i.i.i
  %_20.i.i.i.4.i.i.i.i = or i8 %_21.i.i.i.4.i.i.i.i, 4
  %_19.i.i.i.4.i.i.i.i = getelementptr inbounds nuw i8, ptr %h.i.i.i.4.i.i.i.i, i64 128
  %_41.i.i.i.4.i.i.i.i = getelementptr inbounds nuw i8, ptr %119, i64 %_16.i.i.i.4.i.i.i.i
  %_20.i.i.i.3.i.i.i.i = or i8 %_21.i.i.i.3.i.i.i.i, 4
  %_19.i.i.i.3.i.i.i.i = getelementptr inbounds nuw i8, ptr %h.i.i.i.3.i.i.i.i, i64 128
  %_41.i.i.i.3.i.i.i.i = getelementptr inbounds nuw i8, ptr %119, i64 %_16.i.i.i.3.i.i.i.i
  %_20.i.i.i.2.i.i.i.i = or i8 %_21.i.i.i.2.i.i.i.i, 4
  %_19.i.i.i.2.i.i.i.i = getelementptr inbounds nuw i8, ptr %h.i.i.i.2.i.i.i.i, i64 128
  %_41.i.i.i.2.i.i.i.i = getelementptr inbounds nuw i8, ptr %119, i64 %_16.i.i.i.2.i.i.i.i
  %_20.i.i.i.1.i.i.i.i = or i8 %_21.i.i.i.1.i.i.i.i, 4
  %_19.i.i.i.1.i.i.i.i = getelementptr inbounds nuw i8, ptr %h.i.i.i.1.i.i.i.i, i64 128
  %_41.i.i.i.1.i.i.i.i = getelementptr inbounds nuw i8, ptr %119, i64 %_16.i.i.i.1.i.i.i.i
  %_20.i.i.i.i.i.i.i = or i8 %_21.i.i.i.i.i.i.i, 4
  %_19.i.i.i.i.i.i.i = getelementptr inbounds nuw i8, ptr %h.i.i.i.i.i.i.i, i64 128
  %_41.i.i.i.i.i.i.i = getelementptr inbounds nuw i8, ptr %119, i64 %_16.i.i.i.i.i.i.i
  %_41.i.i.i.7.i.i.i.i = getelementptr inbounds nuw i8, ptr %119, i64 %_16.i.i.i.7.i.i.i.i
  %h.i.i.i.7.i.i.i.i = getelementptr inbounds nuw [18432 x i8], ptr %hashers.0, i64 %_4.i.i.i.7.i.i.i.i
  %_19.i.i.i.7.i.i.i.i = getelementptr inbounds nuw i8, ptr %h.i.i.i.7.i.i.i.i, i64 128
  %141 = getelementptr inbounds nuw i8, ptr %h.i.i.i.7.i.i.i.i, i64 106
  %_21.i.i.i.7.i.i.i.i = load i8, ptr %141, align 2, !alias.scope !5012, !noalias !5101, !noundef !566
  %_20.i.i.i.7.i.i.i.i = or i8 %_21.i.i.i.7.i.i.i.i, 4
  store ptr %_41.i.i.i.i.i.i.i, ptr %inputs2.i.i, align 8, !noalias !5019
  store ptr %_19.i.i.i.i.i.i.i, ptr %_225.sroa.4.0.inputs2.sroa_idx.i.i, align 8, !noalias !5019
  store i8 64, ptr %_225.sroa.5.0.inputs2.sroa_idx.i.i, align 8, !noalias !5019
  store i8 %_20.i.i.i.i.i.i.i, ptr %_225.sroa.6.0.inputs2.sroa_idx.i.i, align 1, !noalias !5019
  store ptr %_41.i.i.i.1.i.i.i.i, ptr %_225.sroa.7407.0.inputs2.sroa_idx.i.i, align 8, !noalias !5019
  store ptr %_19.i.i.i.1.i.i.i.i, ptr %_225.sroa.8.0.inputs2.sroa_idx.i.i, align 8, !noalias !5019
  store i8 64, ptr %_225.sroa.9.0.inputs2.sroa_idx.i.i, align 8, !noalias !5019
  store i8 %_20.i.i.i.1.i.i.i.i, ptr %_225.sroa.10.0.inputs2.sroa_idx.i.i, align 1, !noalias !5019
  store ptr %_41.i.i.i.2.i.i.i.i, ptr %_225.sroa.11408.0.inputs2.sroa_idx.i.i, align 8, !noalias !5019
  store ptr %_19.i.i.i.2.i.i.i.i, ptr %_225.sroa.12.0.inputs2.sroa_idx.i.i, align 8, !noalias !5019
  store i8 64, ptr %_225.sroa.13.0.inputs2.sroa_idx.i.i, align 8, !noalias !5019
  store i8 %_20.i.i.i.2.i.i.i.i, ptr %_225.sroa.14.0.inputs2.sroa_idx.i.i, align 1, !noalias !5019
  store ptr %_41.i.i.i.3.i.i.i.i, ptr %_225.sroa.15409.0.inputs2.sroa_idx.i.i, align 8, !noalias !5019
  store ptr %_19.i.i.i.3.i.i.i.i, ptr %_225.sroa.16.0.inputs2.sroa_idx.i.i, align 8, !noalias !5019
  store i8 64, ptr %_225.sroa.17.0.inputs2.sroa_idx.i.i, align 8, !noalias !5019
  store i8 %_20.i.i.i.3.i.i.i.i, ptr %_225.sroa.18.0.inputs2.sroa_idx.i.i, align 1, !noalias !5019
  store ptr %_41.i.i.i.4.i.i.i.i, ptr %_225.sroa.19410.0.inputs2.sroa_idx.i.i, align 8, !noalias !5019
  store ptr %_19.i.i.i.4.i.i.i.i, ptr %_225.sroa.20.0.inputs2.sroa_idx.i.i, align 8, !noalias !5019
  store i8 64, ptr %_225.sroa.21.0.inputs2.sroa_idx.i.i, align 8, !noalias !5019
  store i8 %_20.i.i.i.4.i.i.i.i, ptr %_225.sroa.22.0.inputs2.sroa_idx.i.i, align 1, !noalias !5019
  store ptr %_41.i.i.i.5.i.i.i.i, ptr %_225.sroa.23411.0.inputs2.sroa_idx.i.i, align 8, !noalias !5019
  store ptr %_19.i.i.i.5.i.i.i.i, ptr %_225.sroa.24.0.inputs2.sroa_idx.i.i, align 8, !noalias !5019
  store i8 64, ptr %_225.sroa.25.0.inputs2.sroa_idx.i.i, align 8, !noalias !5019
  store i8 %_20.i.i.i.5.i.i.i.i, ptr %_225.sroa.26.0.inputs2.sroa_idx.i.i, align 1, !noalias !5019
  store ptr %_41.i.i.i.6.i.i.i.i, ptr %_225.sroa.27412.0.inputs2.sroa_idx.i.i, align 8, !noalias !5019
  store ptr %_19.i.i.i.6.i.i.i.i, ptr %_225.sroa.28.0.inputs2.sroa_idx.i.i, align 8, !noalias !5019
  store i8 64, ptr %_225.sroa.29.0.inputs2.sroa_idx.i.i, align 8, !noalias !5019
  store i8 %_20.i.i.i.6.i.i.i.i, ptr %_225.sroa.30.0.inputs2.sroa_idx.i.i, align 1, !noalias !5019
  store ptr %_41.i.i.i.7.i.i.i.i, ptr %_225.sroa.31413.0.inputs2.sroa_idx.i.i, align 8, !noalias !5019
  store ptr %_19.i.i.i.7.i.i.i.i, ptr %_225.sroa.32.0.inputs2.sroa_idx.i.i, align 8, !noalias !5019
  store i8 64, ptr %_225.sroa.33.0.inputs2.sroa_idx.i.i, align 8, !noalias !5019
  store i8 %_20.i.i.i.7.i.i.i.i, ptr %_225.sroa.34.0.inputs2.sroa_idx.i.i, align 1, !noalias !5019
  %_85.i.i = add nuw nsw i64 %80, 8
  %_232.not.not.i.i = icmp ult i64 %80, %next.sroa.17.0650.i.i
  br i1 %_232.not.not.i.i, label %bb82.i.i, label %bb77.i.i.invoke, !prof !838

bb82.i.i:                                         ; preds = %bb81.i.i
  %142 = inttoptr i64 %next.sroa.7.1652.i.i to ptr
  %_239.i.i = getelementptr inbounds nuw [32 x i8], ptr %142, i64 %80
; invoke blake3_servil::ffi_output::hash_group::<8>
  invoke fastcc void @_RINvNtCs8b9n3vPMt31_13blake3_servil10ffi_output10hash_groupKj8_EB4_(ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(192) %inputs2.i.i, ptr noalias nofree noundef nonnull %_239.i.i, i64 noundef 8)
          to label %bb26.thread.i.i unwind label %cleanup9.loopexit.split-lp.loopexit.i.i, !noalias !5005

bb26.thread.i.i:                                  ; preds = %bb82.i.i
  call void @llvm.lifetime.end.p0(ptr nonnull %inputs2.i.i), !noalias !5019
  %_246.idx868.i.i = shl nuw nsw i64 %next.sroa.17.0650.i.i, 5
  %_246869.i.i = getelementptr inbounds nuw i8, ptr %142, i64 %_246.idx868.i.i
  br label %bb88.peel.i.i

bb91.i.i:                                         ; preds = %bb32.peel.i.i, %bb32.i.i
  %iter3.sroa.0.0.i245.pn.i = phi ptr [ %iter3.sroa.0.0.i245.i, %bb32.i.i ], [ %_0.sroa.2.0.i122.pn.peel896.i.i, %bb32.peel.i.i ]
  %iter3.sroa.20.0.i244.i = phi i64 [ %143, %bb32.i.i ], [ %iter3.sroa.20.1.peel894.i.i, %bb32.peel.i.i ]
  %iter3.sroa.13.0.i243.i = phi i64 [ %_9.0.i120.i.i, %bb32.i.i ], [ %iter3.sroa.13.1.peel893.i.i, %bb32.peel.i.i ]
  %iter3.sroa.0.0.i245.i = getelementptr inbounds nuw i8, ptr %iter3.sroa.0.0.i245.pn.i, i64 32
  %143 = add i64 %iter3.sroa.20.0.i244.i, -1
  %_7.i.i116.i.i = icmp eq ptr %iter3.sroa.0.0.i245.i, %_246872891.i.i
  br i1 %_7.i.i116.i.i, label %bb29.i.i, label %bb1.i126.i.i

bb29.i.i:                                         ; preds = %bb32.i.i, %bb91.i.i, %bb32.peel.i.i, %bb86.peel.i.i, %bb1.i113.peel.i.i, %bb4.i.peel.i.i
  %144 = phi ptr [ %99, %bb1.i113.peel.i.i ], [ %98, %bb86.peel.i.i ], [ %110, %bb32.peel.i.i ], [ %99, %bb4.i.peel.i.i ], [ %110, %bb91.i.i ], [ %110, %bb32.i.i ]
  %145 = phi ptr [ %102, %bb1.i113.peel.i.i ], [ null, %bb86.peel.i.i ], [ %107, %bb32.peel.i.i ], [ %102, %bb4.i.peel.i.i ], [ %107, %bb91.i.i ], [ %107, %bb32.i.i ]
  %exitcond852.not.i.i = icmp eq i64 %indvars.iv.next.i.i, 4
  br i1 %exitcond852.not.i.i, label %bb35.i.i, label %bb67.i.i

bb1.i126.i.i:                                     ; preds = %bb91.i.i
  %_9.0.i120.i.i = add i64 %iter3.sroa.13.0.i243.i, 1
  %_5.i461.i.i = lshr i64 %iter3.sroa.13.0.i243.i, %108
  %_9.i.i.i = icmp ult i64 %_5.i461.i.i, %_137
  br i1 %_9.i.i.i, label %bb2.i127.i.i, label %panic2.i.i.i.i.i191.i.i.invoke

bb2.i127.i.i:                                     ; preds = %bb1.i126.i.i
  %146 = getelementptr inbounds nuw [8 x i8], ptr %_138, i64 %_5.i461.i.i
  %_4.i128.i.i = load i64, ptr %146, align 8, !alias.scope !5005, !noalias !5057, !noundef !566
  %_11.i129.i.i = icmp ult i64 %_4.i128.i.i, %hashers.1
  br i1 %_11.i129.i.i, label %bb3.i130.i.i, label %panic2.i.i.i.i.i191.i.i.invoke

bb3.i130.i.i:                                     ; preds = %bb2.i127.i.i
  %_16.i.i.i = shl i64 %iter3.sroa.13.0.i243.i, 6
  %147 = or disjoint i64 %_16.i.i.i, 63
  %or.cond.not.i.i.i = icmp ult i64 %147, %109
  br i1 %or.cond.not.i.i.i, label %bb30.i.i, label %bb8.i.i.i.i.i197.i.i.invoke, !prof !838

bb30.i.i:                                         ; preds = %bb3.i130.i.i
  %_41.i.i.i = getelementptr inbounds nuw i8, ptr %110, i64 %_16.i.i.i
  %h.i.i.i = getelementptr inbounds nuw [18432 x i8], ptr %hashers.0, i64 %_4.i128.i.i
  %_19.i.i.i = getelementptr inbounds nuw i8, ptr %h.i.i.i, i64 128
  %148 = getelementptr inbounds nuw i8, ptr %h.i.i.i, i64 106
  %_21.i.i.i = load i8, ptr %148, align 2, !alias.scope !5012, !noalias !5061, !noundef !566
  %_20.i.i.i = or i8 %_21.i.i.i, 4
  call void @llvm.lifetime.start.p0(ptr nonnull %cv.i.i), !noalias !5019
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 4 dereferenceable(32) %cv.i.i, ptr noundef nonnull align 64 dereferenceable(32) %_19.i.i.i, i64 32, i1 false), !noalias !5005
  br i1 %63, label %bb2.i139.i.i, label %bb3.i137.i.i

bb3.i137.i.i:                                     ; preds = %bb30.i.i
  call void @blake3_servil_compress_in_place_sse41(ptr noundef nonnull align 4 dereferenceable(32) %cv.i.i, ptr noundef nonnull readonly dereferenceable(64) %_41.i.i.i, i8 noundef zeroext 64, i64 noundef 0, i8 noundef zeroext %_20.i.i.i) #36, !noalias !5062
  br label %bb32.i.i

bb2.i139.i.i:                                     ; preds = %bb30.i.i
  call void @blake3_servil_compress_in_place_avx512(ptr noundef nonnull align 4 dereferenceable(32) %cv.i.i, ptr noundef nonnull readonly dereferenceable(64) %_41.i.i.i, i8 noundef zeroext 64, i64 noundef 0, i8 noundef zeroext %_20.i.i.i) #36, !noalias !5062
  br label %bb32.i.i

bb32.i.i:                                         ; preds = %bb2.i139.i.i, %bb3.i137.i.i
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(32) %iter3.sroa.0.0.i245.i, ptr noundef nonnull align 4 dereferenceable(32) %cv.i.i, i64 32, i1 false), !noalias !5005
  call void @llvm.lifetime.end.p0(ptr nonnull %cv.i.i), !noalias !5019
  %149 = icmp eq i64 %143, 0
  br i1 %149, label %bb29.i.i, label %bb91.i.i, !llvm.loop !5102

bb2.i.i.i.i.i188.i.i:                             ; preds = %bb68.i.i
  %150 = getelementptr inbounds nuw [8 x i8], ptr %_138, i64 %_5.i.i.i.i.i184442.i.i
  %_4.i.i.i.i.i189.i.i = load i64, ptr %150, align 8, !alias.scope !5005, !noalias !5103, !noundef !566
  %_11.i.i.i.i.i190.i.i = icmp ult i64 %_4.i.i.i.i.i189.i.i, %hashers.1
  br i1 %_11.i.i.i.i.i190.i.i, label %bb3.i.i.i.i.i193.i.i, label %panic2.i.i.i.i.i191.i.i.invoke

bb3.i.i.i.i.i193.i.i:                             ; preds = %bb2.i.i.i.i.i188.i.i
  %_16.i.i.i.i.i195.i.i = shl i64 %iter7.sroa.0.0621.i.i, 6
  %151 = or disjoint i64 %_16.i.i.i.i.i195.i.i, 63
  %or.cond.not.i.i.i.i.i196.i.i = icmp ult i64 %151, %82
  br i1 %or.cond.not.i.i.i.i.i196.i.i, label %bb4.i.i200.i.i, label %bb8.i.i.i.i.i197.i.i.invoke, !prof !838

panic2.i.i.i.i.i191.i.i.invoke:                   ; preds = %bb2.i127.peel.i.i, %bb1.i126.peel.i.i, %bb2.i.i.i.i.i.i.i, %bb2.i.i.i.1.i.i.i.i, %bb2.i.i.i.2.i.i.i.i, %bb2.i.i.i.3.i.i.i.i, %bb2.i.i.i.4.i.i.i.i, %bb2.i.i.i.5.i.i.i.i, %bb2.i.i.i.6.i.i.i.i, %bb2.i.i.i.7.i.i.i.i, %bb23.i.i, %bb4.i.i.i.i, %bb4.1.i.i.i.i, %bb4.2.i.i.i.i, %bb4.3.i.i.i.i, %bb4.4.i.i.i.i, %bb4.5.i.i.i.i, %bb4.6.i.i.i.i, %bb2.i.i.i.i.i188.i.i, %bb2.i.i.i.1.i.i207.i.i, %bb2.i.i.i.2.i.i219.i.i, %bb2.i.i.i.3.i.i231.i.i, %bb2.i.i.i.4.i.i243.i.i, %bb2.i.i.i.5.i.i255.i.i, %bb2.i.i.i.6.i.i267.i.i, %bb2.i.i.i.7.i.i279.i.i, %bb68.i.i, %bb4.i.i200.i.i, %bb4.1.i.i213.i.i, %bb4.2.i.i225.i.i, %bb4.3.i.i237.i.i, %bb4.4.i.i249.i.i, %bb4.5.i.i261.i.i, %bb4.6.i.i273.i.i, %bb2.i127.i.i, %bb1.i126.i.i, %bb2.i.i.i.i.i151.us.i.i, %bb2.i.i.us.i.i
  %152 = phi i64 [ %_5.i461.i.i, %bb1.i126.i.i ], [ %_4.i.i.i.i.i152.us.i.i, %bb2.i.i.i.i.i151.us.i.i ], [ %_5.i.i.i.7.i.i277449.i.i, %bb4.6.i.i273.i.i ], [ %_5.i.i.i.i.i148450.us.i.i, %bb2.i.i.us.i.i ], [ %_4.i128.i.i, %bb2.i127.i.i ], [ %_4.i.i.i.4.i.i244.i.i, %bb2.i.i.i.4.i.i243.i.i ], [ %_4.i.i.i.3.i.i232.i.i, %bb2.i.i.i.3.i.i231.i.i ], [ %_4.i.i.i.2.i.i220.i.i, %bb2.i.i.i.2.i.i219.i.i ], [ %_4.i.i.i.1.i.i208.i.i, %bb2.i.i.i.1.i.i207.i.i ], [ %_4.i.i.i.i.i189.i.i, %bb2.i.i.i.i.i188.i.i ], [ %_5.i.i.i.6.i.i265448.i.i, %bb4.5.i.i261.i.i ], [ %_5.i.i.i.5.i.i253447.i.i, %bb4.4.i.i249.i.i ], [ %_5.i.i.i.4.i.i241446.i.i, %bb4.3.i.i237.i.i ], [ %_5.i.i.i.3.i.i229445.i.i, %bb4.2.i.i225.i.i ], [ %_5.i.i.i.2.i.i217444.i.i, %bb4.1.i.i213.i.i ], [ %_5.i.i.i.1.i.i205443.i.i, %bb4.i.i200.i.i ], [ %_5.i.i.i.i.i184442.i.i, %bb68.i.i ], [ %_4.i.i.i.5.i.i256.i.i, %bb2.i.i.i.5.i.i255.i.i ], [ %_4.i.i.i.7.i.i280.i.i, %bb2.i.i.i.7.i.i279.i.i ], [ %_4.i.i.i.6.i.i268.i.i, %bb2.i.i.i.6.i.i267.i.i ], [ %_4.i.i.i.5.i.i.i.i, %bb2.i.i.i.5.i.i.i.i ], [ %_4.i.i.i.4.i.i.i.i, %bb2.i.i.i.4.i.i.i.i ], [ %_4.i.i.i.3.i.i.i.i, %bb2.i.i.i.3.i.i.i.i ], [ %_4.i.i.i.2.i.i.i.i, %bb2.i.i.i.2.i.i.i.i ], [ %_4.i.i.i.1.i.i.i.i, %bb2.i.i.i.1.i.i.i.i ], [ %_4.i.i.i.i.i.i.i, %bb2.i.i.i.i.i.i.i ], [ %_5.i.i.i.6.i.i457.i.i, %bb4.5.i.i.i.i ], [ %_5.i.i.i.5.i.i456.i.i, %bb4.4.i.i.i.i ], [ %_5.i.i.i.4.i.i455.i.i, %bb4.3.i.i.i.i ], [ %_5.i.i.i.3.i.i454.i.i, %bb4.2.i.i.i.i ], [ %_5.i.i.i.2.i.i453.i.i, %bb4.1.i.i.i.i ], [ %_5.i.i.i.1.i.i452.i.i, %bb4.i.i.i.i ], [ %_5.i.i.i.i.i451.i.i, %bb23.i.i ], [ %_5.i.i.i.7.i.i458.i.i, %bb4.6.i.i.i.i ], [ %_4.i.i.i.7.i.i.i.i, %bb2.i.i.i.7.i.i.i.i ], [ %_5.i461.peel.i.i, %bb1.i126.peel.i.i ], [ %_4.i128.peel.i.i, %bb2.i127.peel.i.i ], [ %_4.i.i.i.6.i.i.i.i, %bb2.i.i.i.6.i.i.i.i ]
  %153 = phi i64 [ %_137, %bb1.i126.i.i ], [ %hashers.1, %bb2.i.i.i.i.i151.us.i.i ], [ %_137, %bb4.6.i.i273.i.i ], [ %_137, %bb2.i.i.us.i.i ], [ %hashers.1, %bb2.i127.i.i ], [ %hashers.1, %bb2.i.i.i.4.i.i243.i.i ], [ %hashers.1, %bb2.i.i.i.3.i.i231.i.i ], [ %hashers.1, %bb2.i.i.i.2.i.i219.i.i ], [ %hashers.1, %bb2.i.i.i.1.i.i207.i.i ], [ %hashers.1, %bb2.i.i.i.i.i188.i.i ], [ %_137, %bb4.5.i.i261.i.i ], [ %_137, %bb4.4.i.i249.i.i ], [ %_137, %bb4.3.i.i237.i.i ], [ %_137, %bb4.2.i.i225.i.i ], [ %_137, %bb4.1.i.i213.i.i ], [ %_137, %bb4.i.i200.i.i ], [ %_137, %bb68.i.i ], [ %hashers.1, %bb2.i.i.i.5.i.i255.i.i ], [ %hashers.1, %bb2.i.i.i.7.i.i279.i.i ], [ %hashers.1, %bb2.i.i.i.6.i.i267.i.i ], [ %hashers.1, %bb2.i.i.i.5.i.i.i.i ], [ %hashers.1, %bb2.i.i.i.4.i.i.i.i ], [ %hashers.1, %bb2.i.i.i.3.i.i.i.i ], [ %hashers.1, %bb2.i.i.i.2.i.i.i.i ], [ %hashers.1, %bb2.i.i.i.1.i.i.i.i ], [ %hashers.1, %bb2.i.i.i.i.i.i.i ], [ %_137, %bb4.5.i.i.i.i ], [ %_137, %bb4.4.i.i.i.i ], [ %_137, %bb4.3.i.i.i.i ], [ %_137, %bb4.2.i.i.i.i ], [ %_137, %bb4.1.i.i.i.i ], [ %_137, %bb4.i.i.i.i ], [ %_137, %bb23.i.i ], [ %_137, %bb4.6.i.i.i.i ], [ %hashers.1, %bb2.i.i.i.7.i.i.i.i ], [ %_137, %bb1.i126.peel.i.i ], [ %hashers.1, %bb2.i127.peel.i.i ], [ %hashers.1, %bb2.i.i.i.6.i.i.i.i ]
  %154 = phi ptr [ @alloc_908e8203d442d8802b52c9bde3626562, %bb1.i126.i.i ], [ @alloc_604851cf9c773e42d17999c0c67376b7, %bb2.i.i.i.i.i151.us.i.i ], [ @alloc_908e8203d442d8802b52c9bde3626562, %bb4.6.i.i273.i.i ], [ @alloc_908e8203d442d8802b52c9bde3626562, %bb2.i.i.us.i.i ], [ @alloc_604851cf9c773e42d17999c0c67376b7, %bb2.i127.i.i ], [ @alloc_604851cf9c773e42d17999c0c67376b7, %bb2.i.i.i.4.i.i243.i.i ], [ @alloc_604851cf9c773e42d17999c0c67376b7, %bb2.i.i.i.3.i.i231.i.i ], [ @alloc_604851cf9c773e42d17999c0c67376b7, %bb2.i.i.i.2.i.i219.i.i ], [ @alloc_604851cf9c773e42d17999c0c67376b7, %bb2.i.i.i.1.i.i207.i.i ], [ @alloc_604851cf9c773e42d17999c0c67376b7, %bb2.i.i.i.i.i188.i.i ], [ @alloc_908e8203d442d8802b52c9bde3626562, %bb4.5.i.i261.i.i ], [ @alloc_908e8203d442d8802b52c9bde3626562, %bb4.4.i.i249.i.i ], [ @alloc_908e8203d442d8802b52c9bde3626562, %bb4.3.i.i237.i.i ], [ @alloc_908e8203d442d8802b52c9bde3626562, %bb4.2.i.i225.i.i ], [ @alloc_908e8203d442d8802b52c9bde3626562, %bb4.1.i.i213.i.i ], [ @alloc_908e8203d442d8802b52c9bde3626562, %bb4.i.i200.i.i ], [ @alloc_908e8203d442d8802b52c9bde3626562, %bb68.i.i ], [ @alloc_604851cf9c773e42d17999c0c67376b7, %bb2.i.i.i.5.i.i255.i.i ], [ @alloc_604851cf9c773e42d17999c0c67376b7, %bb2.i.i.i.7.i.i279.i.i ], [ @alloc_604851cf9c773e42d17999c0c67376b7, %bb2.i.i.i.6.i.i267.i.i ], [ @alloc_604851cf9c773e42d17999c0c67376b7, %bb2.i.i.i.5.i.i.i.i ], [ @alloc_604851cf9c773e42d17999c0c67376b7, %bb2.i.i.i.4.i.i.i.i ], [ @alloc_604851cf9c773e42d17999c0c67376b7, %bb2.i.i.i.3.i.i.i.i ], [ @alloc_604851cf9c773e42d17999c0c67376b7, %bb2.i.i.i.2.i.i.i.i ], [ @alloc_604851cf9c773e42d17999c0c67376b7, %bb2.i.i.i.1.i.i.i.i ], [ @alloc_604851cf9c773e42d17999c0c67376b7, %bb2.i.i.i.i.i.i.i ], [ @alloc_908e8203d442d8802b52c9bde3626562, %bb4.5.i.i.i.i ], [ @alloc_908e8203d442d8802b52c9bde3626562, %bb4.4.i.i.i.i ], [ @alloc_908e8203d442d8802b52c9bde3626562, %bb4.3.i.i.i.i ], [ @alloc_908e8203d442d8802b52c9bde3626562, %bb4.2.i.i.i.i ], [ @alloc_908e8203d442d8802b52c9bde3626562, %bb4.1.i.i.i.i ], [ @alloc_908e8203d442d8802b52c9bde3626562, %bb4.i.i.i.i ], [ @alloc_908e8203d442d8802b52c9bde3626562, %bb23.i.i ], [ @alloc_908e8203d442d8802b52c9bde3626562, %bb4.6.i.i.i.i ], [ @alloc_604851cf9c773e42d17999c0c67376b7, %bb2.i.i.i.7.i.i.i.i ], [ @alloc_908e8203d442d8802b52c9bde3626562, %bb1.i126.peel.i.i ], [ @alloc_604851cf9c773e42d17999c0c67376b7, %bb2.i127.peel.i.i ], [ @alloc_604851cf9c773e42d17999c0c67376b7, %bb2.i.i.i.6.i.i.i.i ]
; invoke core::panicking::panic_bounds_check
  invoke void @_RNvNtCskADBYZwJmSU_4core9panicking18panic_bounds_check(i64 noundef %152, i64 noundef range(i64 0, 1152921504606846976) %153, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(24) %154) #44
          to label %panic2.i.i.i.i.i191.i.i.cont unwind label %cleanup9.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.i.i, !noalias !5005

panic2.i.i.i.i.i191.i.i.cont:                     ; preds = %panic2.i.i.i.i.i191.i.i.invoke
  unreachable

bb8.i.i.i.i.i197.i.i.invoke:                      ; preds = %bb3.i130.peel.i.i, %bb3.i.i.i.i.i.i.i, %bb3.i.i.i.1.i.i.i.i, %bb3.i.i.i.2.i.i.i.i, %bb3.i.i.i.3.i.i.i.i, %bb3.i.i.i.4.i.i.i.i, %bb3.i.i.i.5.i.i.i.i, %bb3.i.i.i.6.i.i.i.i, %bb3.i.i.i.7.i.i.i.i, %bb3.i.i.i.i.i193.i.i, %bb3.i.i.i.1.i.i210.i.i, %bb3.i.i.i.2.i.i222.i.i, %bb3.i.i.i.3.i.i234.i.i, %bb3.i.i.i.4.i.i246.i.i, %bb3.i.i.i.5.i.i258.i.i, %bb3.i.i.i.6.i.i270.i.i, %bb3.i.i.i.7.i.i282.i.i, %bb3.i130.i.i, %bb3.i.i.i.i.i155.us.i.i
  %_16.i.i.i.lcssa.i.i.i.i.sink = phi i64 [ %_16.i.i.i.i.i157.us.i.i, %bb3.i.i.i.i.i155.us.i.i ], [ %_16.i.i.i, %bb3.i130.i.i ], [ %_16.i.i.i.7.i.i283.i.i, %bb3.i.i.i.7.i.i282.i.i ], [ %_16.i.i.i.6.i.i271.i.i, %bb3.i.i.i.6.i.i270.i.i ], [ %_16.i.i.i.5.i.i259.i.i, %bb3.i.i.i.5.i.i258.i.i ], [ %_16.i.i.i.4.i.i247.i.i, %bb3.i.i.i.4.i.i246.i.i ], [ %_16.i.i.i.3.i.i235.i.i, %bb3.i.i.i.3.i.i234.i.i ], [ %_16.i.i.i.2.i.i223.i.i, %bb3.i.i.i.2.i.i222.i.i ], [ %_16.i.i.i.1.i.i211.i.i, %bb3.i.i.i.1.i.i210.i.i ], [ %_16.i.i.i.i.i195.i.i, %bb3.i.i.i.i.i193.i.i ], [ %_16.i.i.i.6.i.i.i.i, %bb3.i.i.i.6.i.i.i.i ], [ %_16.i.i.i.5.i.i.i.i, %bb3.i.i.i.5.i.i.i.i ], [ %_16.i.i.i.4.i.i.i.i, %bb3.i.i.i.4.i.i.i.i ], [ %_16.i.i.i.3.i.i.i.i, %bb3.i.i.i.3.i.i.i.i ], [ %_16.i.i.i.2.i.i.i.i, %bb3.i.i.i.2.i.i.i.i ], [ %_16.i.i.i.1.i.i.i.i, %bb3.i.i.i.1.i.i.i.i ], [ %_16.i.i.i.i.i.i.i, %bb3.i.i.i.i.i.i.i ], [ %_16.i.peel.i.i, %bb3.i130.peel.i.i ], [ %_16.i.i.i.7.i.i.i.i, %bb3.i.i.i.7.i.i.i.i ]
  %155 = phi i64 [ %82, %bb3.i.i.i.i.i155.us.i.i ], [ %109, %bb3.i130.i.i ], [ %82, %bb3.i.i.i.i.i193.i.i ], [ %82, %bb3.i.i.i.7.i.i282.i.i ], [ %82, %bb3.i.i.i.6.i.i270.i.i ], [ %82, %bb3.i.i.i.5.i.i258.i.i ], [ %82, %bb3.i.i.i.4.i.i246.i.i ], [ %82, %bb3.i.i.i.3.i.i234.i.i ], [ %82, %bb3.i.i.i.2.i.i222.i.i ], [ %82, %bb3.i.i.i.1.i.i210.i.i ], [ %117, %bb3.i.i.i.6.i.i.i.i ], [ %117, %bb3.i.i.i.5.i.i.i.i ], [ %117, %bb3.i.i.i.4.i.i.i.i ], [ %117, %bb3.i.i.i.3.i.i.i.i ], [ %117, %bb3.i.i.i.2.i.i.i.i ], [ %117, %bb3.i.i.i.1.i.i.i.i ], [ %117, %bb3.i.i.i.i.i.i.i ], [ %109, %bb3.i130.peel.i.i ], [ %117, %bb3.i.i.i.7.i.i.i.i ]
  %_17.i.i.i.i.i.i.i = add i64 %_16.i.i.i.lcssa.i.i.i.i.sink, 64
; invoke core::slice::index::slice_index_fail
  invoke void @_RNvNtNtCskADBYZwJmSU_4core5slice5index16slice_index_fail(i64 noundef %_16.i.i.i.lcssa.i.i.i.i.sink, i64 noundef %_17.i.i.i.i.i.i.i, i64 noundef %155, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(24) @alloc_01db5c437c0538e56ddb3f8472f63125) #44
          to label %bb8.i.i.i.i.i197.i.i.cont unwind label %cleanup9.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.i.i, !noalias !5005

bb8.i.i.i.i.i197.i.i.cont:                        ; preds = %bb8.i.i.i.i.i197.i.i.invoke
  unreachable

bb4.i.i200.i.i:                                   ; preds = %bb3.i.i.i.i.i193.i.i
  %h.i.i.i.i.i202.i.i = getelementptr inbounds nuw [18432 x i8], ptr %hashers.0, i64 %_4.i.i.i.i.i189.i.i
  %156 = getelementptr inbounds nuw i8, ptr %h.i.i.i.i.i202.i.i, i64 106
  %_21.i.i.i.i.i203.i.i = load i8, ptr %156, align 2, !alias.scope !5012, !noalias !5118, !noundef !566
  %_4.i.i.1.i.i204.i.i = or disjoint i64 %iter7.sroa.0.0621.i.i, 1
  %_5.i.i.i.1.i.i205443.i.i = lshr i64 %_4.i.i.1.i.i204.i.i, %81
  %_9.i.i.i.1.i.i206.i.i = icmp ult i64 %_5.i.i.i.1.i.i205443.i.i, %_137
  br i1 %_9.i.i.i.1.i.i206.i.i, label %bb2.i.i.i.1.i.i207.i.i, label %panic2.i.i.i.i.i191.i.i.invoke

bb2.i.i.i.1.i.i207.i.i:                           ; preds = %bb4.i.i200.i.i
  %157 = getelementptr inbounds nuw [8 x i8], ptr %_138, i64 %_5.i.i.i.1.i.i205443.i.i
  %_4.i.i.i.1.i.i208.i.i = load i64, ptr %157, align 8, !alias.scope !5005, !noalias !5119, !noundef !566
  %_11.i.i.i.1.i.i209.i.i = icmp ult i64 %_4.i.i.i.1.i.i208.i.i, %hashers.1
  br i1 %_11.i.i.i.1.i.i209.i.i, label %bb3.i.i.i.1.i.i210.i.i, label %panic2.i.i.i.i.i191.i.i.invoke

bb3.i.i.i.1.i.i210.i.i:                           ; preds = %bb2.i.i.i.1.i.i207.i.i
  %_16.i.i.i.1.i.i211.i.i = shl i64 %_4.i.i.1.i.i204.i.i, 6
  %158 = or disjoint i64 %_16.i.i.i.1.i.i211.i.i, 63
  %or.cond.not.i.i.i.1.i.i212.i.i = icmp ult i64 %158, %82
  br i1 %or.cond.not.i.i.i.1.i.i212.i.i, label %bb4.1.i.i213.i.i, label %bb8.i.i.i.i.i197.i.i.invoke, !prof !838

bb4.1.i.i213.i.i:                                 ; preds = %bb3.i.i.i.1.i.i210.i.i
  %h.i.i.i.1.i.i214.i.i = getelementptr inbounds nuw [18432 x i8], ptr %hashers.0, i64 %_4.i.i.i.1.i.i208.i.i
  %159 = getelementptr inbounds nuw i8, ptr %h.i.i.i.1.i.i214.i.i, i64 106
  %_21.i.i.i.1.i.i215.i.i = load i8, ptr %159, align 2, !alias.scope !5012, !noalias !5121, !noundef !566
  %_4.i.i.2.i.i216.i.i = or disjoint i64 %iter7.sroa.0.0621.i.i, 2
  %_5.i.i.i.2.i.i217444.i.i = lshr i64 %_4.i.i.2.i.i216.i.i, %81
  %_9.i.i.i.2.i.i218.i.i = icmp ult i64 %_5.i.i.i.2.i.i217444.i.i, %_137
  br i1 %_9.i.i.i.2.i.i218.i.i, label %bb2.i.i.i.2.i.i219.i.i, label %panic2.i.i.i.i.i191.i.i.invoke

bb2.i.i.i.2.i.i219.i.i:                           ; preds = %bb4.1.i.i213.i.i
  %160 = getelementptr inbounds nuw [8 x i8], ptr %_138, i64 %_5.i.i.i.2.i.i217444.i.i
  %_4.i.i.i.2.i.i220.i.i = load i64, ptr %160, align 8, !alias.scope !5005, !noalias !5122, !noundef !566
  %_11.i.i.i.2.i.i221.i.i = icmp ult i64 %_4.i.i.i.2.i.i220.i.i, %hashers.1
  br i1 %_11.i.i.i.2.i.i221.i.i, label %bb3.i.i.i.2.i.i222.i.i, label %panic2.i.i.i.i.i191.i.i.invoke

bb3.i.i.i.2.i.i222.i.i:                           ; preds = %bb2.i.i.i.2.i.i219.i.i
  %_16.i.i.i.2.i.i223.i.i = shl i64 %_4.i.i.2.i.i216.i.i, 6
  %161 = or disjoint i64 %_16.i.i.i.2.i.i223.i.i, 63
  %or.cond.not.i.i.i.2.i.i224.i.i = icmp ult i64 %161, %82
  br i1 %or.cond.not.i.i.i.2.i.i224.i.i, label %bb4.2.i.i225.i.i, label %bb8.i.i.i.i.i197.i.i.invoke, !prof !838

bb4.2.i.i225.i.i:                                 ; preds = %bb3.i.i.i.2.i.i222.i.i
  %h.i.i.i.2.i.i226.i.i = getelementptr inbounds nuw [18432 x i8], ptr %hashers.0, i64 %_4.i.i.i.2.i.i220.i.i
  %162 = getelementptr inbounds nuw i8, ptr %h.i.i.i.2.i.i226.i.i, i64 106
  %_21.i.i.i.2.i.i227.i.i = load i8, ptr %162, align 2, !alias.scope !5012, !noalias !5124, !noundef !566
  %_4.i.i.3.i.i228.i.i = or disjoint i64 %iter7.sroa.0.0621.i.i, 3
  %_5.i.i.i.3.i.i229445.i.i = lshr i64 %_4.i.i.3.i.i228.i.i, %81
  %_9.i.i.i.3.i.i230.i.i = icmp ult i64 %_5.i.i.i.3.i.i229445.i.i, %_137
  br i1 %_9.i.i.i.3.i.i230.i.i, label %bb2.i.i.i.3.i.i231.i.i, label %panic2.i.i.i.i.i191.i.i.invoke

bb2.i.i.i.3.i.i231.i.i:                           ; preds = %bb4.2.i.i225.i.i
  %163 = getelementptr inbounds nuw [8 x i8], ptr %_138, i64 %_5.i.i.i.3.i.i229445.i.i
  %_4.i.i.i.3.i.i232.i.i = load i64, ptr %163, align 8, !alias.scope !5005, !noalias !5125, !noundef !566
  %_11.i.i.i.3.i.i233.i.i = icmp ult i64 %_4.i.i.i.3.i.i232.i.i, %hashers.1
  br i1 %_11.i.i.i.3.i.i233.i.i, label %bb3.i.i.i.3.i.i234.i.i, label %panic2.i.i.i.i.i191.i.i.invoke

bb3.i.i.i.3.i.i234.i.i:                           ; preds = %bb2.i.i.i.3.i.i231.i.i
  %_16.i.i.i.3.i.i235.i.i = shl i64 %_4.i.i.3.i.i228.i.i, 6
  %164 = or disjoint i64 %_16.i.i.i.3.i.i235.i.i, 63
  %or.cond.not.i.i.i.3.i.i236.i.i = icmp ult i64 %164, %82
  br i1 %or.cond.not.i.i.i.3.i.i236.i.i, label %bb4.3.i.i237.i.i, label %bb8.i.i.i.i.i197.i.i.invoke, !prof !838

bb4.3.i.i237.i.i:                                 ; preds = %bb3.i.i.i.3.i.i234.i.i
  %h.i.i.i.3.i.i238.i.i = getelementptr inbounds nuw [18432 x i8], ptr %hashers.0, i64 %_4.i.i.i.3.i.i232.i.i
  %165 = getelementptr inbounds nuw i8, ptr %h.i.i.i.3.i.i238.i.i, i64 106
  %_21.i.i.i.3.i.i239.i.i = load i8, ptr %165, align 2, !alias.scope !5012, !noalias !5127, !noundef !566
  %_4.i.i.4.i.i240.i.i = or disjoint i64 %iter7.sroa.0.0621.i.i, 4
  %_5.i.i.i.4.i.i241446.i.i = lshr i64 %_4.i.i.4.i.i240.i.i, %81
  %_9.i.i.i.4.i.i242.i.i = icmp ult i64 %_5.i.i.i.4.i.i241446.i.i, %_137
  br i1 %_9.i.i.i.4.i.i242.i.i, label %bb2.i.i.i.4.i.i243.i.i, label %panic2.i.i.i.i.i191.i.i.invoke

bb2.i.i.i.4.i.i243.i.i:                           ; preds = %bb4.3.i.i237.i.i
  %166 = getelementptr inbounds nuw [8 x i8], ptr %_138, i64 %_5.i.i.i.4.i.i241446.i.i
  %_4.i.i.i.4.i.i244.i.i = load i64, ptr %166, align 8, !alias.scope !5005, !noalias !5128, !noundef !566
  %_11.i.i.i.4.i.i245.i.i = icmp ult i64 %_4.i.i.i.4.i.i244.i.i, %hashers.1
  br i1 %_11.i.i.i.4.i.i245.i.i, label %bb3.i.i.i.4.i.i246.i.i, label %panic2.i.i.i.i.i191.i.i.invoke

bb3.i.i.i.4.i.i246.i.i:                           ; preds = %bb2.i.i.i.4.i.i243.i.i
  %_16.i.i.i.4.i.i247.i.i = shl i64 %_4.i.i.4.i.i240.i.i, 6
  %167 = or disjoint i64 %_16.i.i.i.4.i.i247.i.i, 63
  %or.cond.not.i.i.i.4.i.i248.i.i = icmp ult i64 %167, %82
  br i1 %or.cond.not.i.i.i.4.i.i248.i.i, label %bb4.4.i.i249.i.i, label %bb8.i.i.i.i.i197.i.i.invoke, !prof !838

bb4.4.i.i249.i.i:                                 ; preds = %bb3.i.i.i.4.i.i246.i.i
  %h.i.i.i.4.i.i250.i.i = getelementptr inbounds nuw [18432 x i8], ptr %hashers.0, i64 %_4.i.i.i.4.i.i244.i.i
  %168 = getelementptr inbounds nuw i8, ptr %h.i.i.i.4.i.i250.i.i, i64 106
  %_21.i.i.i.4.i.i251.i.i = load i8, ptr %168, align 2, !alias.scope !5012, !noalias !5130, !noundef !566
  %_4.i.i.5.i.i252.i.i = or disjoint i64 %iter7.sroa.0.0621.i.i, 5
  %_5.i.i.i.5.i.i253447.i.i = lshr i64 %_4.i.i.5.i.i252.i.i, %81
  %_9.i.i.i.5.i.i254.i.i = icmp ult i64 %_5.i.i.i.5.i.i253447.i.i, %_137
  br i1 %_9.i.i.i.5.i.i254.i.i, label %bb2.i.i.i.5.i.i255.i.i, label %panic2.i.i.i.i.i191.i.i.invoke

bb2.i.i.i.5.i.i255.i.i:                           ; preds = %bb4.4.i.i249.i.i
  %169 = getelementptr inbounds nuw [8 x i8], ptr %_138, i64 %_5.i.i.i.5.i.i253447.i.i
  %_4.i.i.i.5.i.i256.i.i = load i64, ptr %169, align 8, !alias.scope !5005, !noalias !5131, !noundef !566
  %_11.i.i.i.5.i.i257.i.i = icmp ult i64 %_4.i.i.i.5.i.i256.i.i, %hashers.1
  br i1 %_11.i.i.i.5.i.i257.i.i, label %bb3.i.i.i.5.i.i258.i.i, label %panic2.i.i.i.i.i191.i.i.invoke

bb3.i.i.i.5.i.i258.i.i:                           ; preds = %bb2.i.i.i.5.i.i255.i.i
  %_16.i.i.i.5.i.i259.i.i = shl i64 %_4.i.i.5.i.i252.i.i, 6
  %170 = or disjoint i64 %_16.i.i.i.5.i.i259.i.i, 63
  %or.cond.not.i.i.i.5.i.i260.i.i = icmp ult i64 %170, %82
  br i1 %or.cond.not.i.i.i.5.i.i260.i.i, label %bb4.5.i.i261.i.i, label %bb8.i.i.i.i.i197.i.i.invoke, !prof !838

bb4.5.i.i261.i.i:                                 ; preds = %bb3.i.i.i.5.i.i258.i.i
  %h.i.i.i.5.i.i262.i.i = getelementptr inbounds nuw [18432 x i8], ptr %hashers.0, i64 %_4.i.i.i.5.i.i256.i.i
  %171 = getelementptr inbounds nuw i8, ptr %h.i.i.i.5.i.i262.i.i, i64 106
  %_21.i.i.i.5.i.i263.i.i = load i8, ptr %171, align 2, !alias.scope !5012, !noalias !5133, !noundef !566
  %_4.i.i.6.i.i264.i.i = or disjoint i64 %iter7.sroa.0.0621.i.i, 6
  %_5.i.i.i.6.i.i265448.i.i = lshr i64 %_4.i.i.6.i.i264.i.i, %81
  %_9.i.i.i.6.i.i266.i.i = icmp ult i64 %_5.i.i.i.6.i.i265448.i.i, %_137
  br i1 %_9.i.i.i.6.i.i266.i.i, label %bb2.i.i.i.6.i.i267.i.i, label %panic2.i.i.i.i.i191.i.i.invoke

bb2.i.i.i.6.i.i267.i.i:                           ; preds = %bb4.5.i.i261.i.i
  %172 = getelementptr inbounds nuw [8 x i8], ptr %_138, i64 %_5.i.i.i.6.i.i265448.i.i
  %_4.i.i.i.6.i.i268.i.i = load i64, ptr %172, align 8, !alias.scope !5005, !noalias !5134, !noundef !566
  %_11.i.i.i.6.i.i269.i.i = icmp ult i64 %_4.i.i.i.6.i.i268.i.i, %hashers.1
  br i1 %_11.i.i.i.6.i.i269.i.i, label %bb3.i.i.i.6.i.i270.i.i, label %panic2.i.i.i.i.i191.i.i.invoke

bb3.i.i.i.6.i.i270.i.i:                           ; preds = %bb2.i.i.i.6.i.i267.i.i
  %_16.i.i.i.6.i.i271.i.i = shl i64 %_4.i.i.6.i.i264.i.i, 6
  %173 = or disjoint i64 %_16.i.i.i.6.i.i271.i.i, 63
  %or.cond.not.i.i.i.6.i.i272.i.i = icmp ult i64 %173, %82
  br i1 %or.cond.not.i.i.i.6.i.i272.i.i, label %bb4.6.i.i273.i.i, label %bb8.i.i.i.i.i197.i.i.invoke, !prof !838

bb4.6.i.i273.i.i:                                 ; preds = %bb3.i.i.i.6.i.i270.i.i
  %h.i.i.i.6.i.i274.i.i = getelementptr inbounds nuw [18432 x i8], ptr %hashers.0, i64 %_4.i.i.i.6.i.i268.i.i
  %174 = getelementptr inbounds nuw i8, ptr %h.i.i.i.6.i.i274.i.i, i64 106
  %_21.i.i.i.6.i.i275.i.i = load i8, ptr %174, align 2, !alias.scope !5012, !noalias !5136, !noundef !566
  %_4.i.i.7.i.i276.i.i = or disjoint i64 %iter7.sroa.0.0621.i.i, 7
  %_5.i.i.i.7.i.i277449.i.i = lshr i64 %_4.i.i.7.i.i276.i.i, %81
  %_9.i.i.i.7.i.i278.i.i = icmp ult i64 %_5.i.i.i.7.i.i277449.i.i, %_137
  br i1 %_9.i.i.i.7.i.i278.i.i, label %bb2.i.i.i.7.i.i279.i.i, label %panic2.i.i.i.i.i191.i.i.invoke

bb2.i.i.i.7.i.i279.i.i:                           ; preds = %bb4.6.i.i273.i.i
  %175 = getelementptr inbounds nuw [8 x i8], ptr %_138, i64 %_5.i.i.i.7.i.i277449.i.i
  %_4.i.i.i.7.i.i280.i.i = load i64, ptr %175, align 8, !alias.scope !5005, !noalias !5137, !noundef !566
  %_11.i.i.i.7.i.i281.i.i = icmp ult i64 %_4.i.i.i.7.i.i280.i.i, %hashers.1
  br i1 %_11.i.i.i.7.i.i281.i.i, label %bb3.i.i.i.7.i.i282.i.i, label %panic2.i.i.i.i.i191.i.i.invoke

bb3.i.i.i.7.i.i282.i.i:                           ; preds = %bb2.i.i.i.7.i.i279.i.i
  %_16.i.i.i.7.i.i283.i.i = shl i64 %_4.i.i.7.i.i276.i.i, 6
  %176 = or disjoint i64 %_16.i.i.i.7.i.i283.i.i, 63
  %or.cond.not.i.i.i.7.i.i284.i.i = icmp ult i64 %176, %82
  br i1 %or.cond.not.i.i.i.7.i.i284.i.i, label %bb75.i.i, label %bb8.i.i.i.i.i197.i.i.invoke, !prof !838

bb75.i.i:                                         ; preds = %bb3.i.i.i.7.i.i282.i.i
  %or.cond42.not.i.i = icmp ult i64 %_4.i.i.7.i.i276.i.i, %next.sroa.17.0650.i.i
  br i1 %or.cond42.not.i.i, label %bb18.i.i, label %bb77.i.i, !prof !838

bb77.i.i:                                         ; preds = %bb75.i.i
  %_71.i.i = add i64 %iter7.sroa.0.0621.i.i, 8
  br label %bb77.i.i.invoke

bb77.i.i.invoke:                                  ; preds = %bb81.i.i, %bb70.us.i.i, %bb77.i.i
  %177 = phi i64 [ %iter7.sroa.0.0621.i.i, %bb77.i.i ], [ %iter7.sroa.0.0621.us.i.i, %bb70.us.i.i ], [ %80, %bb81.i.i ]
  %178 = phi i64 [ %_71.i.i, %bb77.i.i ], [ %_63.us.i.i, %bb70.us.i.i ], [ %_85.i.i, %bb81.i.i ]
  %179 = phi ptr [ @alloc_57ad84068a892b557d87c1a06bee4870, %bb77.i.i ], [ @alloc_51f47652a57d9c14a65f2273511cbdc1, %bb70.us.i.i ], [ @alloc_a1c9a68976e25f9b62cbd2feeb22adc0, %bb81.i.i ]
; invoke core::slice::index::slice_index_fail
  invoke void @_RNvNtNtCskADBYZwJmSU_4core5slice5index16slice_index_fail(i64 noundef %177, i64 noundef %178, i64 noundef %next.sroa.17.0650.i.i, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(24) %179) #41
          to label %bb77.i.i.cont unwind label %cleanup9.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.i.i, !noalias !5005

bb77.i.i.cont:                                    ; preds = %bb77.i.i.invoke
  unreachable

bb18.i.i:                                         ; preds = %bb75.i.i
  %h.i.i.i.7.i.i307.i.i = getelementptr inbounds nuw [18432 x i8], ptr %hashers.0, i64 %_4.i.i.i.7.i.i280.i.i
  %180 = getelementptr inbounds nuw i8, ptr %h.i.i.i.7.i.i307.i.i, i64 106
  %_21.i.i.i.7.i.i309.i.i = load i8, ptr %180, align 2, !alias.scope !5012, !noalias !5139, !noundef !566
  %_19.i.i.i.7.i.i308.i.i = getelementptr inbounds nuw i8, ptr %h.i.i.i.7.i.i307.i.i, i64 128
  %_41.i.i.i.7.i.i306.i.i = getelementptr inbounds nuw i8, ptr %83, i64 %_16.i.i.i.7.i.i283.i.i
  %_41.i.i.i.i.i305.i.i = getelementptr inbounds nuw i8, ptr %83, i64 %_16.i.i.i.i.i195.i.i
  %_19.i.i.i.i.i304.i.i = getelementptr inbounds nuw i8, ptr %h.i.i.i.i.i202.i.i, i64 128
  %181 = insertelement <4 x i8> poison, i8 %_21.i.i.i.i.i203.i.i, i64 0
  %182 = insertelement <4 x i8> %181, i8 %_21.i.i.i.1.i.i215.i.i, i64 1
  %183 = insertelement <4 x i8> %182, i8 %_21.i.i.i.2.i.i227.i.i, i64 2
  %184 = insertelement <4 x i8> %183, i8 %_21.i.i.i.3.i.i239.i.i, i64 3
  %185 = or <4 x i8> %184, splat (i8 4)
  %_41.i.i.i.1.i.i302.i.i = getelementptr inbounds nuw i8, ptr %83, i64 %_16.i.i.i.1.i.i211.i.i
  %_19.i.i.i.1.i.i301.i.i = getelementptr inbounds nuw i8, ptr %h.i.i.i.1.i.i214.i.i, i64 128
  %_41.i.i.i.2.i.i299.i.i = getelementptr inbounds nuw i8, ptr %83, i64 %_16.i.i.i.2.i.i223.i.i
  %_19.i.i.i.2.i.i298.i.i = getelementptr inbounds nuw i8, ptr %h.i.i.i.2.i.i226.i.i, i64 128
  %_41.i.i.i.3.i.i296.i.i = getelementptr inbounds nuw i8, ptr %83, i64 %_16.i.i.i.3.i.i235.i.i
  %_19.i.i.i.3.i.i295.i.i = getelementptr inbounds nuw i8, ptr %h.i.i.i.3.i.i238.i.i, i64 128
  %_41.i.i.i.4.i.i293.i.i = getelementptr inbounds nuw i8, ptr %83, i64 %_16.i.i.i.4.i.i247.i.i
  %_19.i.i.i.4.i.i292.i.i = getelementptr inbounds nuw i8, ptr %h.i.i.i.4.i.i250.i.i, i64 128
  %_41.i.i.i.5.i.i290.i.i = getelementptr inbounds nuw i8, ptr %83, i64 %_16.i.i.i.5.i.i259.i.i
  %_19.i.i.i.5.i.i289.i.i = getelementptr inbounds nuw i8, ptr %h.i.i.i.5.i.i262.i.i, i64 128
  %_41.i.i.i.6.i.i287.i.i = getelementptr inbounds nuw i8, ptr %83, i64 %_16.i.i.i.6.i.i271.i.i
  %_19.i.i.i.6.i.i286.i.i = getelementptr inbounds nuw i8, ptr %h.i.i.i.6.i.i274.i.i, i64 128
  %_222.i.i = getelementptr inbounds nuw [32 x i8], ptr %84, i64 %iter7.sroa.0.0621.i.i
  call void @llvm.lifetime.start.p0(ptr nonnull %p.i.i.i), !noalias !5140
  %_0.i.i.i.i.i.i.i.i.i.i.i = load i32, ptr %_19.i.i.i.i.i304.i.i, align 64, !alias.scope !5012, !noalias !5144, !noundef !566
  %_0.i.i.1.i.i.i.i.i.i.i.i.i = load i32, ptr %_19.i.i.i.1.i.i301.i.i, align 64, !alias.scope !5012, !noalias !5144, !noundef !566
  %_0.i.i.2.i.i.i.i.i.i.i.i.i = load i32, ptr %_19.i.i.i.2.i.i298.i.i, align 64, !alias.scope !5012, !noalias !5144, !noundef !566
  %_0.i.i.3.i.i.i.i.i.i.i.i.i = load i32, ptr %_19.i.i.i.3.i.i295.i.i, align 64, !alias.scope !5012, !noalias !5144, !noundef !566
  %_0.i.i.4.i.i.i.i.i.i.i.i.i = load i32, ptr %_19.i.i.i.4.i.i292.i.i, align 64, !alias.scope !5012, !noalias !5144, !noundef !566
  %_0.i.i.5.i.i.i.i.i.i.i.i.i = load i32, ptr %_19.i.i.i.5.i.i289.i.i, align 64, !alias.scope !5012, !noalias !5144, !noundef !566
  %_0.i.i.6.i.i.i.i.i.i.i.i.i = load i32, ptr %_19.i.i.i.6.i.i286.i.i, align 64, !alias.scope !5012, !noalias !5144, !noundef !566
  %_0.i.i.7.i.i.i.i.i.i.i.i.i = load i32, ptr %_19.i.i.i.7.i.i308.i.i, align 64, !alias.scope !5012, !noalias !5144, !noundef !566
  %186 = getelementptr inbounds nuw i8, ptr %h.i.i.i.i.i202.i.i, i64 132
  %_0.i.i.i.i.i.i.1.i.i.i.i.i = load i32, ptr %186, align 4, !alias.scope !5012, !noalias !5160, !noundef !566
  %187 = getelementptr inbounds nuw i8, ptr %h.i.i.i.1.i.i214.i.i, i64 132
  %_0.i.i.1.i.i.i.i.1.i.i.i.i.i = load i32, ptr %187, align 4, !alias.scope !5012, !noalias !5160, !noundef !566
  %188 = getelementptr inbounds nuw i8, ptr %h.i.i.i.2.i.i226.i.i, i64 132
  %_0.i.i.2.i.i.i.i.1.i.i.i.i.i = load i32, ptr %188, align 4, !alias.scope !5012, !noalias !5160, !noundef !566
  %189 = getelementptr inbounds nuw i8, ptr %h.i.i.i.3.i.i238.i.i, i64 132
  %_0.i.i.3.i.i.i.i.1.i.i.i.i.i = load i32, ptr %189, align 4, !alias.scope !5012, !noalias !5160, !noundef !566
  %190 = getelementptr inbounds nuw i8, ptr %h.i.i.i.4.i.i250.i.i, i64 132
  %_0.i.i.4.i.i.i.i.1.i.i.i.i.i = load i32, ptr %190, align 4, !alias.scope !5012, !noalias !5160, !noundef !566
  %191 = getelementptr inbounds nuw i8, ptr %h.i.i.i.5.i.i262.i.i, i64 132
  %_0.i.i.5.i.i.i.i.1.i.i.i.i.i = load i32, ptr %191, align 4, !alias.scope !5012, !noalias !5160, !noundef !566
  %192 = getelementptr inbounds nuw i8, ptr %h.i.i.i.6.i.i274.i.i, i64 132
  %_0.i.i.6.i.i.i.i.1.i.i.i.i.i = load i32, ptr %192, align 4, !alias.scope !5012, !noalias !5160, !noundef !566
  %193 = getelementptr inbounds nuw i8, ptr %h.i.i.i.7.i.i307.i.i, i64 132
  %_0.i.i.7.i.i.i.i.1.i.i.i.i.i = load i32, ptr %193, align 4, !alias.scope !5012, !noalias !5160, !noundef !566
  %194 = getelementptr inbounds nuw i8, ptr %h.i.i.i.i.i202.i.i, i64 136
  %_0.i.i.i.i.i.i.2.i.i.i.i.i = load i32, ptr %194, align 8, !alias.scope !5012, !noalias !5163, !noundef !566
  %195 = getelementptr inbounds nuw i8, ptr %h.i.i.i.1.i.i214.i.i, i64 136
  %_0.i.i.1.i.i.i.i.2.i.i.i.i.i = load i32, ptr %195, align 8, !alias.scope !5012, !noalias !5163, !noundef !566
  %196 = getelementptr inbounds nuw i8, ptr %h.i.i.i.2.i.i226.i.i, i64 136
  %_0.i.i.2.i.i.i.i.2.i.i.i.i.i = load i32, ptr %196, align 8, !alias.scope !5012, !noalias !5163, !noundef !566
  %197 = getelementptr inbounds nuw i8, ptr %h.i.i.i.3.i.i238.i.i, i64 136
  %_0.i.i.3.i.i.i.i.2.i.i.i.i.i = load i32, ptr %197, align 8, !alias.scope !5012, !noalias !5163, !noundef !566
  %198 = getelementptr inbounds nuw i8, ptr %h.i.i.i.4.i.i250.i.i, i64 136
  %_0.i.i.4.i.i.i.i.2.i.i.i.i.i = load i32, ptr %198, align 8, !alias.scope !5012, !noalias !5163, !noundef !566
  %199 = getelementptr inbounds nuw i8, ptr %h.i.i.i.5.i.i262.i.i, i64 136
  %_0.i.i.5.i.i.i.i.2.i.i.i.i.i = load i32, ptr %199, align 8, !alias.scope !5012, !noalias !5163, !noundef !566
  %200 = getelementptr inbounds nuw i8, ptr %h.i.i.i.6.i.i274.i.i, i64 136
  %_0.i.i.6.i.i.i.i.2.i.i.i.i.i = load i32, ptr %200, align 8, !alias.scope !5012, !noalias !5163, !noundef !566
  %201 = getelementptr inbounds nuw i8, ptr %h.i.i.i.7.i.i307.i.i, i64 136
  %_0.i.i.7.i.i.i.i.2.i.i.i.i.i = load i32, ptr %201, align 8, !alias.scope !5012, !noalias !5163, !noundef !566
  %202 = getelementptr inbounds nuw i8, ptr %h.i.i.i.i.i202.i.i, i64 140
  %_0.i.i.i.i.i.i.3.i.i.i.i.i = load i32, ptr %202, align 4, !alias.scope !5012, !noalias !5166, !noundef !566
  %203 = getelementptr inbounds nuw i8, ptr %h.i.i.i.1.i.i214.i.i, i64 140
  %_0.i.i.1.i.i.i.i.3.i.i.i.i.i = load i32, ptr %203, align 4, !alias.scope !5012, !noalias !5166, !noundef !566
  %204 = getelementptr inbounds nuw i8, ptr %h.i.i.i.2.i.i226.i.i, i64 140
  %_0.i.i.2.i.i.i.i.3.i.i.i.i.i = load i32, ptr %204, align 4, !alias.scope !5012, !noalias !5166, !noundef !566
  %205 = getelementptr inbounds nuw i8, ptr %h.i.i.i.3.i.i238.i.i, i64 140
  %_0.i.i.3.i.i.i.i.3.i.i.i.i.i = load i32, ptr %205, align 4, !alias.scope !5012, !noalias !5166, !noundef !566
  %206 = getelementptr inbounds nuw i8, ptr %h.i.i.i.4.i.i250.i.i, i64 140
  %_0.i.i.4.i.i.i.i.3.i.i.i.i.i = load i32, ptr %206, align 4, !alias.scope !5012, !noalias !5166, !noundef !566
  %207 = getelementptr inbounds nuw i8, ptr %h.i.i.i.5.i.i262.i.i, i64 140
  %_0.i.i.5.i.i.i.i.3.i.i.i.i.i = load i32, ptr %207, align 4, !alias.scope !5012, !noalias !5166, !noundef !566
  %208 = getelementptr inbounds nuw i8, ptr %h.i.i.i.6.i.i274.i.i, i64 140
  %_0.i.i.6.i.i.i.i.3.i.i.i.i.i = load i32, ptr %208, align 4, !alias.scope !5012, !noalias !5166, !noundef !566
  %209 = getelementptr inbounds nuw i8, ptr %h.i.i.i.7.i.i307.i.i, i64 140
  %_0.i.i.7.i.i.i.i.3.i.i.i.i.i = load i32, ptr %209, align 4, !alias.scope !5012, !noalias !5166, !noundef !566
  %210 = getelementptr inbounds nuw i8, ptr %h.i.i.i.i.i202.i.i, i64 144
  %_0.i.i.i.i.i.i.4.i.i.i.i.i = load i32, ptr %210, align 16, !alias.scope !5012, !noalias !5169, !noundef !566
  %211 = getelementptr inbounds nuw i8, ptr %h.i.i.i.1.i.i214.i.i, i64 144
  %_0.i.i.1.i.i.i.i.4.i.i.i.i.i = load i32, ptr %211, align 16, !alias.scope !5012, !noalias !5169, !noundef !566
  %212 = getelementptr inbounds nuw i8, ptr %h.i.i.i.2.i.i226.i.i, i64 144
  %_0.i.i.2.i.i.i.i.4.i.i.i.i.i = load i32, ptr %212, align 16, !alias.scope !5012, !noalias !5169, !noundef !566
  %213 = getelementptr inbounds nuw i8, ptr %h.i.i.i.3.i.i238.i.i, i64 144
  %_0.i.i.3.i.i.i.i.4.i.i.i.i.i = load i32, ptr %213, align 16, !alias.scope !5012, !noalias !5169, !noundef !566
  %214 = getelementptr inbounds nuw i8, ptr %h.i.i.i.4.i.i250.i.i, i64 144
  %_0.i.i.4.i.i.i.i.4.i.i.i.i.i = load i32, ptr %214, align 16, !alias.scope !5012, !noalias !5169, !noundef !566
  %215 = getelementptr inbounds nuw i8, ptr %h.i.i.i.5.i.i262.i.i, i64 144
  %_0.i.i.5.i.i.i.i.4.i.i.i.i.i = load i32, ptr %215, align 16, !alias.scope !5012, !noalias !5169, !noundef !566
  %216 = getelementptr inbounds nuw i8, ptr %h.i.i.i.6.i.i274.i.i, i64 144
  %_0.i.i.6.i.i.i.i.4.i.i.i.i.i = load i32, ptr %216, align 16, !alias.scope !5012, !noalias !5169, !noundef !566
  %217 = getelementptr inbounds nuw i8, ptr %h.i.i.i.7.i.i307.i.i, i64 144
  %_0.i.i.7.i.i.i.i.4.i.i.i.i.i = load i32, ptr %217, align 16, !alias.scope !5012, !noalias !5169, !noundef !566
  %218 = getelementptr inbounds nuw i8, ptr %h.i.i.i.i.i202.i.i, i64 148
  %_0.i.i.i.i.i.i.5.i.i.i.i.i = load i32, ptr %218, align 4, !alias.scope !5012, !noalias !5172, !noundef !566
  %219 = getelementptr inbounds nuw i8, ptr %h.i.i.i.1.i.i214.i.i, i64 148
  %_0.i.i.1.i.i.i.i.5.i.i.i.i.i = load i32, ptr %219, align 4, !alias.scope !5012, !noalias !5172, !noundef !566
  %220 = getelementptr inbounds nuw i8, ptr %h.i.i.i.2.i.i226.i.i, i64 148
  %_0.i.i.2.i.i.i.i.5.i.i.i.i.i = load i32, ptr %220, align 4, !alias.scope !5012, !noalias !5172, !noundef !566
  %221 = getelementptr inbounds nuw i8, ptr %h.i.i.i.3.i.i238.i.i, i64 148
  %_0.i.i.3.i.i.i.i.5.i.i.i.i.i = load i32, ptr %221, align 4, !alias.scope !5012, !noalias !5172, !noundef !566
  %222 = getelementptr inbounds nuw i8, ptr %h.i.i.i.4.i.i250.i.i, i64 148
  %_0.i.i.4.i.i.i.i.5.i.i.i.i.i = load i32, ptr %222, align 4, !alias.scope !5012, !noalias !5172, !noundef !566
  %223 = getelementptr inbounds nuw i8, ptr %h.i.i.i.5.i.i262.i.i, i64 148
  %_0.i.i.5.i.i.i.i.5.i.i.i.i.i = load i32, ptr %223, align 4, !alias.scope !5012, !noalias !5172, !noundef !566
  %224 = getelementptr inbounds nuw i8, ptr %h.i.i.i.6.i.i274.i.i, i64 148
  %_0.i.i.6.i.i.i.i.5.i.i.i.i.i = load i32, ptr %224, align 4, !alias.scope !5012, !noalias !5172, !noundef !566
  %225 = getelementptr inbounds nuw i8, ptr %h.i.i.i.7.i.i307.i.i, i64 148
  %_0.i.i.7.i.i.i.i.5.i.i.i.i.i = load i32, ptr %225, align 4, !alias.scope !5012, !noalias !5172, !noundef !566
  %226 = getelementptr inbounds nuw i8, ptr %h.i.i.i.i.i202.i.i, i64 152
  %_0.i.i.i.i.i.i.6.i.i.i.i.i = load i32, ptr %226, align 8, !alias.scope !5012, !noalias !5175, !noundef !566
  %227 = getelementptr inbounds nuw i8, ptr %h.i.i.i.1.i.i214.i.i, i64 152
  %_0.i.i.1.i.i.i.i.6.i.i.i.i.i = load i32, ptr %227, align 8, !alias.scope !5012, !noalias !5175, !noundef !566
  %228 = getelementptr inbounds nuw i8, ptr %h.i.i.i.2.i.i226.i.i, i64 152
  %_0.i.i.2.i.i.i.i.6.i.i.i.i.i = load i32, ptr %228, align 8, !alias.scope !5012, !noalias !5175, !noundef !566
  %229 = getelementptr inbounds nuw i8, ptr %h.i.i.i.3.i.i238.i.i, i64 152
  %_0.i.i.3.i.i.i.i.6.i.i.i.i.i = load i32, ptr %229, align 8, !alias.scope !5012, !noalias !5175, !noundef !566
  %230 = getelementptr inbounds nuw i8, ptr %h.i.i.i.4.i.i250.i.i, i64 152
  %_0.i.i.4.i.i.i.i.6.i.i.i.i.i = load i32, ptr %230, align 8, !alias.scope !5012, !noalias !5175, !noundef !566
  %231 = getelementptr inbounds nuw i8, ptr %h.i.i.i.5.i.i262.i.i, i64 152
  %_0.i.i.5.i.i.i.i.6.i.i.i.i.i = load i32, ptr %231, align 8, !alias.scope !5012, !noalias !5175, !noundef !566
  %232 = getelementptr inbounds nuw i8, ptr %h.i.i.i.6.i.i274.i.i, i64 152
  %_0.i.i.6.i.i.i.i.6.i.i.i.i.i = load i32, ptr %232, align 8, !alias.scope !5012, !noalias !5175, !noundef !566
  %233 = getelementptr inbounds nuw i8, ptr %h.i.i.i.7.i.i307.i.i, i64 152
  %_0.i.i.7.i.i.i.i.6.i.i.i.i.i = load i32, ptr %233, align 8, !alias.scope !5012, !noalias !5175, !noundef !566
  %234 = getelementptr inbounds nuw i8, ptr %h.i.i.i.i.i202.i.i, i64 156
  %_0.i.i.i.i.i.i.7.i.i.i.i.i = load i32, ptr %234, align 4, !alias.scope !5012, !noalias !5178, !noundef !566
  %235 = getelementptr inbounds nuw i8, ptr %h.i.i.i.1.i.i214.i.i, i64 156
  %_0.i.i.1.i.i.i.i.7.i.i.i.i.i = load i32, ptr %235, align 4, !alias.scope !5012, !noalias !5178, !noundef !566
  %236 = getelementptr inbounds nuw i8, ptr %h.i.i.i.2.i.i226.i.i, i64 156
  %_0.i.i.2.i.i.i.i.7.i.i.i.i.i = load i32, ptr %236, align 4, !alias.scope !5012, !noalias !5178, !noundef !566
  %237 = getelementptr inbounds nuw i8, ptr %h.i.i.i.3.i.i238.i.i, i64 156
  %_0.i.i.3.i.i.i.i.7.i.i.i.i.i = load i32, ptr %237, align 4, !alias.scope !5012, !noalias !5178, !noundef !566
  %238 = getelementptr inbounds nuw i8, ptr %h.i.i.i.4.i.i250.i.i, i64 156
  %_0.i.i.4.i.i.i.i.7.i.i.i.i.i = load i32, ptr %238, align 4, !alias.scope !5012, !noalias !5178, !noundef !566
  %239 = getelementptr inbounds nuw i8, ptr %h.i.i.i.5.i.i262.i.i, i64 156
  %_0.i.i.5.i.i.i.i.7.i.i.i.i.i = load i32, ptr %239, align 4, !alias.scope !5012, !noalias !5178, !noundef !566
  %240 = getelementptr inbounds nuw i8, ptr %h.i.i.i.6.i.i274.i.i, i64 156
  %_0.i.i.6.i.i.i.i.7.i.i.i.i.i = load i32, ptr %240, align 4, !alias.scope !5012, !noalias !5178, !noundef !566
  %241 = getelementptr inbounds nuw i8, ptr %h.i.i.i.7.i.i307.i.i, i64 156
  %_0.i.i.7.i.i.i.i.7.i.i.i.i.i = load i32, ptr %241, align 4, !alias.scope !5012, !noalias !5178, !noundef !566
  store ptr %_41.i.i.i.i.i305.i.i, ptr %p.i.i.i, align 64, !noalias !5140
  store ptr %_41.i.i.i.1.i.i302.i.i, ptr %_20.sroa.4.0.p.sroa_idx.i.i.i, align 8, !noalias !5140
  store ptr %_41.i.i.i.2.i.i299.i.i, ptr %_20.sroa.5.0.p.sroa_idx.i.i.i, align 16, !noalias !5140
  store ptr %_41.i.i.i.3.i.i296.i.i, ptr %_20.sroa.6.0.p.sroa_idx.i.i.i, align 8, !noalias !5140
  store ptr %_41.i.i.i.4.i.i293.i.i, ptr %_20.sroa.7.0.p.sroa_idx.i.i.i, align 32, !noalias !5140
  store ptr %_41.i.i.i.5.i.i290.i.i, ptr %_20.sroa.8.0.p.sroa_idx.i.i.i, align 8, !noalias !5140
  store ptr %_41.i.i.i.6.i.i287.i.i, ptr %_20.sroa.9.0.p.sroa_idx.i.i.i, align 16, !noalias !5140
  store ptr %_41.i.i.i.7.i.i306.i.i, ptr %_20.sroa.10.0.p.sroa_idx.i.i.i, align 8, !noalias !5140
  store i32 %_0.i.i.i.i.i.i.i.i.i.i.i, ptr %38, align 64, !noalias !5140
  store i32 %_0.i.i.1.i.i.i.i.i.i.i.i.i, ptr %_22.sroa.4.0..sroa_idx.i.i.i, align 4, !noalias !5140
  store i32 %_0.i.i.2.i.i.i.i.i.i.i.i.i, ptr %_22.sroa.5.0..sroa_idx.i.i.i, align 8, !noalias !5140
  store i32 %_0.i.i.3.i.i.i.i.i.i.i.i.i, ptr %_22.sroa.6.0..sroa_idx.i.i.i, align 4, !noalias !5140
  store i32 %_0.i.i.4.i.i.i.i.i.i.i.i.i, ptr %_22.sroa.7.0..sroa_idx.i.i.i, align 16, !noalias !5140
  store i32 %_0.i.i.5.i.i.i.i.i.i.i.i.i, ptr %_22.sroa.8.0..sroa_idx.i.i.i, align 4, !noalias !5140
  store i32 %_0.i.i.6.i.i.i.i.i.i.i.i.i, ptr %_22.sroa.9.0..sroa_idx.i.i.i, align 8, !noalias !5140
  store i32 %_0.i.i.7.i.i.i.i.i.i.i.i.i, ptr %_22.sroa.10.0..sroa_idx.i.i.i, align 4, !noalias !5140
  store i32 %_0.i.i.i.i.i.i.1.i.i.i.i.i, ptr %_22.sroa.11.0..sroa_idx.i.i.i, align 32, !noalias !5140
  store i32 %_0.i.i.1.i.i.i.i.1.i.i.i.i.i, ptr %_22.sroa.12.0..sroa_idx.i.i.i, align 4, !noalias !5140
  store i32 %_0.i.i.2.i.i.i.i.1.i.i.i.i.i, ptr %_22.sroa.13.0..sroa_idx.i.i.i, align 8, !noalias !5140
  store i32 %_0.i.i.3.i.i.i.i.1.i.i.i.i.i, ptr %_22.sroa.14.0..sroa_idx.i.i.i, align 4, !noalias !5140
  store i32 %_0.i.i.4.i.i.i.i.1.i.i.i.i.i, ptr %_22.sroa.15.0..sroa_idx.i.i.i, align 16, !noalias !5140
  store i32 %_0.i.i.5.i.i.i.i.1.i.i.i.i.i, ptr %_22.sroa.16.0..sroa_idx.i.i.i, align 4, !noalias !5140
  store i32 %_0.i.i.6.i.i.i.i.1.i.i.i.i.i, ptr %_22.sroa.17.0..sroa_idx.i.i.i, align 8, !noalias !5140
  store i32 %_0.i.i.7.i.i.i.i.1.i.i.i.i.i, ptr %_22.sroa.18.0..sroa_idx.i.i.i, align 4, !noalias !5140
  store i32 %_0.i.i.i.i.i.i.2.i.i.i.i.i, ptr %_22.sroa.19.0..sroa_idx.i.i.i, align 64, !noalias !5140
  store i32 %_0.i.i.1.i.i.i.i.2.i.i.i.i.i, ptr %_22.sroa.20.0..sroa_idx.i.i.i, align 4, !noalias !5140
  store i32 %_0.i.i.2.i.i.i.i.2.i.i.i.i.i, ptr %_22.sroa.21.0..sroa_idx.i.i.i, align 8, !noalias !5140
  store i32 %_0.i.i.3.i.i.i.i.2.i.i.i.i.i, ptr %_22.sroa.22.0..sroa_idx.i.i.i, align 4, !noalias !5140
  store i32 %_0.i.i.4.i.i.i.i.2.i.i.i.i.i, ptr %_22.sroa.23.0..sroa_idx.i.i.i, align 16, !noalias !5140
  store i32 %_0.i.i.5.i.i.i.i.2.i.i.i.i.i, ptr %_22.sroa.24.0..sroa_idx.i.i.i, align 4, !noalias !5140
  store i32 %_0.i.i.6.i.i.i.i.2.i.i.i.i.i, ptr %_22.sroa.25.0..sroa_idx.i.i.i, align 8, !noalias !5140
  store i32 %_0.i.i.7.i.i.i.i.2.i.i.i.i.i, ptr %_22.sroa.26.0..sroa_idx.i.i.i, align 4, !noalias !5140
  store i32 %_0.i.i.i.i.i.i.3.i.i.i.i.i, ptr %_22.sroa.27.0..sroa_idx.i.i.i, align 32, !noalias !5140
  store i32 %_0.i.i.1.i.i.i.i.3.i.i.i.i.i, ptr %_22.sroa.28.0..sroa_idx.i.i.i, align 4, !noalias !5140
  store i32 %_0.i.i.2.i.i.i.i.3.i.i.i.i.i, ptr %_22.sroa.29.0..sroa_idx.i.i.i, align 8, !noalias !5140
  store i32 %_0.i.i.3.i.i.i.i.3.i.i.i.i.i, ptr %_22.sroa.30.0..sroa_idx.i.i.i, align 4, !noalias !5140
  store i32 %_0.i.i.4.i.i.i.i.3.i.i.i.i.i, ptr %_22.sroa.31.0..sroa_idx.i.i.i, align 16, !noalias !5140
  store i32 %_0.i.i.5.i.i.i.i.3.i.i.i.i.i, ptr %_22.sroa.32.0..sroa_idx.i.i.i, align 4, !noalias !5140
  store i32 %_0.i.i.6.i.i.i.i.3.i.i.i.i.i, ptr %_22.sroa.33.0..sroa_idx.i.i.i, align 8, !noalias !5140
  store i32 %_0.i.i.7.i.i.i.i.3.i.i.i.i.i, ptr %_22.sroa.34.0..sroa_idx.i.i.i, align 4, !noalias !5140
  store i32 %_0.i.i.i.i.i.i.4.i.i.i.i.i, ptr %_22.sroa.35.0..sroa_idx.i.i.i, align 64, !noalias !5140
  store i32 %_0.i.i.1.i.i.i.i.4.i.i.i.i.i, ptr %_22.sroa.36.0..sroa_idx.i.i.i, align 4, !noalias !5140
  store i32 %_0.i.i.2.i.i.i.i.4.i.i.i.i.i, ptr %_22.sroa.37.0..sroa_idx.i.i.i, align 8, !noalias !5140
  store i32 %_0.i.i.3.i.i.i.i.4.i.i.i.i.i, ptr %_22.sroa.38.0..sroa_idx.i.i.i, align 4, !noalias !5140
  store i32 %_0.i.i.4.i.i.i.i.4.i.i.i.i.i, ptr %_22.sroa.39.0..sroa_idx.i.i.i, align 16, !noalias !5140
  store i32 %_0.i.i.5.i.i.i.i.4.i.i.i.i.i, ptr %_22.sroa.40.0..sroa_idx.i.i.i, align 4, !noalias !5140
  store i32 %_0.i.i.6.i.i.i.i.4.i.i.i.i.i, ptr %_22.sroa.41.0..sroa_idx.i.i.i, align 8, !noalias !5140
  store i32 %_0.i.i.7.i.i.i.i.4.i.i.i.i.i, ptr %_22.sroa.42.0..sroa_idx.i.i.i, align 4, !noalias !5140
  store i32 %_0.i.i.i.i.i.i.5.i.i.i.i.i, ptr %_22.sroa.43.0..sroa_idx.i.i.i, align 32, !noalias !5140
  store i32 %_0.i.i.1.i.i.i.i.5.i.i.i.i.i, ptr %_22.sroa.44.0..sroa_idx.i.i.i, align 4, !noalias !5140
  store i32 %_0.i.i.2.i.i.i.i.5.i.i.i.i.i, ptr %_22.sroa.45.0..sroa_idx.i.i.i, align 8, !noalias !5140
  store i32 %_0.i.i.3.i.i.i.i.5.i.i.i.i.i, ptr %_22.sroa.46.0..sroa_idx.i.i.i, align 4, !noalias !5140
  store i32 %_0.i.i.4.i.i.i.i.5.i.i.i.i.i, ptr %_22.sroa.47.0..sroa_idx.i.i.i, align 16, !noalias !5140
  store i32 %_0.i.i.5.i.i.i.i.5.i.i.i.i.i, ptr %_22.sroa.48.0..sroa_idx.i.i.i, align 4, !noalias !5140
  store i32 %_0.i.i.6.i.i.i.i.5.i.i.i.i.i, ptr %_22.sroa.49.0..sroa_idx.i.i.i, align 8, !noalias !5140
  store i32 %_0.i.i.7.i.i.i.i.5.i.i.i.i.i, ptr %_22.sroa.50.0..sroa_idx.i.i.i, align 4, !noalias !5140
  store i32 %_0.i.i.i.i.i.i.6.i.i.i.i.i, ptr %_22.sroa.51.0..sroa_idx.i.i.i, align 64, !noalias !5140
  store i32 %_0.i.i.1.i.i.i.i.6.i.i.i.i.i, ptr %_22.sroa.52.0..sroa_idx.i.i.i, align 4, !noalias !5140
  store i32 %_0.i.i.2.i.i.i.i.6.i.i.i.i.i, ptr %_22.sroa.53.0..sroa_idx.i.i.i, align 8, !noalias !5140
  store i32 %_0.i.i.3.i.i.i.i.6.i.i.i.i.i, ptr %_22.sroa.54.0..sroa_idx.i.i.i, align 4, !noalias !5140
  store i32 %_0.i.i.4.i.i.i.i.6.i.i.i.i.i, ptr %_22.sroa.55.0..sroa_idx.i.i.i, align 16, !noalias !5140
  store i32 %_0.i.i.5.i.i.i.i.6.i.i.i.i.i, ptr %_22.sroa.56.0..sroa_idx.i.i.i, align 4, !noalias !5140
  store i32 %_0.i.i.6.i.i.i.i.6.i.i.i.i.i, ptr %_22.sroa.57.0..sroa_idx.i.i.i, align 8, !noalias !5140
  store i32 %_0.i.i.7.i.i.i.i.6.i.i.i.i.i, ptr %_22.sroa.58.0..sroa_idx.i.i.i, align 4, !noalias !5140
  store i32 %_0.i.i.i.i.i.i.7.i.i.i.i.i, ptr %_22.sroa.59.0..sroa_idx.i.i.i, align 32, !noalias !5140
  store i32 %_0.i.i.1.i.i.i.i.7.i.i.i.i.i, ptr %_22.sroa.60.0..sroa_idx.i.i.i, align 4, !noalias !5140
  store i32 %_0.i.i.2.i.i.i.i.7.i.i.i.i.i, ptr %_22.sroa.61.0..sroa_idx.i.i.i, align 8, !noalias !5140
  store i32 %_0.i.i.3.i.i.i.i.7.i.i.i.i.i, ptr %_22.sroa.62.0..sroa_idx.i.i.i, align 4, !noalias !5140
  store i32 %_0.i.i.4.i.i.i.i.7.i.i.i.i.i, ptr %_22.sroa.63.0..sroa_idx.i.i.i, align 16, !noalias !5140
  store i32 %_0.i.i.5.i.i.i.i.7.i.i.i.i.i, ptr %_22.sroa.64.0..sroa_idx.i.i.i, align 4, !noalias !5140
  store i32 %_0.i.i.6.i.i.i.i.7.i.i.i.i.i, ptr %_22.sroa.65.0..sroa_idx.i.i.i, align 8, !noalias !5140
  store i32 %_0.i.i.7.i.i.i.i.7.i.i.i.i.i, ptr %_22.sroa.66.0..sroa_idx.i.i.i, align 4, !noalias !5140
  store <4 x i32> splat (i32 64), ptr %39, align 64, !noalias !5140
  store <4 x i32> splat (i32 64), ptr %_24.sroa.7.0..sroa_idx.i.i.i, align 16, !noalias !5140
  %242 = zext <4 x i8> %185 to <4 x i32>
  store <4 x i32> %242, ptr %40, align 32, !noalias !5140
  %243 = insertelement <4 x i8> poison, i8 %_21.i.i.i.4.i.i251.i.i, i64 0
  %244 = insertelement <4 x i8> %243, i8 %_21.i.i.i.5.i.i263.i.i, i64 1
  %245 = insertelement <4 x i8> %244, i8 %_21.i.i.i.6.i.i275.i.i, i64 2
  %246 = insertelement <4 x i8> %245, i8 %_21.i.i.i.7.i.i309.i.i, i64 3
  %247 = or <4 x i8> %246, splat (i8 4)
  %248 = zext <4 x i8> %247 to <4 x i32>
  store <4 x i32> %248, ptr %_26.sroa.7.0..sroa_idx.i.i.i, align 16, !noalias !5140
  call void @blake3_servil_output8(ptr noundef nonnull %p.i.i.i, ptr noundef nonnull %_222.i.i) #36, !noalias !5181
  call void @llvm.lifetime.end.p0(ptr nonnull %p.i.i.i), !noalias !5140
  %_187.not.i.i = icmp eq i64 %91, 0
  br i1 %_187.not.i.i, label %bb69.i.i, label %bb68.i.i

bb8.i.i:                                          ; preds = %bb6.i.i
  %h.i.i = getelementptr inbounds nuw [18432 x i8], ptr %hashers.0, i64 %i16.i.i
  %249 = getelementptr inbounds nuw i8, ptr %h.i.i, i64 18368
  %_3.i352.i.i = load i64, ptr %249, align 64, !alias.scope !5182, !noalias !5005, !noundef !566
  %250 = icmp eq i64 %_3.i352.i.i, 16384
  %251 = getelementptr inbounds nuw i8, ptr %h.i.i, i64 1936
  %_4.i353.i.i = load i64, ptr %251, align 16, !alias.scope !5182, !noalias !5005
  %_2.i354.i.i = icmp eq i64 %_4.i353.i.i, 0
  %or.cond.i355.i.i = select i1 %250, i1 %_2.i354.i.i, i1 false
  br i1 %or.cond.i355.i.i, label %bb58.i.i, label %bb56.i.i

panic17.i.i:                                      ; preds = %bb6.i.i
; invoke core::panicking::panic_bounds_check
  invoke void @_RNvNtCskADBYZwJmSU_4core9panicking18panic_bounds_check(i64 noundef %i16.i.i, i64 noundef range(i64 0, 500399958596722) %hashers.1, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(24) @alloc_afa68f959ac7182e65d7a02779a4b852) #41
          to label %unreachable.i.i unwind label %cleanup9.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.i.i, !noalias !5005

bb56.i.i:                                         ; preds = %bb8.i.i
; invoke core::option::expect_failed
  invoke void @_RNvNtCskADBYZwJmSU_4core6option13expect_failed(ptr noalias nofree noundef nonnull readonly captures(address, read_provenance) @alloc_892642cc7f6c32dc42749a5a71ace53a, i64 noundef 12, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(24) @alloc_4ece9b74efc730574140dc570ee664e5) #41
          to label %unreachable.i.i unwind label %cleanup9.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.i.i, !noalias !5005

bb58.i.i:                                         ; preds = %bb8.i.i
  %_20.i.i360.i.i = getelementptr inbounds nuw i8, ptr %h.i.i, i64 1984
  %252 = getelementptr inbounds nuw i8, ptr %h.i.i, i64 105
  %_15.i.i361.i.i = load i8, ptr %252, align 1, !alias.scope !5185, !noalias !5005, !noundef !566
  %253 = getelementptr inbounds nuw i8, ptr %h.i.i, i64 104
  %_17.i.i364.i.i = load i8, ptr %253, align 8, !alias.scope !5185, !noalias !5005, !noundef !566
  %254 = getelementptr inbounds nuw i8, ptr %h.i.i, i64 96
  %_9.i.i367.i.i = load i64, ptr %254, align 32, !alias.scope !5185, !noalias !5005, !noundef !566
  call void @llvm.lifetime.start.p0(ptr nonnull %refs.i.i), !noalias !5019
  %_16.i.i.1.i.i.i.i = getelementptr inbounds nuw i8, ptr %h.i.i, i64 3008
  %_16.i.i.2.i.i.i.i = getelementptr inbounds nuw i8, ptr %h.i.i, i64 4032
  %_16.i.i.3.i.i.i.i = getelementptr inbounds nuw i8, ptr %h.i.i, i64 5056
  %_16.i.i.4.i.i.i.i = getelementptr inbounds nuw i8, ptr %h.i.i, i64 6080
  %_16.i.i.5.i.i.i.i = getelementptr inbounds nuw i8, ptr %h.i.i, i64 7104
  %_16.i.i.6.i.i.i.i = getelementptr inbounds nuw i8, ptr %h.i.i, i64 8128
  %_16.i.i.7.i.i.i.i = getelementptr inbounds nuw i8, ptr %h.i.i, i64 9152
  %_16.i.i.8.i.i.i.i = getelementptr inbounds nuw i8, ptr %h.i.i, i64 10176
  %_16.i.i.9.i.i.i.i = getelementptr inbounds nuw i8, ptr %h.i.i, i64 11200
  %_16.i.i.10.i.i.i.i = getelementptr inbounds nuw i8, ptr %h.i.i, i64 12224
  %_16.i.i.11.i.i.i.i = getelementptr inbounds nuw i8, ptr %h.i.i, i64 13248
  %_16.i.i.12.i.i.i.i = getelementptr inbounds nuw i8, ptr %h.i.i, i64 14272
  %_16.i.i.13.i.i.i.i = getelementptr inbounds nuw i8, ptr %h.i.i, i64 15296
  %_16.i.i.14.i.i.i.i = getelementptr inbounds nuw i8, ptr %h.i.i, i64 16320
  %_16.i.i.15.i.i.i.i = getelementptr inbounds nuw i8, ptr %h.i.i, i64 17344
  store ptr %_20.i.i360.i.i, ptr %refs.i.i, align 8, !noalias !5019
  store ptr %_16.i.i.1.i.i.i.i, ptr %_154.sroa.4.0.refs.sroa_idx.i.i, align 8, !noalias !5019
  store ptr %_16.i.i.2.i.i.i.i, ptr %_154.sroa.5.0.refs.sroa_idx.i.i, align 8, !noalias !5019
  store ptr %_16.i.i.3.i.i.i.i, ptr %_154.sroa.6.0.refs.sroa_idx.i.i, align 8, !noalias !5019
  store ptr %_16.i.i.4.i.i.i.i, ptr %_154.sroa.7.0.refs.sroa_idx.i.i, align 8, !noalias !5019
  store ptr %_16.i.i.5.i.i.i.i, ptr %_154.sroa.8.0.refs.sroa_idx.i.i, align 8, !noalias !5019
  store ptr %_16.i.i.6.i.i.i.i, ptr %_154.sroa.9.0.refs.sroa_idx.i.i, align 8, !noalias !5019
  store ptr %_16.i.i.7.i.i.i.i, ptr %_154.sroa.10.0.refs.sroa_idx.i.i, align 8, !noalias !5019
  store ptr %_16.i.i.8.i.i.i.i, ptr %_154.sroa.11.0.refs.sroa_idx.i.i, align 8, !noalias !5019
  store ptr %_16.i.i.9.i.i.i.i, ptr %_154.sroa.12.0.refs.sroa_idx.i.i, align 8, !noalias !5019
  store ptr %_16.i.i.10.i.i.i.i, ptr %_154.sroa.13.0.refs.sroa_idx.i.i, align 8, !noalias !5019
  store ptr %_16.i.i.11.i.i.i.i, ptr %_154.sroa.14.0.refs.sroa_idx.i.i, align 8, !noalias !5019
  store ptr %_16.i.i.12.i.i.i.i, ptr %_154.sroa.15.0.refs.sroa_idx.i.i, align 8, !noalias !5019
  store ptr %_16.i.i.13.i.i.i.i, ptr %_154.sroa.16.0.refs.sroa_idx.i.i, align 8, !noalias !5019
  store ptr %_16.i.i.14.i.i.i.i, ptr %_154.sroa.17.0.refs.sroa_idx.i.i, align 8, !noalias !5019
  store ptr %_16.i.i.15.i.i.i.i, ptr %_154.sroa.18.0.refs.sroa_idx.i.i, align 8, !noalias !5019
  %_32.i.i = shl i64 %iter.sroa.7.0618.i.i, 4
  %exitcond.not.i.i = icmp eq i64 %iter.sroa.7.0618.i.i, %_137
  br i1 %exitcond.not.i.i, label %bb60.i.i, label %bb10.i.i, !prof !1406

bb60.i.i:                                         ; preds = %bb58.i.i
  %_33.i.i = add i64 %_32.i.i, 16
; invoke core::slice::index::slice_index_fail
  invoke void @_RNvNtNtCskADBYZwJmSU_4core5slice5index16slice_index_fail(i64 noundef %_32.i.i, i64 noundef %_33.i.i, i64 noundef %_7.i.i47, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(24) @alloc_3d8f0a4d80387d98c887ffb595840446) #41
          to label %unreachable.i.i unwind label %cleanup9.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.i.i, !noalias !5005

bb10.i.i:                                         ; preds = %bb58.i.i
  %255 = getelementptr inbounds nuw i8, ptr %h.i.i, i64 106
  %_29.i.i = load i8, ptr %255, align 2, !alias.scope !5012, !noalias !5005, !noundef !566
  %_28.i.i = getelementptr inbounds nuw i8, ptr %h.i.i, i64 128
  %_14.i.i362.i.i = zext i8 %_15.i.i361.i.i to i64
  %_13.i.i363.i.i = shl nuw nsw i64 %_14.i.i362.i.i, 6
  %_16.i.i365.i.i = zext i8 %_17.i.i364.i.i to i64
  %_12.i.i366.i.i = add nuw nsw i64 %_13.i.i363.i.i, %_16.i.i365.i.i
  %256 = lshr i64 %_12.i.i366.i.i, 10
  %257 = add i64 %256, %_9.i.i367.i.i
  %_22.i.i368.i.i = and i64 %257, 18014398509481983
  %_168.i.i = getelementptr inbounds nuw [32 x i8], ptr %51, i64 %_32.i.i
; invoke <blake3_servil::platform::Platform>::hash_many::<1024>
  invoke fastcc void @_RINvMs0_NtCs8b9n3vPMt31_13blake3_servil8platformNtB6_8Platform9hash_manyKj400_EB8_(i8 range(i8 3, 6) %platform.i, ptr noalias nofree noundef nonnull readonly align 8 captures(address, read_provenance) %refs.i.i, i64 noundef 16, ptr noalias nofree noundef readonly align 4 captures(address, read_provenance) dereferenceable(32) %_28.i.i, i64 noundef %_22.i.i368.i.i, i1 noundef zeroext false, i8 noundef %_29.i.i, i8 noundef 2, ptr noalias nofree noundef nonnull %_168.i.i, i64 noundef 512)
          to label %bb11.i.i unwind label %cleanup9.loopexit.split-lp.loopexit.split-lp.loopexit.i.i

bb11.i.i:                                         ; preds = %bb10.i.i
  call void @llvm.lifetime.end.p0(ptr nonnull %refs.i.i), !noalias !5019
  %_6.i.i.i.i = icmp eq ptr %_16.i.i.i.i, %_41.i
  br i1 %_6.i.i.i.i, label %bb12.preheader.i.i, label %bb6.i.i

bb50.i.i:                                         ; preds = %bb2.i.i.i4.i78.i.i, %cleanup.i.i
  %level.sroa.7.0.i.i = phi ptr [ %51, %cleanup.i.i ], [ %65, %bb2.i.i.i4.i78.i.i ]
  %level.sroa.0.0.i.i = phi i64 [ %_7.i.i47, %cleanup.i.i ], [ %level.sroa.0.1.i.i, %bb2.i.i.i4.i78.i.i ]
  %.pn37.i.i = phi { ptr, i32 } [ %61, %cleanup.i.i ], [ %lpad.phi.i.i, %bb2.i.i.i4.i78.i.i ]
  %alloc_size.i.i.i.i5.i.i.i = shl nuw i64 %level.sroa.0.0.i.i, 5
  call void @llvm.assume(i1 true) [ "nonnull"(ptr %level.sroa.7.0.i.i) ]
; call __rustc::__rust_dealloc
  call void @_RNvCs5fGHjzWXRav_7___rustc14___rust_dealloc(ptr noundef nonnull %level.sroa.7.0.i.i, i64 noundef %alloc_size.i.i.i.i5.i.i.i, i64 noundef range(i64 1, -9223372036854775807) 1) #36, !noalias !5005
  br label %cleanup.body

bb8.i42:                                          ; preds = %bb5.i
  call void @llvm.lifetime.start.p0(ptr nonnull %vector.i.i), !noalias !5188
  br label %bb3.i.i.i.i.i.i

bb1.i.i.i.i.i.i:                                  ; preds = %_RNCINvNtNtNtCskADBYZwJmSU_4core4iter8adapters6copied13copy_try_foldjuINtNtNtBa_3ops12control_flow11ControlFlowjENCINvNvNtNtNtB8_6traits8iterator8Iterator4find5checkjQNCNvNtCs8b9n3vPMt31_13blake3_servil4each9hash_helds_0E0E0B2K_.exit.i.i.i.i.i.i
  %_6.i.i.i.not.not.not.not.i.not.not.not.i.not.i.i = icmp eq ptr %_16.i.i.i.i.i.i8.i, %_41.i
  br i1 %_6.i.i.i.not.not.not.not.i.not.not.not.i.not.i.i, label %_RNvXNtNtCsgFX3jaOk65H_5alloc3vec21spec_from_iter_nestedINtB4_3VecjEINtB2_18SpecFromIterNestedjINtNtNtNtCskADBYZwJmSU_4core4iter8adapters6filter6FilterINtNtB1z_6copied6CopiedINtNtNtB1D_5slice4iter4IterjEENCNvNtCs8b9n3vPMt31_13blake3_servil4each9hash_helds_0EE9from_iterB3l_.exit.thread.i, label %bb3.i.i.i.i.i.i

_RNvXNtNtCsgFX3jaOk65H_5alloc3vec21spec_from_iter_nestedINtB4_3VecjEINtB2_18SpecFromIterNestedjINtNtNtNtCskADBYZwJmSU_4core4iter8adapters6filter6FilterINtNtB1z_6copied6CopiedINtNtNtB1D_5slice4iter4IterjEENCNvNtCs8b9n3vPMt31_13blake3_servil4each9hash_helds_0EE9from_iterB3l_.exit.thread.i: ; preds = %bb1.i.i.i.i.i.i
  call void @llvm.lifetime.end.p0(ptr nonnull %vector.i.i), !noalias !5188
  br label %bb27.preheader.i

bb3.i.i.i.i.i.i:                                  ; preds = %bb8.i42, %bb1.i.i.i.i.i.i
  %_16.i4.i.i.i.i.i.i3064 = phi ptr [ %_138, %bb8.i42 ], [ %_16.i.i.i.i.i.i8.i, %bb1.i.i.i.i.i.i ]
  %.val.i.i.i.i.i.i = load i64, ptr %_16.i4.i.i.i.i.i.i3064, align 8, !alias.scope !4985, !noalias !5192, !noundef !566
  %_6.i.i.i.i.i.i.i.i.i.i = icmp ult i64 %.val.i.i.i.i.i.i, %hashers.1
  br i1 %_6.i.i.i.i.i.i.i.i.i.i, label %_RNCINvNtNtNtCskADBYZwJmSU_4core4iter8adapters6copied13copy_try_foldjuINtNtNtBa_3ops12control_flow11ControlFlowjENCINvNvNtNtNtB8_6traits8iterator8Iterator4find5checkjQNCNvNtCs8b9n3vPMt31_13blake3_servil4each9hash_helds_0E0E0B2K_.exit.i.i.i.i.i.i, label %panic.i.i.i.invoke

_RNCINvNtNtNtCskADBYZwJmSU_4core4iter8adapters6copied13copy_try_foldjuINtNtNtBa_3ops12control_flow11ControlFlowjENCINvNvNtNtNtB8_6traits8iterator8Iterator4find5checkjQNCNvNtCs8b9n3vPMt31_13blake3_servil4each9hash_helds_0E0E0B2K_.exit.i.i.i.i.i.i: ; preds = %bb3.i.i.i.i.i.i
  %_16.i.i.i.i.i.i8.i = getelementptr inbounds nuw i8, ptr %_16.i4.i.i.i.i.i.i3064, i64 8
  %258 = getelementptr inbounds nuw [18432 x i8], ptr %hashers.0, i64 %.val.i.i.i.i.i.i
  %259 = getelementptr inbounds nuw i8, ptr %258, i64 106
  %_4.i.i.i.i.i.i.i.i.i.i = load i8, ptr %259, align 2, !alias.scope !4982, !noalias !5202, !noundef !566
  %_0.i.i.i.i.i.i.i.i.i.i = icmp eq i8 %_4.i.i.i.i.i.i.i.i.i.i, 0
  br i1 %_0.i.i.i.i.i.i.i.i.i.i, label %bb3.i.i.i9.i, label %bb1.i.i.i.i.i.i

bb3.i.i.i9.i:                                     ; preds = %_RNCINvNtNtNtCskADBYZwJmSU_4core4iter8adapters6copied13copy_try_foldjuINtNtNtBa_3ops12control_flow11ControlFlowjENCINvNvNtNtNtB8_6traits8iterator8Iterator4find5checkjQNCNvNtCs8b9n3vPMt31_13blake3_servil4each9hash_helds_0E0E0B2K_.exit.i.i.i.i.i.i
; call __rustc::__rust_no_alloc_shim_is_unstable_v2
  call void @_RNvCs5fGHjzWXRav_7___rustc35___rust_no_alloc_shim_is_unstable_v2() #36, !noalias !5203
; call __rustc::__rust_alloc
  %260 = call noundef align 8 dereferenceable_or_null(32) ptr @_RNvCs5fGHjzWXRav_7___rustc12___rust_alloc(i64 noundef range(i64 0, -9223372036854775808) 32, i64 noundef range(i64 1, 129) 8) #36, !noalias !5203
  %261 = icmp eq ptr %260, null
  br i1 %261, label %bb3.i.i.i.i.invoke, label %_RNvMs5_NtCsgFX3jaOk65H_5alloc7raw_vecNtB5_11RawVecInner16with_capacity_inCs8b9n3vPMt31_13blake3_servil.exit.i.i

_RNvMs5_NtCsgFX3jaOk65H_5alloc7raw_vecNtB5_11RawVecInner16with_capacity_inCs8b9n3vPMt31_13blake3_servil.exit.i.i: ; preds = %bb3.i.i.i9.i
  store i64 %.val.i.i.i.i.i.i, ptr %260, align 8, !noalias !5206
  store i64 4, ptr %vector.i.i, align 8, !noalias !5188
  store ptr %260, ptr %vector1.sroa.4.0.vector.sroa_idx.i.i, align 8, !noalias !5188
  store i64 1, ptr %vector1.sroa.6.0.vector.sroa_idx.i.i, align 8, !noalias !5188
  call void @llvm.experimental.noalias.scope.decl(metadata !5207)
  call void @llvm.experimental.noalias.scope.decl(metadata !5210)
  br label %bb1.i.i.i.i

bb1.i.i.i.i:                                      ; preds = %bb8.i.i.i.i, %_RNvMs5_NtCsgFX3jaOk65H_5alloc7raw_vecNtB5_11RawVecInner16with_capacity_inCs8b9n3vPMt31_13blake3_servil.exit.i.i
  %_23.i.i15.i.i = phi ptr [ %_23.i.i.i.i, %bb8.i.i.i.i ], [ %260, %_RNvMs5_NtCsgFX3jaOk65H_5alloc7raw_vecNtB5_11RawVecInner16with_capacity_inCs8b9n3vPMt31_13blake3_servil.exit.i.i ]
  %plain.sroa.10.0.copyload.i = phi i64 [ %new_len.i.i.i.i, %bb8.i.i.i.i ], [ 1, %_RNvMs5_NtCsgFX3jaOk65H_5alloc7raw_vecNtB5_11RawVecInner16with_capacity_inCs8b9n3vPMt31_13blake3_servil.exit.i.i ]
  %_16.i.i.i.i.i9.i.i.i.i = phi ptr [ %_16.i.i.i.i.i.i.i.i.i, %bb8.i.i.i.i ], [ %_16.i.i.i.i.i.i8.i, %_RNvMs5_NtCsgFX3jaOk65H_5alloc7raw_vecNtB5_11RawVecInner16with_capacity_inCs8b9n3vPMt31_13blake3_servil.exit.i.i ]
  br label %bb1.i.i.i.i.i.i.i.i

bb1.i.i.i.i.i.i.i.i:                              ; preds = %_RNCINvNtNtNtCskADBYZwJmSU_4core4iter8adapters6copied13copy_try_foldjuINtNtNtBa_3ops12control_flow11ControlFlowjENCINvNvNtNtNtB8_6traits8iterator8Iterator4find5checkjQNCNvNtCs8b9n3vPMt31_13blake3_servil4each9hash_helds_0E0E0B2K_.exit.i.i.i.i.i.i.i.i, %bb1.i.i.i.i
  %_16.i4.i.i.i.i.i.i.i.i = phi ptr [ %_16.i.i.i.i.i.i.i.i.i, %_RNCINvNtNtNtCskADBYZwJmSU_4core4iter8adapters6copied13copy_try_foldjuINtNtNtBa_3ops12control_flow11ControlFlowjENCINvNvNtNtNtB8_6traits8iterator8Iterator4find5checkjQNCNvNtCs8b9n3vPMt31_13blake3_servil4each9hash_helds_0E0E0B2K_.exit.i.i.i.i.i.i.i.i ], [ %_16.i.i.i.i.i9.i.i.i.i, %bb1.i.i.i.i ]
  %_6.i.i.i.not.not.not.not.i.not.not.not.i.not.i.i.i.i = icmp eq ptr %_16.i4.i.i.i.i.i.i.i.i, %_41.i
  br i1 %_6.i.i.i.not.not.not.not.i.not.not.not.i.not.i.i.i.i, label %bb9.i43, label %bb3.i.i.i.i.i.i.i.i

bb3.i.i.i.i.i.i.i.i:                              ; preds = %bb1.i.i.i.i.i.i.i.i
  %.val.i.i.i.i.i.i.i.i = load i64, ptr %_16.i4.i.i.i.i.i.i.i.i, align 8, !alias.scope !4985, !noalias !5213, !noundef !566
  %_6.i.i.i.i.i.i.i.i.i.i.i.i = icmp ult i64 %.val.i.i.i.i.i.i.i.i, %hashers.1
  br i1 %_6.i.i.i.i.i.i.i.i.i.i.i.i, label %_RNCINvNtNtNtCskADBYZwJmSU_4core4iter8adapters6copied13copy_try_foldjuINtNtNtBa_3ops12control_flow11ControlFlowjENCINvNvNtNtNtB8_6traits8iterator8Iterator4find5checkjQNCNvNtCs8b9n3vPMt31_13blake3_servil4each9hash_helds_0E0E0B2K_.exit.i.i.i.i.i.i.i.i, label %panic.i.i.i.i.i.i.i.i.i.i.i.i

panic.i.i.i.i.i.i.i.i.i.i.i.i:                    ; preds = %bb3.i.i.i.i.i.i.i.i
; invoke core::panicking::panic_bounds_check
  invoke void @_RNvNtCskADBYZwJmSU_4core9panicking18panic_bounds_check(i64 noundef %.val.i.i.i.i.i.i.i.i, i64 noundef range(i64 0, 500399958596722) %hashers.1, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(24) @alloc_761526eea504fb7d2dcacf55bdabfbaf) #44
          to label %.noexc.i15.i unwind label %cleanup.loopexit.split-lp.i.i, !noalias !5206

.noexc.i15.i:                                     ; preds = %panic.i.i.i.i.i.i.i.i.i.i.i.i
  unreachable

_RNCINvNtNtNtCskADBYZwJmSU_4core4iter8adapters6copied13copy_try_foldjuINtNtNtBa_3ops12control_flow11ControlFlowjENCINvNvNtNtNtB8_6traits8iterator8Iterator4find5checkjQNCNvNtCs8b9n3vPMt31_13blake3_servil4each9hash_helds_0E0E0B2K_.exit.i.i.i.i.i.i.i.i: ; preds = %bb3.i.i.i.i.i.i.i.i
  %_16.i.i.i.i.i.i.i.i.i = getelementptr inbounds nuw i8, ptr %_16.i4.i.i.i.i.i.i.i.i, i64 8
  %262 = getelementptr inbounds nuw [18432 x i8], ptr %hashers.0, i64 %.val.i.i.i.i.i.i.i.i
  %263 = getelementptr inbounds nuw i8, ptr %262, i64 106
  %_4.i.i.i.i.i.i.i.i.i.i.i.i = load i8, ptr %263, align 2, !alias.scope !4982, !noalias !5225, !noundef !566
  %_0.i.i.i.i.i.i.i.i.i.i.i.i = icmp eq i8 %_4.i.i.i.i.i.i.i.i.i.i.i.i, 0
  br i1 %_0.i.i.i.i.i.i.i.i.i.i.i.i, label %bb3.i.i5.i.i, label %bb1.i.i.i.i.i.i.i.i

bb3.i.i5.i.i:                                     ; preds = %_RNCINvNtNtNtCskADBYZwJmSU_4core4iter8adapters6copied13copy_try_foldjuINtNtNtBa_3ops12control_flow11ControlFlowjENCINvNvNtNtNtB8_6traits8iterator8Iterator4find5checkjQNCNvNtCs8b9n3vPMt31_13blake3_servil4each9hash_helds_0E0E0B2K_.exit.i.i.i.i.i.i.i.i
  %_19.i.i.i.i = icmp samesign ult i64 %plain.sroa.10.0.copyload.i, 1152921504606846976
  call void @llvm.assume(i1 %_19.i.i.i.i)
  %self1.i.i.i.i = load i64, ptr %vector.i.i, align 8, !range !567, !alias.scope !5226, !noalias !5227, !noundef !566
  %_8.i.i.i.i = icmp eq i64 %plain.sroa.10.0.copyload.i, %self1.i.i.i.i
  br i1 %_8.i.i.i.i, label %_RNvMs_NtCsgFX3jaOk65H_5alloc3vecINtB4_3VecjE7reserveCs8b9n3vPMt31_13blake3_servil.exit.i.i.i.i, label %bb8.i.i.i.i

_RNvMs_NtCsgFX3jaOk65H_5alloc3vecINtB4_3VecjE7reserveCs8b9n3vPMt31_13blake3_servil.exit.i.i.i.i: ; preds = %bb3.i.i5.i.i
; invoke <alloc::raw_vec::RawVecInner<_>>::reserve::do_reserve_and_handle::<alloc::alloc::Global>
  invoke fastcc void @_RINvNvMs2_NtCsgFX3jaOk65H_5alloc7raw_vecINtB8_11RawVecInnerpE7reserve21do_reserve_and_handleNtNtBa_5alloc6GlobalECs8b9n3vPMt31_13blake3_servil(ptr noalias nofree noundef nonnull align 8 dereferenceable(24) %vector.i.i, i64 noundef %plain.sroa.10.0.copyload.i, i64 noundef 1, i64 noundef 8, i64 noundef 8)
          to label %_RNvMs_NtCsgFX3jaOk65H_5alloc3vecINtB4_3VecjE7reserveCs8b9n3vPMt31_13blake3_servil.exit.i.i.bb8.i.i_crit_edge.i.i unwind label %cleanup.loopexit.i.i, !noalias !5206

_RNvMs_NtCsgFX3jaOk65H_5alloc3vecINtB4_3VecjE7reserveCs8b9n3vPMt31_13blake3_servil.exit.i.i.bb8.i.i_crit_edge.i.i: ; preds = %_RNvMs_NtCsgFX3jaOk65H_5alloc3vecINtB4_3VecjE7reserveCs8b9n3vPMt31_13blake3_servil.exit.i.i.i.i
  %_23.i.i.pre.i.i = load ptr, ptr %vector1.sroa.4.0.vector.sroa_idx.i.i, align 8, !alias.scope !5226, !noalias !5227
  br label %bb8.i.i.i.i

bb8.i.i.i.i:                                      ; preds = %_RNvMs_NtCsgFX3jaOk65H_5alloc3vecINtB4_3VecjE7reserveCs8b9n3vPMt31_13blake3_servil.exit.i.i.bb8.i.i_crit_edge.i.i, %bb3.i.i5.i.i
  %_23.i.i.i.i = phi ptr [ %_23.i.i.pre.i.i, %_RNvMs_NtCsgFX3jaOk65H_5alloc3vecINtB4_3VecjE7reserveCs8b9n3vPMt31_13blake3_servil.exit.i.i.bb8.i.i_crit_edge.i.i ], [ %_23.i.i15.i.i, %bb3.i.i5.i.i ]
  %dst.i.i.i.i = getelementptr inbounds nuw [8 x i8], ptr %_23.i.i.i.i, i64 %plain.sroa.10.0.copyload.i
  store i64 %.val.i.i.i.i.i.i.i.i, ptr %dst.i.i.i.i, align 8, !noalias !5228
  %new_len.i.i.i.i = add nuw nsw i64 %plain.sroa.10.0.copyload.i, 1
  store i64 %new_len.i.i.i.i, ptr %vector1.sroa.6.0.vector.sroa_idx.i.i, align 8, !alias.scope !5226, !noalias !5227
  br label %bb1.i.i.i.i

cleanup.loopexit.i.i:                             ; preds = %_RNvMs_NtCsgFX3jaOk65H_5alloc3vecINtB4_3VecjE7reserveCs8b9n3vPMt31_13blake3_servil.exit.i.i.i.i
  %lpad.loopexit.i16.i = landingpad { ptr, i32 }
          cleanup
  br label %cleanup.i11.i

cleanup.loopexit.split-lp.i.i:                    ; preds = %panic.i.i.i.i.i.i.i.i.i.i.i.i
  %lpad.loopexit.split-lp.i10.i = landingpad { ptr, i32 }
          cleanup
  br label %cleanup.i11.i

cleanup.i11.i:                                    ; preds = %cleanup.loopexit.split-lp.i.i, %cleanup.loopexit.i.i
  %lpad.phi.i12.i = phi { ptr, i32 } [ %lpad.loopexit.i16.i, %cleanup.loopexit.i.i ], [ %lpad.loopexit.split-lp.i10.i, %cleanup.loopexit.split-lp.i.i ]
  %vector.val.i.i = load i64, ptr %vector.i.i, align 8, !noalias !5188
  %264 = icmp eq i64 %vector.val.i.i, 0
  br i1 %264, label %cleanup.body, label %bb2.i.i.i4.i.i.i

bb2.i.i.i4.i.i.i:                                 ; preds = %cleanup.i11.i
  %vector.val3.i.i = load ptr, ptr %vector1.sroa.4.0.vector.sroa_idx.i.i, align 8, !noalias !5188, !nonnull !566, !noundef !566
  %alloc_size.i.i.i.i5.i.i13.i = shl nuw i64 %vector.val.i.i, 3
; call __rustc::__rust_dealloc
  call void @_RNvCs5fGHjzWXRav_7___rustc14___rust_dealloc(ptr noundef nonnull %vector.val3.i.i, i64 noundef %alloc_size.i.i.i.i5.i.i13.i, i64 noundef range(i64 1, -9223372036854775807) 8) #36, !noalias !5206
  br label %cleanup.body

bb9.i43:                                          ; preds = %bb1.i.i.i.i.i.i.i.i
  %plain.sroa.0.0.copyload.i = load i64, ptr %vector.i.i, align 8, !noalias !5229
  %plain.sroa.6.0.copyload.i = load ptr, ptr %vector1.sroa.4.0.vector.sroa_idx.i.i, align 8, !noalias !5229
  call void @llvm.lifetime.end.p0(ptr nonnull %vector.i.i), !noalias !5188
  %_55.i = icmp samesign ult i64 %plain.sroa.10.0.copyload.i, 1152921504606846976
  call void @llvm.assume(i1 %_55.i)
; invoke blake3_servil::each::hash_cohort
  invoke fastcc void @_RNvNtCs8b9n3vPMt31_13blake3_servil4each11hash_cohort(ptr noalias nofree noundef nonnull align 64 %hashers.0, i64 noundef range(i64 0, 500399958596722) %hashers.1, ptr noalias nofree noundef nonnull readonly align 8 captures(address, read_provenance) %plain.sroa.6.0.copyload.i, i64 noundef %plain.sroa.10.0.copyload.i)
          to label %bb27.preheader.i unwind label %cleanup.loopexit.split-lp.i.loopexit, !noalias !4985

bb27.preheader.i:                                 ; preds = %bb9.i43, %_RNvXNtNtCsgFX3jaOk65H_5alloc3vec21spec_from_iter_nestedINtB4_3VecjEINtB2_18SpecFromIterNestedjINtNtNtNtCskADBYZwJmSU_4core4iter8adapters6filter6FilterINtNtB1z_6copied6CopiedINtNtNtB1D_5slice4iter4IterjEENCNvNtCs8b9n3vPMt31_13blake3_servil4each9hash_helds_0EE9from_iterB3l_.exit.thread.i
  %plain.sroa.0.029.i = phi i64 [ 0, %_RNvXNtNtCsgFX3jaOk65H_5alloc3vec21spec_from_iter_nestedINtB4_3VecjEINtB2_18SpecFromIterNestedjINtNtNtNtCskADBYZwJmSU_4core4iter8adapters6filter6FilterINtNtB1z_6copied6CopiedINtNtNtB1D_5slice4iter4IterjEENCNvNtCs8b9n3vPMt31_13blake3_servil4each9hash_helds_0EE9from_iterB3l_.exit.thread.i ], [ %plain.sroa.0.0.copyload.i, %bb9.i43 ]
  %plain.sroa.6.027.i = phi ptr [ inttoptr (i64 8 to ptr), %_RNvXNtNtCsgFX3jaOk65H_5alloc3vec21spec_from_iter_nestedINtB4_3VecjEINtB2_18SpecFromIterNestedjINtNtNtNtCskADBYZwJmSU_4core4iter8adapters6filter6FilterINtNtB1z_6copied6CopiedINtNtNtB1D_5slice4iter4IterjEENCNvNtCs8b9n3vPMt31_13blake3_servil4each9hash_helds_0EE9from_iterB3l_.exit.thread.i ], [ %plain.sroa.6.0.copyload.i, %bb9.i43 ]
  br label %bb27.i

cleanup.loopexit.i:                               ; preds = %bb14.i
  %lpad.loopexit.i = landingpad { ptr, i32 }
          cleanup
  br label %cleanup.i

cleanup.loopexit.split-lp.i.loopexit:             ; preds = %bb9.i43
  %lpad.loopexit198 = landingpad { ptr, i32 }
          cleanup
  br label %cleanup.i

cleanup.loopexit.split-lp.i.loopexit.split-lp:    ; preds = %panic1.i
  %lpad.loopexit.split-lp = landingpad { ptr, i32 }
          cleanup
  br label %cleanup.i

cleanup.i:                                        ; preds = %cleanup.loopexit.split-lp.i.loopexit, %cleanup.loopexit.split-lp.i.loopexit.split-lp, %cleanup.loopexit.i
  %plain.sroa.0.030.i = phi i64 [ %plain.sroa.0.029.i, %cleanup.loopexit.i ], [ %plain.sroa.0.0.copyload.i, %cleanup.loopexit.split-lp.i.loopexit ], [ %plain.sroa.0.029.i, %cleanup.loopexit.split-lp.i.loopexit.split-lp ]
  %plain.sroa.6.028.i = phi ptr [ %plain.sroa.6.027.i, %cleanup.loopexit.i ], [ %plain.sroa.6.0.copyload.i, %cleanup.loopexit.split-lp.i.loopexit ], [ %plain.sroa.6.027.i, %cleanup.loopexit.split-lp.i.loopexit.split-lp ]
  %lpad.phi.i = phi { ptr, i32 } [ %lpad.loopexit.i, %cleanup.loopexit.i ], [ %lpad.loopexit198, %cleanup.loopexit.split-lp.i.loopexit ], [ %lpad.loopexit.split-lp, %cleanup.loopexit.split-lp.i.loopexit.split-lp ]
  %265 = icmp eq i64 %plain.sroa.0.030.i, 0
  br i1 %265, label %cleanup.body, label %bb2.i.i.i4.i.i

bb2.i.i.i4.i.i:                                   ; preds = %cleanup.i
  %alloc_size.i.i.i.i5.i.i = shl nuw i64 %plain.sroa.0.030.i, 3
  call void @llvm.assume(i1 true) [ "nonnull"(ptr %plain.sroa.6.028.i) ]
; call __rustc::__rust_dealloc
  call void @_RNvCs5fGHjzWXRav_7___rustc14___rust_dealloc(ptr noundef nonnull %plain.sroa.6.028.i, i64 noundef %alloc_size.i.i.i.i5.i.i, i64 noundef range(i64 1, -9223372036854775807) 8) #36, !noalias !4985
  br label %cleanup.body

bb27.i:                                           ; preds = %bb17.i, %bb27.preheader.i
  %iter.sroa.0.0241.i = phi ptr [ %_76.i, %bb17.i ], [ %_138, %bb27.preheader.i ]
  %_76.i = getelementptr inbounds nuw i8, ptr %iter.sroa.0.0241.i, i64 8
  %i.i = load i64, ptr %iter.sroa.0.0241.i, align 8, !alias.scope !4985, !noalias !4982, !noundef !566
  %_28.i = icmp ult i64 %i.i, %hashers.1
  br i1 %_28.i, label %bb13.i44, label %panic1.i

bb26.i:                                           ; preds = %bb17.i
  %266 = icmp eq i64 %plain.sroa.0.029.i, 0
  br i1 %266, label %bb46, label %bb2.i.i.i4.i18.i

bb2.i.i.i4.i18.i:                                 ; preds = %bb26.i
  %alloc_size.i.i.i.i5.i19.i = shl nuw i64 %plain.sroa.0.029.i, 3
  call void @llvm.assume(i1 true) [ "nonnull"(ptr %plain.sroa.6.027.i) ]
; call __rustc::__rust_dealloc
  call void @_RNvCs5fGHjzWXRav_7___rustc14___rust_dealloc(ptr noundef nonnull %plain.sroa.6.027.i, i64 noundef %alloc_size.i.i.i.i5.i19.i, i64 noundef range(i64 1, -9223372036854775807) 8) #36, !noalias !4985
  br label %bb46

bb13.i44:                                         ; preds = %bb27.i
  %267 = getelementptr inbounds nuw [18432 x i8], ptr %hashers.0, i64 %i.i
  %268 = getelementptr inbounds nuw i8, ptr %267, i64 106
  %_27.i45 = load i8, ptr %268, align 2, !alias.scope !4982, !noalias !4985, !noundef !566
  %269 = icmp eq i8 %_27.i45, 0
  br i1 %269, label %bb17.i, label %bb14.i

panic1.i:                                         ; preds = %bb27.i
; invoke core::panicking::panic_bounds_check
  invoke void @_RNvNtCskADBYZwJmSU_4core9panicking18panic_bounds_check(i64 noundef %i.i, i64 noundef range(i64 0, 500399958596722) %hashers.1, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(24) @alloc_39189fb403679a5276c78229ccd6a369) #41
          to label %unreachable.i unwind label %cleanup.loopexit.split-lp.i.loopexit.split-lp, !noalias !4985

unreachable.i:                                    ; preds = %panic1.i
  unreachable

bb14.i:                                           ; preds = %bb13.i44
  call void @llvm.lifetime.start.p0(ptr nonnull %_32.i), !noalias !5230
  store i64 %i.i, ptr %_32.i, align 8, !noalias !5230
; invoke blake3_servil::each::hash_cohort
  invoke fastcc void @_RNvNtCs8b9n3vPMt31_13blake3_servil4each11hash_cohort(ptr noalias nofree noundef nonnull align 64 %hashers.0, i64 noundef range(i64 0, 500399958596722) %hashers.1, ptr noalias nofree noundef nonnull readonly align 8 captures(address, read_provenance) %_32.i, i64 noundef 1)
          to label %bb15.i unwind label %cleanup.loopexit.i, !noalias !4985

bb17.i:                                           ; preds = %bb15.i, %bb13.i44
  %_70.i = icmp eq ptr %_76.i, %_41.i
  br i1 %_70.i, label %bb26.i, label %bb27.i

bb15.i:                                           ; preds = %bb14.i
  call void @llvm.lifetime.end.p0(ptr nonnull %_32.i), !noalias !5230
  br label %bb17.i

bb33:                                             ; preds = %bb72
  %_36 = getelementptr inbounds nuw [18432 x i8], ptr %hashers.0, i64 %i
  %270 = getelementptr inbounds nuw i8, ptr %_36, i64 18368
  %_3.i = load i64, ptr %270, align 64, !alias.scope !5231, !noundef !566
  %271 = icmp eq i64 %_3.i, 16384
  %272 = getelementptr inbounds nuw i8, ptr %_36, i64 1936
  %_4.i54 = load i64, ptr %272, align 16, !alias.scope !5231
  %_2.i = icmp eq i64 %_4.i54, 0
  %or.cond.i55 = select i1 %271, i1 %_2.i, i1 false
  br i1 %or.cond.i55, label %bb35, label %bb37

panic3:                                           ; preds = %bb72
; invoke core::panicking::panic_bounds_check
  invoke void @_RNvNtCskADBYZwJmSU_4core9panicking18panic_bounds_check(i64 noundef %i, i64 noundef %hashers.1, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(24) @alloc_436811f89573f80048cdcaf8d81a96ae) #41
          to label %unreachable unwind label %cleanup.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp

cleanup.loopexit:                                 ; preds = %bb26.i86
  %lpad.loopexit = landingpad { ptr, i32 }
          cleanup
  br label %cleanup.body

cleanup.loopexit.split-lp.loopexit:               ; preds = %bb1.i128, %bb1.i120, %bb11.i, %bb1.i67
  %lpad.loopexit195 = landingpad { ptr, i32 }
          cleanup
  br label %cleanup.body

cleanup.loopexit.split-lp.loopexit.split-lp.loopexit: ; preds = %bb2.i48
  %lpad.loopexit200 = landingpad { ptr, i32 }
          cleanup
  br label %cleanup.body

cleanup.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp: ; preds = %bb3.i.i.i.i.invoke, %panic.i.i.i.invoke, %bb49.invoke, %panic3, %bb2.i.i92
  %lpad.loopexit.split-lp201 = landingpad { ptr, i32 }
          cleanup
  br label %cleanup.body

cleanup.body:                                     ; preds = %cleanup.loopexit, %cleanup.loopexit.split-lp.loopexit.split-lp.loopexit, %cleanup.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp, %cleanup.loopexit.split-lp.loopexit, %bb50.i.i, %cleanup.i11.i, %bb2.i.i.i4.i.i.i, %cleanup.i, %bb2.i.i.i4.i.i
  %eh.lpad-body = phi { ptr, i32 } [ %lpad.phi.i, %cleanup.i ], [ %.pn37.i.i, %bb50.i.i ], [ %lpad.phi.i12.i, %cleanup.i11.i ], [ %lpad.phi.i12.i, %bb2.i.i.i4.i.i.i ], [ %lpad.phi.i, %bb2.i.i.i4.i.i ], [ %lpad.loopexit, %cleanup.loopexit ], [ %lpad.loopexit195, %cleanup.loopexit.split-lp.loopexit ], [ %lpad.loopexit200, %cleanup.loopexit.split-lp.loopexit.split-lp.loopexit ], [ %lpad.loopexit.split-lp201, %cleanup.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp ]
  %held.val31 = load i64, ptr %held, align 8
  %273 = icmp eq i64 %held.val31, 0
  br i1 %273, label %bb61, label %bb2.i.i.i4.i62

bb2.i.i.i4.i62:                                   ; preds = %cleanup.body
  %held.val32 = load ptr, ptr %36, align 8, !nonnull !566, !noundef !566
  %alloc_size.i.i.i.i5.i63 = shl nuw i64 %held.val31, 3
; call __rustc::__rust_dealloc
  call void @_RNvCs5fGHjzWXRav_7___rustc14___rust_dealloc(ptr noundef nonnull %held.val32, i64 noundef %alloc_size.i.i.i.i5.i63, i64 noundef range(i64 1, -9223372036854775807) 8) #36
  br label %bb61

unreachable:                                      ; preds = %panic3
  unreachable

bb35:                                             ; preds = %bb33
  %len.i = load i64, ptr %35, align 8, !alias.scope !5234, !noalias !5237, !noundef !566
  %self1.i = load i64, ptr %waiting, align 8, !range !567, !alias.scope !5234, !noalias !5237, !noundef !566
  %_4.i65 = icmp eq i64 %len.i, %self1.i
  br i1 %_4.i65, label %bb1.i67, label %bb31.backedge.sink.split

bb1.i67:                                          ; preds = %bb35
; invoke <alloc::raw_vec::RawVec<blake3_servil::stream::receiver::Buffer>>::grow_one
  invoke void @_RNvMs4_NtCsgFX3jaOk65H_5alloc7raw_vecINtB5_6RawVecNtNtNtCs8b9n3vPMt31_13blake3_servil6stream8receiver6BufferE8grow_oneBS_(ptr noalias nofree noundef nonnull align 8 dereferenceable(24) %waiting) #40
          to label %bb31.backedge.sink.split unwind label %cleanup.loopexit.split-lp.loopexit

bb37:                                             ; preds = %bb33
  call void @llvm.experimental.noalias.scope.decl(metadata !5239)
  call void @llvm.experimental.noalias.scope.decl(metadata !5242)
  %274 = getelementptr inbounds nuw i8, ptr %_36, i64 96
  %_7.i.i70 = load i64, ptr %274, align 32, !alias.scope !5244, !noalias !5242, !noundef !566
  %275 = getelementptr inbounds nuw i8, ptr %_36, i64 105
  %_13.i.i72 = load i8, ptr %275, align 1, !alias.scope !5244, !noalias !5242, !noundef !566
  %276 = getelementptr inbounds nuw i8, ptr %_36, i64 104
  %_15.i.i74 = load i8, ptr %276, align 8, !alias.scope !5244, !noalias !5242, !noundef !566
  call void @llvm.lifetime.start.p0(ptr nonnull %input_offset.i.i), !noalias !5247
  %277 = shl i64 %_4.i54, 10
  store i64 %277, ptr %input_offset.i.i, align 8, !noalias !5247
  %278 = icmp eq i64 %277, 0
  br i1 %278, label %_RNvMs1_NtCs8b9n3vPMt31_13blake3_servil11incrementalNtB5_10HasherCore11assert_room.exit.i, label %bb6.i.i77

bb6.i.i77:                                        ; preds = %bb37
  %_6.i.i = sub i64 %_7.i.i70, %_4.i54
  %_5.i.i = shl i64 %_6.i.i, 10
  %_10.i.i = add i64 %_5.i.i, %_3.i
  %_14.i.i75 = zext i8 %_15.i.i74 to i64
  %_2.i.i = add i64 %_10.i.i, %_14.i.i75
  %_12.i.i73 = zext i8 %_13.i.i72 to i64
  %_11.i.i = shl nuw nsw i64 %_12.i.i73, 6
  %_0.i.i = add i64 %_2.i.i, %_11.i.i
  %_251.i.i = and i64 %_4.i54, 18014398509481983
  %279 = call range(i64 0, 65) i64 @llvm.cttz.i64(i64 %_251.i.i, i1 false)
  %280 = and i64 %279, 63
  %_28.i.i78 = shl i64 1024, %280
  call void @llvm.lifetime.start.p0(ptr nonnull %max.i.i), !noalias !5247
  store i64 %_28.i.i78, ptr %max.i.i, align 8, !noalias !5247
  %_10.i12.i = sub i64 %_28.i.i78, %_0.i.i
  %_8.not.i.i = icmp ugt i64 %bytes.1, %_10.i12.i
  br i1 %_8.not.i.i, label %bb2.i.i92, label %bb1.i.i79, !prof !575

bb2.i.i92:                                        ; preds = %bb6.i.i77
  call void @llvm.lifetime.start.p0(ptr nonnull %_16.i.i69), !noalias !5247
  %281 = add i64 %_0.i.i, %bytes.1
  store i64 %281, ptr %_16.i.i69, align 8, !noalias !5247
  call void @llvm.lifetime.start.p0(ptr nonnull %args.i.i), !noalias !5247
  store ptr %input_offset.i.i, ptr %args.i.i, align 8, !noalias !5247
  %_18.sroa.4.0..sroa_idx.i.i = getelementptr inbounds nuw i8, ptr %args.i.i, i64 8
  store ptr @_RNvXsd_NtNtNtCskADBYZwJmSU_4core3fmt3num3impyNtB9_7Display3fmt, ptr %_18.sroa.4.0..sroa_idx.i.i, align 8, !noalias !5247
  %282 = getelementptr inbounds nuw i8, ptr %args.i.i, i64 16
  store ptr %max.i.i, ptr %282, align 8, !noalias !5247
  %_19.sroa.4.0..sroa_idx.i.i = getelementptr inbounds nuw i8, ptr %args.i.i, i64 24
  store ptr @_RNvXsd_NtNtNtCskADBYZwJmSU_4core3fmt3num3impyNtB9_7Display3fmt, ptr %_19.sroa.4.0..sroa_idx.i.i, align 8, !noalias !5247
  %283 = getelementptr inbounds nuw i8, ptr %args.i.i, i64 32
  store ptr %_16.i.i69, ptr %283, align 8, !noalias !5247
  %_20.sroa.4.0..sroa_idx.i.i = getelementptr inbounds nuw i8, ptr %args.i.i, i64 40
  store ptr @_RNvXsd_NtNtNtCskADBYZwJmSU_4core3fmt3num3impyNtB9_7Display3fmt, ptr %_20.sroa.4.0..sroa_idx.i.i, align 8, !noalias !5247
; invoke core::panicking::panic_fmt
  invoke void @_RNvNtCskADBYZwJmSU_4core9panicking9panic_fmt(ptr noundef nonnull @alloc_6b98f920f19f1d674efab5f955180c77, ptr noundef nonnull %args.i.i, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(24) @alloc_d68b221d7754d18f1ad4b317f3e54117) #44
          to label %.noexc93 unwind label %cleanup.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp

.noexc93:                                         ; preds = %bb2.i.i92
  unreachable

bb1.i.i79:                                        ; preds = %bb6.i.i77
  call void @llvm.lifetime.end.p0(ptr nonnull %max.i.i), !noalias !5247
  br label %_RNvMs1_NtCs8b9n3vPMt31_13blake3_servil11incrementalNtB5_10HasherCore11assert_room.exit.i

_RNvMs1_NtCs8b9n3vPMt31_13blake3_servil11incrementalNtB5_10HasherCore11assert_room.exit.i: ; preds = %bb1.i.i79, %bb37
  call void @llvm.lifetime.end.p0(ptr nonnull %input_offset.i.i), !noalias !5247
  %_1146.i = icmp eq i64 %bytes.1, 0
  br i1 %_1146.i, label %bb38, label %bb5.lr.ph.i

bb5.lr.ph.i:                                      ; preds = %_RNvMs1_NtCs8b9n3vPMt31_13blake3_servil11incrementalNtB5_10HasherCore11assert_room.exit.i
  %_7.i35.i = getelementptr inbounds nuw i8, ptr %_36, i64 1984
  br label %bb5.i80

bb5.i80:                                          ; preds = %_52.i.noexc, %bb5.lr.ph.i
  %input.sroa.0.048.i = phi ptr [ %bytes.0, %bb5.lr.ph.i ], [ %_79.i, %_52.i.noexc ]
  %input.sroa.12.047.i = phi i64 [ %bytes.1, %bb5.lr.ph.i ], [ %_75.i, %_52.i.noexc ]
  %_13.i81 = load i64, ptr %270, align 64, !alias.scope !5239, !noalias !5242, !noundef !566
  %284 = icmp eq i64 %_13.i81, 0
  br i1 %284, label %bb6.i, label %bb5.bb32_crit_edge.i

bb5.bb32_crit_edge.i:                             ; preds = %bb5.i80
  %_29.pre.i = load i64, ptr %272, align 16, !alias.scope !5239, !noalias !5242
  %_7.i22.pre.i = load i64, ptr %274, align 32, !alias.scope !5248, !noalias !5242
  %_13.i26.pre.i = load i8, ptr %275, align 1, !alias.scope !5248, !noalias !5242
  %_15.i29.pre.i = load i8, ptr %276, align 8, !alias.scope !5248, !noalias !5242
  %.pre.i = zext i8 %_13.i26.pre.i to i64
  %.pre60.i = shl nuw nsw i64 %.pre.i, 6
  %.pre61.i = zext i8 %_15.i29.pre.i to i64
  br label %bb32.i

bb6.i:                                            ; preds = %bb5.i80
  %_14.i89 = icmp ugt i64 %input.sroa.12.047.i, 16383
  br i1 %_14.i89, label %bb11.i, label %bb8.i90

bb8.i90:                                          ; preds = %bb6.i
  %_4.i13.i = load i64, ptr %274, align 32, !alias.scope !5251, !noalias !5242, !noundef !566
  %_5.i14.i = load i64, ptr %272, align 16, !alias.scope !5251, !noalias !5242, !noundef !566
  %_3.i.i = sub i64 %_4.i13.i, %_5.i14.i
  %_2.i15.i = shl i64 %_3.i.i, 10
  %_10.i16.i = load i8, ptr %275, align 1, !alias.scope !5251, !noalias !5242, !noundef !566
  %_9.i.i91 = zext i8 %_10.i16.i to i64
  %_8.i17.i = shl nuw nsw i64 %_9.i.i91, 6
  %_12.i18.i = load i8, ptr %276, align 8, !alias.scope !5251, !noalias !5242, !noundef !566
  %_11.i19.i = zext i8 %_12.i18.i to i64
  %_7.i20.i = add i64 %_2.i15.i, %input.sroa.12.047.i
  %_0.i21.i = add i64 %_7.i20.i, %_11.i19.i
  %_18.i = add i64 %_0.i21.i, %_8.i17.i
  %_17.i = icmp ult i64 %_18.i, 1025
  br i1 %_17.i, label %bb11.i, label %bb32.i

bb11.i:                                           ; preds = %bb8.i90, %bb6.i
; invoke <blake3_servil::incremental::HasherCore>::update_pooled
  %_24.i94 = invoke fastcc noundef nonnull align 64 ptr @_RNvMs1_NtCs8b9n3vPMt31_13blake3_servil11incrementalNtB5_10HasherCore13update_pooled(ptr noalias nofree noundef nonnull align 64 dereferenceable(18432) %_36, ptr noalias nofree noundef nonnull readonly captures(address, read_provenance) %input.sroa.0.048.i, i64 noundef %input.sroa.12.047.i, i1 noundef zeroext %pooled)
          to label %bb38 unwind label %cleanup.loopexit.split-lp.loopexit

bb32.i:                                           ; preds = %bb8.i90, %bb5.bb32_crit_edge.i
  %_14.i30.pre-phi.i = phi i64 [ %.pre61.i, %bb5.bb32_crit_edge.i ], [ %_11.i19.i, %bb8.i90 ]
  %_11.i28.pre-phi.i = phi i64 [ %.pre60.i, %bb5.bb32_crit_edge.i ], [ %_8.i17.i, %bb8.i90 ]
  %_7.i22.i = phi i64 [ %_7.i22.pre.i, %bb5.bb32_crit_edge.i ], [ %_4.i13.i, %bb8.i90 ]
  %_29.i82 = phi i64 [ %_29.pre.i, %bb5.bb32_crit_edge.i ], [ %_5.i14.i, %bb8.i90 ]
  %285 = shl i64 %_7.i22.i, 10
  %_2.i33.i = add i64 %_14.i30.pre-phi.i, %_13.i81
  %_0.i34.i = add i64 %_2.i33.i, %_11.i28.pre-phi.i
  %_27.i83 = add i64 %_0.i34.i, %285
  %at.i = and i64 %_27.i83, 16383
  %to_boundary.i = sub nuw nsw i64 16384, %at.i
  %..i.i84 = call noundef i64 @llvm.umin.i64(i64 %input.sroa.12.047.i, i64 %to_boundary.i)
  call void @llvm.experimental.noalias.scope.decl(metadata !5254)
  %_4.i37.i = getelementptr inbounds nuw i8, ptr %_7.i35.i, i64 %_13.i81
  call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 1 %_4.i37.i, ptr nonnull readonly align 1 %input.sroa.0.048.i, i64 range(i64 0, -9223372036854775808) %..i.i84, i1 false), !alias.scope !5257, !noalias !5262
  %286 = load i64, ptr %270, align 64, !alias.scope !5264, !noalias !5265, !noundef !566
  %287 = add i64 %..i.i84, %286
  store i64 %287, ptr %270, align 64, !alias.scope !5264, !noalias !5265
  %_75.i = sub nuw nsw i64 %input.sroa.12.047.i, %..i.i84
  %_79.i = getelementptr inbounds nuw i8, ptr %input.sroa.0.048.i, i64 %..i.i84
  %_43.i = icmp ult i64 %input.sroa.12.047.i, %to_boundary.i
  br i1 %_43.i, label %bb38, label %bb21.i85

bb21.i85:                                         ; preds = %bb32.i
  %288 = icmp eq i64 %287, 16384
  %_2.i40.i = icmp eq i64 %_29.i82, 0
  %or.cond.i.i = and i1 %_2.i40.i, %288
  br i1 %or.cond.i.i, label %bb38, label %bb26.i86

bb26.i86:                                         ; preds = %bb21.i85
  store i64 0, ptr %270, align 64, !alias.scope !5239, !noalias !5242
; invoke <blake3_servil::incremental::HasherCore>::update_pooled
  %_52.i95 = invoke fastcc noundef nonnull align 64 ptr @_RNvMs1_NtCs8b9n3vPMt31_13blake3_servil11incrementalNtB5_10HasherCore13update_pooled(ptr noalias nofree noundef nonnull align 64 dereferenceable(18432) %_36, ptr noalias nofree noundef nonnull readonly captures(address, read_provenance) %_7.i35.i, i64 noundef %287, i1 noundef zeroext %pooled)
          to label %_52.i.noexc unwind label %cleanup.loopexit

_52.i.noexc:                                      ; preds = %bb26.i86
  %_11.i87 = icmp eq i64 %_75.i, 0
  br i1 %_11.i87, label %bb38, label %bb5.i80

bb38:                                             ; preds = %bb21.i85, %_52.i.noexc, %bb32.i, %_RNvMs1_NtCs8b9n3vPMt31_13blake3_servil11incrementalNtB5_10HasherCore11assert_room.exit.i, %bb11.i
  %_0.sroa.5.0.i = phi i64 [ 0, %bb11.i ], [ 0, %_RNvMs1_NtCs8b9n3vPMt31_13blake3_servil11incrementalNtB5_10HasherCore11assert_room.exit.i ], [ 0, %_52.i.noexc ], [ 0, %bb32.i ], [ %_75.i, %bb21.i85 ]
  %_0.sroa.0.0.i88 = phi ptr [ inttoptr (i64 1 to ptr), %bb11.i ], [ inttoptr (i64 1 to ptr), %_RNvMs1_NtCs8b9n3vPMt31_13blake3_servil11incrementalNtB5_10HasherCore11assert_room.exit.i ], [ inttoptr (i64 1 to ptr), %_52.i.noexc ], [ inttoptr (i64 1 to ptr), %bb32.i ], [ %_79.i, %bb21.i85 ]
  %_3.i96 = load i64, ptr %270, align 64, !alias.scope !5266, !noundef !566
  %289 = icmp eq i64 %_3.i96, 16384
  %_4.i97 = load i64, ptr %272, align 16, !alias.scope !5266
  %_2.i98 = icmp eq i64 %_4.i97, 0
  %or.cond.i99 = select i1 %289, i1 %_2.i98, i1 false
  br i1 %or.cond.i99, label %bb41, label %bb31.backedge

bb41:                                             ; preds = %bb38
  call void @llvm.experimental.noalias.scope.decl(metadata !5269)
  %len.i114 = load i64, ptr %37, align 8, !alias.scope !5269, !noundef !566
  %self1.i115 = load i64, ptr %held, align 8, !range !567, !alias.scope !5269, !noundef !566
  %_4.i116 = icmp eq i64 %len.i114, %self1.i115
  br i1 %_4.i116, label %bb1.i120, label %bb74

bb1.i120:                                         ; preds = %bb41
; invoke <alloc::raw_vec::RawVec<&[u8; 1024]>>::grow_one
  invoke void @_RNvMs4_NtCsgFX3jaOk65H_5alloc7raw_vecINtB5_6RawVecRAhj400_E8grow_oneCs8b9n3vPMt31_13blake3_servil(ptr noalias nofree noundef nonnull align 8 dereferenceable(24) %held) #40
          to label %bb74 unwind label %cleanup.loopexit.split-lp.loopexit

bb31.backedge.sink.split:                         ; preds = %bb1.i67, %bb35, %bb1.i128, %bb42
  %len.i122.sink2357 = phi i64 [ %len.i122, %bb1.i128 ], [ %len.i122, %bb42 ], [ %len.i, %bb35 ], [ %len.i, %bb1.i67 ]
  %_0.sroa.0.0.i88.sink = phi ptr [ %_0.sroa.0.0.i88, %bb1.i128 ], [ %_0.sroa.0.0.i88, %bb42 ], [ %bytes.0, %bb35 ], [ %bytes.0, %bb1.i67 ]
  %_0.sroa.5.0.i.sink = phi i64 [ %_0.sroa.5.0.i, %bb1.i128 ], [ %_0.sroa.5.0.i, %bb42 ], [ %bytes.1, %bb35 ], [ %bytes.1, %bb1.i67 ]
  %_14.i126 = load ptr, ptr %34, align 8, !noalias !566, !nonnull !566, !noundef !566
  %end.i127 = getelementptr inbounds nuw [24 x i8], ptr %_14.i126, i64 %len.i122.sink2357
  store i64 %i, ptr %end.i127, align 8, !noalias !566
  %_48.sroa.4.0.end.i127.sroa_idx = getelementptr inbounds nuw i8, ptr %end.i127, i64 8
  store ptr %_0.sroa.0.0.i88.sink, ptr %_48.sroa.4.0.end.i127.sroa_idx, align 8, !noalias !566
  %_48.sroa.5.0.end.i127.sroa_idx = getelementptr inbounds nuw i8, ptr %end.i127, i64 16
  store i64 %_0.sroa.5.0.i.sink, ptr %_48.sroa.5.0.end.i127.sroa_idx, align 8, !noalias !566
  %290 = add i64 %len.i122.sink2357, 1
  store i64 %290, ptr %35, align 8, !noalias !566
  br label %bb31.backedge

bb31.backedge:                                    ; preds = %bb31.backedge.sink.split, %bb74, %bb38
  %_127 = icmp eq ptr %_133, %_121
  br i1 %_127, label %bb71, label %bb72

bb74:                                             ; preds = %bb41, %bb1.i120
  %_14.i118 = load ptr, ptr %36, align 8, !alias.scope !5269, !nonnull !566, !noundef !566
  %end.i119 = getelementptr inbounds nuw [8 x i8], ptr %_14.i118, i64 %len.i114
  store i64 %i, ptr %end.i119, align 8, !noalias !5269
  %291 = add i64 %len.i114, 1
  store i64 %291, ptr %37, align 8, !alias.scope !5269
  %_46 = icmp eq i64 %_0.sroa.5.0.i, 0
  br i1 %_46, label %bb31.backedge, label %bb42

bb42:                                             ; preds = %bb74
  %len.i122 = load i64, ptr %35, align 8, !alias.scope !5272, !noalias !5275, !noundef !566
  %self1.i123 = load i64, ptr %waiting, align 8, !range !567, !alias.scope !5272, !noalias !5275, !noundef !566
  %_4.i124 = icmp eq i64 %len.i122, %self1.i123
  br i1 %_4.i124, label %bb1.i128, label %bb31.backedge.sink.split

bb1.i128:                                         ; preds = %bb42
; invoke <alloc::raw_vec::RawVec<blake3_servil::stream::receiver::Buffer>>::grow_one
  invoke void @_RNvMs4_NtCsgFX3jaOk65H_5alloc7raw_vecINtB5_6RawVecNtNtNtCs8b9n3vPMt31_13blake3_servil6stream8receiver6BufferE8grow_oneBS_(ptr noalias nofree noundef nonnull align 8 dereferenceable(24) %waiting) #40
          to label %bb31.backedge.sink.split unwind label %cleanup.loopexit.split-lp.loopexit

bb46:                                             ; preds = %bb2.i.i.i4.i18.i, %bb26.i, %_RNvNtCs8b9n3vPMt31_13blake3_servil10ffi_output11held_groups.exit.thread.i, %bb71, %bb2.i48
  %_148 = load ptr, ptr %36, align 8, !nonnull !566, !noundef !566
  %_147 = load i64, ptr %37, align 8, !noundef !566
  %_152.idx = shl nuw nsw i64 %_147, 3
  %_152 = getelementptr inbounds nuw i8, ptr %_148, i64 %_152.idx
  call void @llvm.experimental.noalias.scope.decl(metadata !5277)
  %_12.i1323065 = icmp eq i64 %_147, 0
  br i1 %_12.i1323065, label %bb8.i142.preheader, label %bb13.i133

bb8.i142.preheader:                               ; preds = %bb1.i131, %bb46
  %xtraiter = and i64 %turn.sroa.15.0942, 3
  %292 = icmp ult i64 %turn.sroa.15.0942, 4
  br i1 %292, label %bb8.i142.epil.preheader, label %bb8.i142.preheader.new

bb8.i142.preheader.new:                           ; preds = %bb8.i142.preheader
  %unroll_iter = and i64 %turn.sroa.15.0942, -4
  br label %bb8.i142

bb1.i131:                                         ; preds = %_RNCNvNtCs8b9n3vPMt31_13blake3_servil4each11update_turns0_0B5_.exit.i
  %_22.i = getelementptr inbounds nuw i8, ptr %_223.i3066, i64 8
  %_12.i132 = icmp eq ptr %_22.i, %_152
  br i1 %_12.i132, label %bb8.i142.preheader, label %bb13.i133

bb13.i133:                                        ; preds = %bb46, %bb1.i131
  %_223.i3066 = phi ptr [ %_22.i, %bb1.i131 ], [ %_148, %bb46 ]
  %ptr.val.i = load i64, ptr %_223.i3066, align 8, !noalias !5280, !noundef !566
  %_7.i.i134 = icmp ult i64 %ptr.val.i, %hashers.1
  br i1 %_7.i.i134, label %_RNCNvNtCs8b9n3vPMt31_13blake3_servil4each11update_turns0_0B5_.exit.i, label %panic.i.i.i.invoke

_RNCNvNtCs8b9n3vPMt31_13blake3_servil4each11update_turns0_0B5_.exit.i: ; preds = %bb13.i133
  %_5.i.i135 = getelementptr inbounds nuw [18432 x i8], ptr %hashers.0, i64 %ptr.val.i
  %293 = getelementptr inbounds nuw i8, ptr %_5.i.i135, i64 18368
  %_3.i.i.i136 = load i64, ptr %293, align 64, !alias.scope !5282, !noalias !5285, !noundef !566
  %294 = icmp ne i64 %_3.i.i.i136, 16384
  %295 = getelementptr inbounds nuw i8, ptr %_5.i.i135, i64 1936
  %_4.i.i.i137 = load i64, ptr %295, align 16, !alias.scope !5282, !noalias !5285
  %_2.i.i.i138 = icmp ne i64 %_4.i.i.i137, 0
  %or.cond.i.not.i.i = select i1 %294, i1 true, i1 %_2.i.i.i138
  br i1 %or.cond.i.not.i.i, label %bb1.i131, label %bb49.invoke

bb49.invoke:                                      ; preds = %_RNCNvNtCs8b9n3vPMt31_13blake3_servil4each11update_turns0_0B5_.exit.i, %bb54
  %296 = phi ptr [ @alloc_df756583130d24a66c3ad1ea98073635, %bb54 ], [ @alloc_8392ed28e0a4ac8ef9c30e39f457691d, %_RNCNvNtCs8b9n3vPMt31_13blake3_servil4each11update_turns0_0B5_.exit.i ]
  %297 = phi ptr [ %args, %bb54 ], [ inttoptr (i64 61 to ptr), %_RNCNvNtCs8b9n3vPMt31_13blake3_servil4each11update_turns0_0B5_.exit.i ]
  %298 = phi ptr [ @alloc_7b1de89b28765511d3fd5bac31809e1d, %bb54 ], [ @alloc_5cbdfbe7f6de7619a57cb9e0a9434552, %_RNCNvNtCs8b9n3vPMt31_13blake3_servil4each11update_turns0_0B5_.exit.i ]
; invoke core::panicking::panic_fmt
  invoke void @_RNvNtCskADBYZwJmSU_4core9panicking9panic_fmt(ptr noundef nonnull %296, ptr noundef nonnull %297, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(24) %298) #41
          to label %bb49.cont unwind label %cleanup.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp

bb49.cont:                                        ; preds = %bb49.invoke
  unreachable

bb8.i142:                                         ; preds = %bb8.i142, %bb8.i142.preheader.new
  %i.sroa.0.0.i = phi i64 [ 0, %bb8.i142.preheader.new ], [ %_27.i143.3, %bb8.i142 ]
  %acc.sroa.0.0.i = phi i64 [ 0, %bb8.i142.preheader.new ], [ %_4.0.i.i.i.3, %bb8.i142 ]
  %niter = phi i64 [ 0, %bb8.i142.preheader.new ], [ %niter.next.3, %bb8.i142 ]
  %_45.i = getelementptr inbounds nuw [24 x i8], ptr %turn.sroa.7.0943.in, i64 %i.sroa.0.0.i
  %299 = getelementptr i8, ptr %_45.i, i64 16
  %_45.val.i = load i64, ptr %299, align 8, !noundef !566
  %_4.0.i.i.i = add i64 %_45.val.i, %acc.sroa.0.0.i
  %300 = getelementptr inbounds nuw [24 x i8], ptr %turn.sroa.7.0943.in, i64 %i.sroa.0.0.i
  %301 = getelementptr i8, ptr %300, i64 40
  %_45.val.i.1 = load i64, ptr %301, align 8, !noundef !566
  %_4.0.i.i.i.1 = add i64 %_45.val.i.1, %_4.0.i.i.i
  %302 = getelementptr inbounds nuw [24 x i8], ptr %turn.sroa.7.0943.in, i64 %i.sroa.0.0.i
  %303 = getelementptr i8, ptr %302, i64 64
  %_45.val.i.2 = load i64, ptr %303, align 8, !noundef !566
  %_4.0.i.i.i.2 = add i64 %_45.val.i.2, %_4.0.i.i.i.1
  %304 = getelementptr inbounds nuw [24 x i8], ptr %turn.sroa.7.0943.in, i64 %i.sroa.0.0.i
  %305 = getelementptr i8, ptr %304, i64 88
  %_45.val.i.3 = load i64, ptr %305, align 8, !noundef !566
  %_4.0.i.i.i.3 = add i64 %_45.val.i.3, %_4.0.i.i.i.2
  %_27.i143.3 = add nuw i64 %i.sroa.0.0.i, 4
  %niter.next.3 = add i64 %niter, 4
  %niter.ncmp.3 = icmp eq i64 %niter.next.3, %unroll_iter
  br i1 %niter.ncmp.3, label %bb76.unr-lcssa, label %bb8.i142

bb76.unr-lcssa:                                   ; preds = %bb8.i142
  %lcmp.mod.not = icmp eq i64 %xtraiter, 0
  br i1 %lcmp.mod.not, label %bb76, label %bb8.i142.epil.preheader

bb8.i142.epil.preheader:                          ; preds = %bb76.unr-lcssa, %bb8.i142.preheader
  %i.sroa.0.0.i.epil.init = phi i64 [ 0, %bb8.i142.preheader ], [ %_27.i143.3, %bb76.unr-lcssa ]
  %acc.sroa.0.0.i.epil.init = phi i64 [ 0, %bb8.i142.preheader ], [ %_4.0.i.i.i.3, %bb76.unr-lcssa ]
  %lcmp.mod3572 = icmp ne i64 %xtraiter, 0
  call void @llvm.assume(i1 %lcmp.mod3572)
  br label %bb8.i142.epil

bb8.i142.epil:                                    ; preds = %bb8.i142.epil, %bb8.i142.epil.preheader
  %i.sroa.0.0.i.epil = phi i64 [ %_27.i143.epil, %bb8.i142.epil ], [ %i.sroa.0.0.i.epil.init, %bb8.i142.epil.preheader ]
  %acc.sroa.0.0.i.epil = phi i64 [ %_4.0.i.i.i.epil, %bb8.i142.epil ], [ %acc.sroa.0.0.i.epil.init, %bb8.i142.epil.preheader ]
  %epil.iter = phi i64 [ %epil.iter.next, %bb8.i142.epil ], [ 0, %bb8.i142.epil.preheader ]
  %_45.i.epil = getelementptr inbounds nuw [24 x i8], ptr %turn.sroa.7.0943.in, i64 %i.sroa.0.0.i.epil
  %306 = getelementptr i8, ptr %_45.i.epil, i64 16
  %_45.val.i.epil = load i64, ptr %306, align 8, !noundef !566
  %_4.0.i.i.i.epil = add i64 %_45.val.i.epil, %acc.sroa.0.0.i.epil
  %_27.i143.epil = add nuw i64 %i.sroa.0.0.i.epil, 1
  %epil.iter.next = add i64 %epil.iter, 1
  %epil.iter.cmp.not = icmp eq i64 %epil.iter.next, %xtraiter
  br i1 %epil.iter.cmp.not, label %bb76, label %bb8.i142.epil, !llvm.loop !5286

bb76:                                             ; preds = %bb8.i142.epil, %bb76.unr-lcssa
  %_4.0.i.i.i.lcssa = phi i64 [ %_4.0.i.i.i.3, %bb76.unr-lcssa ], [ %_4.0.i.i.i.epil, %bb8.i142.epil ]
  %_181 = load ptr, ptr %34, align 8, !nonnull !566, !noundef !566
  %_180 = load i64, ptr %35, align 8, !noundef !566
  %307 = icmp eq i64 %_180, 0
  br i1 %307, label %bb77, label %bb8.i147.preheader

bb8.i147.preheader:                               ; preds = %bb76
  %xtraiter3573 = and i64 %_180, 3
  %308 = icmp ult i64 %_180, 4
  br i1 %308, label %bb8.i147.epil.preheader, label %bb8.i147.preheader.new

bb8.i147.preheader.new:                           ; preds = %bb8.i147.preheader
  %unroll_iter3578 = and i64 %_180, -4
  br label %bb8.i147

bb8.i147:                                         ; preds = %bb8.i147, %bb8.i147.preheader.new
  %i.sroa.0.0.i148 = phi i64 [ 0, %bb8.i147.preheader.new ], [ %_27.i153.3, %bb8.i147 ]
  %acc.sroa.0.0.i149 = phi i64 [ 0, %bb8.i147.preheader.new ], [ %_4.0.i.i.i152.3, %bb8.i147 ]
  %niter3579 = phi i64 [ 0, %bb8.i147.preheader.new ], [ %niter3579.next.3, %bb8.i147 ]
  %_45.i150 = getelementptr inbounds nuw [24 x i8], ptr %_181, i64 %i.sroa.0.0.i148
  %309 = getelementptr i8, ptr %_45.i150, i64 16
  %_45.val.i151 = load i64, ptr %309, align 8, !noundef !566
  %_4.0.i.i.i152 = add i64 %_45.val.i151, %acc.sroa.0.0.i149
  %310 = getelementptr inbounds nuw [24 x i8], ptr %_181, i64 %i.sroa.0.0.i148
  %311 = getelementptr i8, ptr %310, i64 40
  %_45.val.i151.1 = load i64, ptr %311, align 8, !noundef !566
  %_4.0.i.i.i152.1 = add i64 %_45.val.i151.1, %_4.0.i.i.i152
  %312 = getelementptr inbounds nuw [24 x i8], ptr %_181, i64 %i.sroa.0.0.i148
  %313 = getelementptr i8, ptr %312, i64 64
  %_45.val.i151.2 = load i64, ptr %313, align 8, !noundef !566
  %_4.0.i.i.i152.2 = add i64 %_45.val.i151.2, %_4.0.i.i.i152.1
  %314 = getelementptr inbounds nuw [24 x i8], ptr %_181, i64 %i.sroa.0.0.i148
  %315 = getelementptr i8, ptr %314, i64 88
  %_45.val.i151.3 = load i64, ptr %315, align 8, !noundef !566
  %_4.0.i.i.i152.3 = add i64 %_45.val.i151.3, %_4.0.i.i.i152.2
  %_27.i153.3 = add nuw i64 %i.sroa.0.0.i148, 4
  %niter3579.next.3 = add i64 %niter3579, 4
  %niter3579.ncmp.3 = icmp eq i64 %niter3579.next.3, %unroll_iter3578
  br i1 %niter3579.ncmp.3, label %bb77.loopexit.unr-lcssa, label %bb8.i147

bb77.loopexit.unr-lcssa:                          ; preds = %bb8.i147
  %lcmp.mod3575.not = icmp eq i64 %xtraiter3573, 0
  br i1 %lcmp.mod3575.not, label %bb77, label %bb8.i147.epil.preheader

bb8.i147.epil.preheader:                          ; preds = %bb77.loopexit.unr-lcssa, %bb8.i147.preheader
  %i.sroa.0.0.i148.epil.init = phi i64 [ 0, %bb8.i147.preheader ], [ %_27.i153.3, %bb77.loopexit.unr-lcssa ]
  %acc.sroa.0.0.i149.epil.init = phi i64 [ 0, %bb8.i147.preheader ], [ %_4.0.i.i.i152.3, %bb77.loopexit.unr-lcssa ]
  %lcmp.mod3577 = icmp ne i64 %xtraiter3573, 0
  call void @llvm.assume(i1 %lcmp.mod3577)
  br label %bb8.i147.epil

bb8.i147.epil:                                    ; preds = %bb8.i147.epil, %bb8.i147.epil.preheader
  %i.sroa.0.0.i148.epil = phi i64 [ %_27.i153.epil, %bb8.i147.epil ], [ %i.sroa.0.0.i148.epil.init, %bb8.i147.epil.preheader ]
  %acc.sroa.0.0.i149.epil = phi i64 [ %_4.0.i.i.i152.epil, %bb8.i147.epil ], [ %acc.sroa.0.0.i149.epil.init, %bb8.i147.epil.preheader ]
  %epil.iter3574 = phi i64 [ %epil.iter3574.next, %bb8.i147.epil ], [ 0, %bb8.i147.epil.preheader ]
  %_45.i150.epil = getelementptr inbounds nuw [24 x i8], ptr %_181, i64 %i.sroa.0.0.i148.epil
  %316 = getelementptr i8, ptr %_45.i150.epil, i64 16
  %_45.val.i151.epil = load i64, ptr %316, align 8, !noundef !566
  %_4.0.i.i.i152.epil = add i64 %_45.val.i151.epil, %acc.sroa.0.0.i149.epil
  %_27.i153.epil = add nuw i64 %i.sroa.0.0.i148.epil, 1
  %epil.iter3574.next = add i64 %epil.iter3574, 1
  %epil.iter3574.cmp.not = icmp eq i64 %epil.iter3574.next, %xtraiter3573
  br i1 %epil.iter3574.cmp.not, label %bb77, label %bb8.i147.epil, !llvm.loop !5287

bb77:                                             ; preds = %bb77.loopexit.unr-lcssa, %bb8.i147.epil, %bb76
  %_0.sroa.0.0.i155 = phi i64 [ 0, %bb76 ], [ %_4.0.i.i.i152.3, %bb77.loopexit.unr-lcssa ], [ %_4.0.i.i.i152.epil, %bb8.i147.epil ]
  call void @llvm.lifetime.start.p0(ptr nonnull %before)
  store i64 %_4.0.i.i.i.lcssa, ptr %before, align 8
  call void @llvm.lifetime.start.p0(ptr nonnull %after)
  store i64 %_0.sroa.0.0.i155, ptr %after, align 8
  %_64 = icmp ult i64 %_0.sroa.0.0.i155, %_4.0.i.i.i.lcssa
  br i1 %_64, label %bb55, label %bb50

bb50:                                             ; preds = %bb77
  %_65 = icmp eq i64 %_0.sroa.0.0.i155, %_4.0.i.i.i.lcssa
  br i1 %_65, label %bb51, label %bb54, !prof !552

bb55:                                             ; preds = %bb51, %bb77
  store i64 0, ptr %37, align 8
  %_4.sroa.0.0.copyload.i.i.i.i.i = load i64, ptr %waiting, align 8, !alias.scope !5288, !noalias !5291
  store i64 %waiting.val37, ptr %waiting, align 8, !alias.scope !5288, !noalias !5291
  store i64 %turn.sroa.7.0943, ptr %34, align 8, !alias.scope !5293, !noalias !5295
  store i64 0, ptr %35, align 8
  call void @llvm.lifetime.end.p0(ptr nonnull %after)
  call void @llvm.lifetime.end.p0(ptr nonnull %before)
  %_113 = icmp ult i64 %_180, 384307168202282326
  call void @llvm.assume(i1 %_113)
  br i1 %307, label %bb29, label %bb72.preheader

bb54:                                             ; preds = %bb51, %bb50
  call void @llvm.lifetime.start.p0(ptr nonnull %_72)
  store i64 %turn.sroa.15.0942, ptr %_72, align 8
  call void @llvm.lifetime.start.p0(ptr nonnull %_74)
  store i64 %_180, ptr %_74, align 8
  %_193 = icmp ult i64 %_180, 384307168202282326
  call void @llvm.assume(i1 %_193)
  call void @llvm.lifetime.start.p0(ptr nonnull %args)
  store ptr %_72, ptr %args, align 8
  %_78.sroa.4.0..sroa_idx = getelementptr inbounds nuw i8, ptr %args, i64 8
  store ptr @_RNvXsi_NtNtNtCskADBYZwJmSU_4core3fmt3num3impjNtB9_7Display3fmt, ptr %_78.sroa.4.0..sroa_idx, align 8
  %317 = getelementptr inbounds nuw i8, ptr %args, i64 16
  store ptr %before, ptr %317, align 8
  %_79.sroa.4.0..sroa_idx = getelementptr inbounds nuw i8, ptr %args, i64 24
  store ptr @_RNvXsi_NtNtNtCskADBYZwJmSU_4core3fmt3num3impjNtB9_7Display3fmt, ptr %_79.sroa.4.0..sroa_idx, align 8
  %318 = getelementptr inbounds nuw i8, ptr %args, i64 32
  store ptr %_74, ptr %318, align 8
  %_80.sroa.4.0..sroa_idx = getelementptr inbounds nuw i8, ptr %args, i64 40
  store ptr @_RNvXsi_NtNtNtCskADBYZwJmSU_4core3fmt3num3impjNtB9_7Display3fmt, ptr %_80.sroa.4.0..sroa_idx, align 8
  %319 = getelementptr inbounds nuw i8, ptr %args, i64 48
  store ptr %after, ptr %319, align 8
  %_81.sroa.4.0..sroa_idx = getelementptr inbounds nuw i8, ptr %args, i64 56
  store ptr @_RNvXsi_NtNtNtCskADBYZwJmSU_4core3fmt3num3impjNtB9_7Display3fmt, ptr %_81.sroa.4.0..sroa_idx, align 8
  br label %bb49.invoke

bb51:                                             ; preds = %bb50
  %_190 = icmp ult i64 %_180, 384307168202282326
  call void @llvm.assume(i1 %_190)
  %_66 = icmp samesign ult i64 %_180, %turn.sroa.15.0942
  br i1 %_66, label %bb55, label %bb54, !prof !552

bb61:                                             ; preds = %bb2.i.i.i4.i62, %cleanup.body
  %waiting.val = load i64, ptr %waiting, align 8
  %320 = icmp eq i64 %waiting.val, 0
  br i1 %320, label %bb62, label %bb2.i.i.i4.i158

bb2.i.i.i4.i158:                                  ; preds = %bb61
  %waiting.val34 = load ptr, ptr %34, align 8, !nonnull !566, !noundef !566
  %alloc_size.i.i.i.i5.i159 = mul nuw i64 %waiting.val, 24
; call __rustc::__rust_dealloc
  call void @_RNvCs5fGHjzWXRav_7___rustc14___rust_dealloc(ptr noundef nonnull %waiting.val34, i64 noundef %alloc_size.i.i.i.i5.i159, i64 noundef range(i64 1, -9223372036854775807) 8) #36
  br label %bb62

bb56:                                             ; preds = %bb2.i.i.i4.i, %bb29
  call void @llvm.lifetime.end.p0(ptr nonnull %held)
  %321 = icmp eq i64 %waiting.val37, 0
  br i1 %321, label %bb57, label %bb2.i.i.i4.i161

bb2.i.i.i4.i161:                                  ; preds = %bb56
  %alloc_size.i.i.i.i5.i162 = mul nuw i64 %waiting.val37, 24
; call __rustc::__rust_dealloc
  call void @_RNvCs5fGHjzWXRav_7___rustc14___rust_dealloc(ptr noundef nonnull %turn.sroa.7.0943.in, i64 noundef %alloc_size.i.i.i.i5.i162, i64 noundef range(i64 1, -9223372036854775807) 8) #36
  br label %bb57

bb62:                                             ; preds = %bb2.i.i.i4.i158, %bb61
  %322 = icmp eq i64 %waiting.val37, 0
  br i1 %322, label %bb63, label %bb2.i.i.i4.i165

bb2.i.i.i4.i165:                                  ; preds = %bb62
  %alloc_size.i.i.i.i5.i166 = mul nuw i64 %waiting.val37, 24
; call __rustc::__rust_dealloc
  call void @_RNvCs5fGHjzWXRav_7___rustc14___rust_dealloc(ptr noundef nonnull %turn.sroa.7.0943.in, i64 noundef %alloc_size.i.i.i.i5.i166, i64 noundef range(i64 1, -9223372036854775807) 8) #36
  br label %bb63

bb57:                                             ; preds = %bb2.i.i.i4.i161, %bb56
  call void @llvm.lifetime.end.p0(ptr nonnull %waiting)
  %323 = icmp eq i64 %_4.sroa.0.0.copyload.i.i.i.i.i, 0
  br i1 %323, label %bb59, label %bb2.i.i.i4.i169

bb2.i.i.i4.i169:                                  ; preds = %bb57
  %alloc_size.i.i.i.i5.i170 = mul nuw i64 %_4.sroa.0.0.copyload.i.i.i.i.i, 24
; call __rustc::__rust_dealloc
  call void @_RNvCs5fGHjzWXRav_7___rustc14___rust_dealloc(ptr noundef nonnull %_181, i64 noundef %alloc_size.i.i.i.i5.i170, i64 noundef range(i64 1, -9223372036854775807) 8) #36
  br label %bb59

bb59:                                             ; preds = %bb2.i.i.i4.i169, %bb57, %bb25
  ret void

bb63:                                             ; preds = %bb2.i.i.i4.i165, %bb62
  resume { ptr, i32 } %eh.lpad-body
}
