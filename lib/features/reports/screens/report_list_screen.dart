import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils.dart';
import '../../../data/models.dart';
import '../../../shared/layouts/app_background.dart';
import '../../../shared/widgets/app_back_button.dart';

import '../widgets/report_card.dart';
import '../widgets/report_empty_state.dart';
import '../widgets/report_error_state.dart';
import '../widgets/report_filter_chips.dart';
import '../widgets/report_loading_state.dart';
import '../widgets/report_search_field.dart';

class ReportListScreen extends StatefulWidget {
  final String title;
  final String detailBase;
  final String emptyText;
  final Future<List<Report>> Function() loader;
  final String? createRoute;
  final List<Widget> extraActions;

  const ReportListScreen({
    super.key,
    required this.title,
    required this.detailBase,
    required this.emptyText,
    required this.loader,
    this.createRoute,
    this.extraActions = const [],
  });

  @override
  State<ReportListScreen> createState() => _ReportListScreenState();
}

class _ReportListScreenState extends State<ReportListScreen> {
  late Future<List<Report>> _future;

  String? _filter;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _future = widget.loader();
  }

  Future<void> _reload() async {
    setState(() {
      _future = widget.loader();
    });

    try {
      await _future;
    } catch (_) {}
  }

  List<Report> _filteredItems(List<Report> reports) {
    return reports.where((report) {
      final matchesStatus = _filter == null || report.status == _filter;

      final query = _searchQuery.toLowerCase().trim();

      final category = (kategoriLabels[report.kategori] ?? report.kategori)
          .toLowerCase();

      final matchesSearch =
          query.isEmpty ||
          report.kode.toLowerCase().contains(query) ||
          report.identitas.toLowerCase().contains(query) ||
          category.contains(query);

      return matchesStatus && matchesSearch;
    }).toList();
  }

  void _goBack() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.landingBackground,

      floatingActionButton: widget.createRoute == null
          ? null
          : FloatingActionButton.extended(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              onPressed: () async {
                await context.push(widget.createRoute!);

                if (mounted) {
                  await _reload();
                }
              },
              icon: const Icon(Icons.add_rounded),
              label: const Text('Buat Laporan'),
            ),

      body: SafeArea(
        child: AppBackground(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER ACTIONS
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Row(
                  children: [
                    AppBackButton(onPressed: _goBack),
                    const Spacer(),
                    IconButton(
                      tooltip: 'Edukasi',
                      icon: const Icon(
                        Icons.menu_book_outlined,
                        color: AppColors.ink,
                      ),
                      onPressed: () => context.go('/'),
                    ),
                    ...widget.extraActions,
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // PAGE TITLE
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'LAYANAN LAPORAN',
                      style: AppTextStyles.text(
                        11,
                        weight: FontWeight.w800,
                        color: AppColors.primaryDark,
                        letterSpacing: 1.8,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      widget.title,
                      style: AppTextStyles.text(
                        29,
                        weight: FontWeight.w800,
                        color: AppColors.ink,
                        letterSpacing: -0.8,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      widget.title == 'Riwayat Laporan'
                          ? 'Pantau perkembangan laporan yang telah kamu buat.'
                          : widget.title == 'Laporan Masuk'
                          ? 'Pantau dan kelola laporan yang masuk.'
                          : 'Pantau siswa yang dialihkan kepada kamu.',
                      style: AppTextStyles.text(
                        13,
                        color: AppColors.ink.withValues(alpha: 0.65),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // SEARCH FIELD
              ReportSearchField(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),

              // FILTER CHIPS
              ReportFilterChips(
                selectedFilter: _filter,
                onChanged: (value) {
                  setState(() {
                    _filter = value;
                  });
                },
              ),

              // REPORT LIST
              Expanded(
                child: RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: _reload,
                  child: FutureBuilder<List<Report>>(
                    future: _future,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return const ReportLoadingState();
                      }

                      if (snapshot.hasError) {
                        return ReportErrorState(
                          message: errMsg(snapshot.error!),
                          onRetry: _reload,
                        );
                      }

                      final reports = _filteredItems(snapshot.data ?? []);

                      if (reports.isEmpty) {
                        return ReportEmptyState(
                          message: widget.emptyText,
                          isFiltered:
                              _filter != null || _searchQuery.isNotEmpty,
                        );
                      }

                      return ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                        itemCount: reports.length,
                        itemBuilder: (context, index) {
                          final report = reports[index];

                          return ReportCard(
                            report: report,
                            onTap: () async {
                              await context.push(
                                '${widget.detailBase}/${report.id}',
                              );

                              if (mounted) {
                                await _reload();
                              }
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
