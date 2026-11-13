import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:runca/ui/color.dart';
import 'package:runca/ui/shared_view/app_page_header.dart';
import 'package:runca/utility/snackbar_extension.dart';

import 'cubit/activity_share_cubit.dart';
import 'cubit/activity_share_state.dart';
import 'models/activity_model.dart';
import 'widgets/activity_share_actions.dart';
import 'widgets/activity_share_card.dart';
import 'widgets/activity_share_page_dots.dart';

/// Layar Preview: kartu aktivitas yang akan dibagikan dan pilihan berbagi.
class ActivityShareScreen extends StatelessWidget {
  const ActivityShareScreen({super.key, required this.activity});

  final ActivityModel activity;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ActivityShareCubit(activity: activity),
      child: _ActivityShareView(activity: activity),
    );
  }
}

class _ActivityShareView extends StatefulWidget {
  const _ActivityShareView({required this.activity});

  final ActivityModel activity;

  @override
  State<_ActivityShareView> createState() => _ActivityShareViewState();
}

class _ActivityShareViewState extends State<_ActivityShareView> {
  // ASUMSI: desain halaman 2 dan 3 belum ada di Figma, jadi sementara
  // ketiganya memakai kartu yang sama.
  static const int _pageCount = 3;

  final PageController _controller = PageController();
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.bgPrimary,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const AppPageHeader(title: 'Preview'),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pageCount,
                onPageChanged: (page) => setState(() => _page = page),
                itemBuilder: (context, index) => SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                  child: BlocBuilder<ActivityShareCubit, ActivityShareState>(
                    builder: (context, state) => ActivityShareCard(
                      activity: widget.activity,
                      placeName: state.placeName,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: ActivitySharePageDots(count: _pageCount, index: _page),
            ),
            ActivityShareActions(
              onTap: (name) => context.showUnavailableSnackbar(
                name,
                duration: const Duration(seconds: 2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
