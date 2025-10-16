# TODO: Fix Errors and Warnings in Flutter Codebase

## Variable Naming Issues (non_constant_identifier_names)
- [ ] Fix `tanggal_penerimaan` in `lib/models/surat.dart` (lines 6, 17) - rename to `tanggalPenerimaan`
- [ ] Fix `no_surat` in `lib/views/disposisi.dart` (lines 67, 144, 154) - rename to `noSurat`

## Deprecated Member Usage (deprecated_member_use)
- [ ] Replace `withOpacity` with `withValues` in multiple files:
  - `lib/views/disposisi_masuk/detail_disposisi.dart` (line 113)
  - `lib/views/home.dart` (lines 62, 73, 209)
  - `lib/views/keluar/detail_suratkeluar.dart` (line 153)
  - `lib/views/masuk/create.dart` (lines 116, 162, 206)
  - `lib/views/masuk/edit_surat.dart` (lines 275, 316)
  - `lib/views/splashscreen.dart` (line 76)
  - `lib/views/suratkeluar.dart` (lines 59, 215)
  - `lib/views/ubahsandi.dart` (line 74)

## BuildContext Async Gap Issues (use_build_context_synchronously)
- [ ] Fix async gaps in `lib/views/keluar/createkeluar.dart` (lines 117, 127, 130)
- [ ] Fix async gaps in `lib/views/masuk/create.dart` (lines 314, 321, 323)
- [ ] Fix async gaps in `lib/views/masuk/edit_surat.dart` (lines 171, 179, 190)
- [ ] Fix async gaps in `lib/views/suratmasuk.dart` (line 202)

## Dead Null-Aware Expression (dead_null_aware_expression)
- [ ] Fix dead null-aware expressions in `lib/views/masuk/edit_surat.dart` (lines 29, 36, 37)

## Widget Constructor Issues (sort_child_properties_last)
- [ ] Fix child property order in `lib/views/suratkeluar.dart` (line 44)
