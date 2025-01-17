import 'dart:math';

import 'package:confwebsite2023/core/components/responsive_widget.dart';
import 'package:confwebsite2023/core/theme.dart';
import 'package:confwebsite2023/features/access/ui/access_widget.dart';
import 'package:confwebsite2023/features/count_down/model/count_down_timer.dart';
import 'package:confwebsite2023/features/count_down/ui/count_down_section.dart';
import 'package:confwebsite2023/features/event/hands-on/ui/hands_on_event.dart';
import 'package:confwebsite2023/features/footer/ui/footer.dart';
import 'package:confwebsite2023/features/header/data/header_item_button_data.dart';
import 'package:confwebsite2023/features/header/ui/header_widget.dart';
import 'package:confwebsite2023/features/hero/ui/hero_section.dart';
import 'package:confwebsite2023/features/news/ui/news_section.dart';
import 'package:confwebsite2023/features/staff/ui/staff_header.dart';
import 'package:confwebsite2023/features/staff/ui/staff_table.dart';
import 'package:confwebsite2023/features/ticket/ui/ticket_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:js/js_util.dart' as js_util;

class MainPage extends HookWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();

    const sectionKeys = (
      access: GlobalObjectKey('accessSectionKey'),
      event: GlobalObjectKey('eventSectionKey'),
      ticket: GlobalObjectKey('ticketSectionKey'),
      session: GlobalObjectKey('sessionSectionKey'),
      sponsor: GlobalObjectKey('sponsorSectionKey'),
      staff: GlobalObjectKey('staffSectionKey'),
    );

    final items = <HeaderItemButtonData>[
      HeaderItemButtonData(
        title: 'Access',
        onPressed: () async => Scrollable.ensureVisible(
          sectionKeys.access.currentContext!,
          curve: Curves.easeOutCirc,
          duration: const Duration(milliseconds: 750),
        ),
      ),
      HeaderItemButtonData(
        title: 'Event',
        onPressed: () async => Scrollable.ensureVisible(
          sectionKeys.event.currentContext!,
          curve: Curves.easeOutCirc,
          duration: const Duration(milliseconds: 750),
        ),
      ),
      HeaderItemButtonData(
        title: 'Ticket',
        onPressed: () async => Scrollable.ensureVisible(
          sectionKeys.ticket.currentContext!,
          curve: Curves.easeOutCirc,
          duration: const Duration(milliseconds: 750),
        ),
      ),
      HeaderItemButtonData(
        title: 'Staff',
        onPressed: () async => Scrollable.ensureVisible(
          sectionKeys.staff.currentContext!,
          curve: Curves.easeOutCirc,
          duration: const Duration(milliseconds: 750),
        ),
      ),
    ];

    return Scaffold(
      backgroundColor: baselineColorScheme.ref.secondary.secondary10,
      body: _MainPageBody(
        scrollController: scrollController,
        sectionKeys: sectionKeys,
        items: items,
      ),
    );
  }
}

class _MainPageBody extends StatelessWidget {
  const _MainPageBody({
    required this.scrollController,
    required this.sectionKeys,
    required this.items,
  });

  final ScrollController scrollController;
  final ({
    GlobalObjectKey access,
    GlobalObjectKey event,
    GlobalObjectKey ticket,
    GlobalObjectKey session,
    GlobalObjectKey sponsor,
    GlobalObjectKey staff
  }) sectionKeys;
  final List<HeaderItemButtonData> items;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final largeScreenSize = ResponsiveWidget.largeScreenSize.toDouble();
    final horizontal = max<double>(16, (width - largeScreenSize) / 4.0);
    final padding = EdgeInsets.symmetric(
      horizontal: horizontal,
    );

    js_util.callMethod<void>(js_util.globalThis, '_show', []);

    return Stack(
      children: [
        const SizedBox(
          width: double.infinity,
          height: 800,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF602678),
                  Color(0x004B0082),
                ],
              ),
            ),
          ),
        ),
        CustomScrollView(
          controller: scrollController,
          slivers: [
            _Sliver(
              padding: padding,
              child: HeaderBar(
                items: items,
                onTitleTap: () async => scrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 750),
                  curve: Curves.easeOutCirc,
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: Spaces.vertical_30,
            ),
            _Sliver(
              padding: padding,
              child: const HeroSection(),
            ),
            _Sliver(
              padding: padding,
              child: Consumer(
                builder: (context, ref, child) {
                  final now = ref.watch(nowProvider);
                  return Visibility(
                    visible: CountDownSection.isVisible(now),
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Spaces.vertical_80,
                        CountDownSection(),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SliverToBoxAdapter(
              child: Spaces.vertical_80,
            ),
            _Sliver(
              padding: padding,
              child: const NewsSection(),
            ),
            const SliverToBoxAdapter(
              child: Spaces.vertical_200,
            ),
            _Sliver(
              padding: padding,
              child: AccessWidget(
                key: sectionKeys.access,
              ),
            ),
            const SliverToBoxAdapter(
              child: Spaces.vertical_200,
            ),
            _Sliver(
              padding: padding,
              child: TicketSection(
                key: sectionKeys.ticket,
              ),
            ),
            const SliverToBoxAdapter(
              child: Spaces.vertical_200,
            ),
            _Sliver(
              padding: padding,
              child: HandsOnEvent(
                key: sectionKeys.event,
              ),
            ),
            const SliverToBoxAdapter(
              child: Spaces.vertical_200,
            ),
            _Sliver(
              padding: padding,
              child: StaffHeader(
                key: sectionKeys.staff,
              ),
            ),
            const SliverToBoxAdapter(
              child: Spaces.vertical_16,
            ),
            SliverPadding(
              padding: padding,
              sliver: const StaffTable(),
            ),
            const SliverToBoxAdapter(
              child: Spaces.vertical_200,
            ),
            const SliverToBoxAdapter(
              child: Footer(),
            ),
          ],
        ),
      ],
    );
  }
}

class _Sliver extends StatelessWidget {
  const _Sliver({
    required this.child,
    required this.padding,
  });

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: padding,
      sliver: SliverToBoxAdapter(
        child: child,
      ),
    );
  }
}
