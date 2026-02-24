import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'account_balance_detail_page.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Data model
// ─────────────────────────────────────────────────────────────────────────────

enum ViewMode { table, pie, bar }

class AccountEntry {
  const AccountEntry({
    required this.name,
    required this.maskedNumber,
    required this.color,
    required this.currBalance,
    required this.currCurrency,
    required this.prevBalance,
    required this.prevCurrency,
    this.isGroup = false,
  });

  final String name;
  final String maskedNumber;
  final Color color;
  final double currBalance;
  final String currCurrency;
  final double prevBalance;
  final String prevCurrency;
  final bool isGroup;

  String get currBalanceFormatted => _fmt(currBalance);
  String get prevBalanceFormatted => _fmt(prevBalance);

  static String _fmt(double v) {
    final neg = v < 0;
    final abs = v.abs();
    final s = abs.toStringAsFixed(2).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]},',
        );
    return neg ? '-$s' : s;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Page
// ─────────────────────────────────────────────────────────────────────────────

class AccountBalancesPage extends StatefulWidget {
  const AccountBalancesPage({super.key});

  @override
  State<AccountBalancesPage> createState() => _AccountBalancesPageState();
}

class _AccountBalancesPageState extends State<AccountBalancesPage> {
  ViewMode _viewMode = ViewMode.table;
  bool _currentDay = true;

  static const _accounts = [
    AccountEntry(
      name: 'MUFG TB CHI BANK OF NEW YORK 23',
      maskedNumber: 'xxxxxx1111',
      color: Color(0xFF5C6BC0), // indigo
      currBalance: 36714.00,
      currCurrency: 'USD',
      prevBalance: 3400.00,
      prevCurrency: 'USD',
    ),
    AccountEntry(
      name: 'MUFG TB CHI ...',
      maskedNumber: 'xxxxxx2222',
      color: Color(0xFFC49A2A), // amber/gold
      currBalance: 19714.00,
      currCurrency: 'USD',
      prevBalance: 3900.00,
      prevCurrency: 'USD',
    ),
    AccountEntry(
      name: 'MUFG TB NY B...',
      maskedNumber: 'xxxxxx3333',
      color: Color(0xFF6B9E8F), // teal-green
      currBalance: 39714.00,
      currCurrency: 'USD',
      prevBalance: -5400.00,
      prevCurrency: 'USD',
    ),
    AccountEntry(
      name: 'GroupA',
      maskedNumber: '',
      color: Color(0xFF7B3F8C), // purple
      currBalance: 353220.00,
      currCurrency: 'USD',
      prevBalance: 121949.00,
      prevCurrency: 'USD',
      isGroup: true,
    ),
  ];

  double get _totalBalance =>
      _accounts.fold(0.0, (sum, a) => sum + a.currBalance);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TopBar(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DateAndToggle(
                    viewMode: _viewMode,
                    onChanged: (m) => setState(() => _viewMode = m),
                  ),
                  // Chart area — swaps based on mode
                  if (_viewMode == ViewMode.bar)
                    _BarChartView(accounts: _accounts)
                  else if (_viewMode == ViewMode.pie)
                    _PieChartView(accounts: _accounts)
                  else
                    const SizedBox.shrink(),
                  _SummaryCard(
                    currentDay: _currentDay,
                    total: _totalBalance,
                    onToggle: (v) => setState(() => _currentDay = v),
                  ),
                  const SizedBox(height: 8),
                  _AccountList(
                    accounts: _accounts,
                    onAccountTap: (account, index) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => AccountBalanceDetailPage(
                            account: account,
                            accountIndex: index,
                            totalAccounts: _accounts.length,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Top bar  (red callout banner + Authorize button)
// ─────────────────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFC0392B),
      child: SafeArea(
        bottom: false,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: const [
                  Expanded(
                    child: Text(
                      'Account Balances',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Callout triangle
            CustomPaint(
              size: const Size(24, 12),
              painter: _TrianglePainter(color: Color(0xFFC0392B)),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrianglePainter extends CustomPainter {
  const _TrianglePainter({required this.color});
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
      Path()
        ..moveTo(0, 0)
        ..lineTo(size.width / 2, size.height)
        ..lineTo(size.width, 0)
        ..close(),
      Paint()..color = color,
    );
  }

  @override
  bool shouldRepaint(_TrianglePainter old) => old.color != color;
}

// ─────────────────────────────────────────────────────────────────────────────
// Date + view-mode toggle
// ─────────────────────────────────────────────────────────────────────────────

class _DateAndToggle extends StatelessWidget {
  const _DateAndToggle({required this.viewMode, required this.onChanged});
  final ViewMode viewMode;
  final ValueChanged<ViewMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        children: [
          const Text(
            'Sep 1, 2025',
            style: TextStyle(color: Color(0xFF8E8E93), fontSize: 14),
          ),
          const Spacer(),
          _ToggleGroup(current: viewMode, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _ToggleGroup extends StatelessWidget {
  const _ToggleGroup({required this.current, required this.onChanged});
  final ViewMode current;
  final ValueChanged<ViewMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE4E4E8),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ToggleBtn(
            icon: Icons.table_chart_outlined,
            selected: current == ViewMode.table,
            onTap: () => onChanged(ViewMode.table),
            isFirst: true,
          ),
          _ToggleBtn(
            icon: Icons.donut_large_outlined,
            selected: current == ViewMode.pie,
            onTap: () => onChanged(ViewMode.pie),
          ),
          _ToggleBtn(
            icon: Icons.bar_chart,
            selected: current == ViewMode.bar,
            onTap: () => onChanged(ViewMode.bar),
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _ToggleBtn extends StatelessWidget {
  const _ToggleBtn({
    required this.icon,
    required this.selected,
    required this.onTap,
    this.isFirst = false,
    this.isLast = false,
  });
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    BorderRadius radius = BorderRadius.circular(8);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 44,
        height: 36,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFC0392B) : Colors.transparent,
          borderRadius: radius,
        ),
        child: Icon(
          icon,
          size: 20,
          color: selected ? Colors.white : const Color(0xFF555555),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bar chart
// ─────────────────────────────────────────────────────────────────────────────

class _BarChartView extends StatelessWidget {
  const _BarChartView({required this.accounts});
  final List<AccountEntry> accounts;

  @override
  Widget build(BuildContext context) {
    // Only show the first 3 non-group accounts in the bar chart
    final chartAccounts = accounts.where((a) => !a.isGroup).toList();
    final maxVal = chartAccounts
        .map((a) => a.currBalance.abs())
        .fold(0.0, math.max);

    const chartHeight = 240.0;
    const barWidth = 40.0;
    final yLabels = ['40k', '35k', '30k', '25k', '20k', '15k', '10k', '5k', '0'];

    return Container(
      margin: const EdgeInsets.fromLTRB(0, 8, 0, 0),
      color: const Color(0xFFF2F2F7),
      padding: const EdgeInsets.fromLTRB(0, 12, 16, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Y-axis labels
          SizedBox(
            width: 40,
            height: chartHeight + 20,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: yLabels
                  .map((l) => Text(l,
                      style: const TextStyle(fontSize: 10, color: Color(0xFF8E8E93))))
                  .toList(),
            ),
          ),
          // Chart body
          Expanded(
            child: SizedBox(
              height: chartHeight + 20,
              child: Column(
                children: [
                  // Grid + bars
                  Expanded(
                    child: CustomPaint(
                      painter: _GridPainter(lineCount: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: chartAccounts.map((a) {
                          final ratio = maxVal > 0
                              ? (a.currBalance.abs() / maxVal).clamp(0.0, 1.0)
                              : 0.0;
                          return _Bar(
                            ratio: ratio,
                            color: a.color,
                            width: barWidth,
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  // X-axis baseline
                  Container(height: 1, color: const Color(0xFFCCCCCC)),
                  const SizedBox(height: 4),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  const _GridPainter({required this.lineCount});
  final int lineCount;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFDDDDDD)
      ..strokeWidth = 0.5;
    for (int i = 0; i <= lineCount; i++) {
      final y = size.height * i / lineCount;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_GridPainter old) => false;
}

class _Bar extends StatelessWidget {
  const _Bar({required this.ratio, required this.color, required this.width});
  final double ratio;
  final Color color;
  final double width;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final barH = constraints.maxHeight * ratio;
      return Align(
        alignment: Alignment.bottomCenter,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
          width: width,
          height: barH,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ),
      );
    });
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Pie chart
// ─────────────────────────────────────────────────────────────────────────────

class _PieChartView extends StatelessWidget {
  const _PieChartView({required this.accounts});
  final List<AccountEntry> accounts;

  @override
  Widget build(BuildContext context) {
    final chartAccounts = accounts.where((a) => !a.isGroup).toList();
    final total =
        chartAccounts.fold(0.0, (s, a) => s + a.currBalance.abs());

    return Container(
      color: const Color(0xFFF2F2F7),
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: SizedBox(
          width: 220,
          height: 220,
          child: CustomPaint(
            painter: _PiePainter(
              values: chartAccounts.map((a) => a.currBalance.abs()).toList(),
              colors: chartAccounts.map((a) => a.color).toList(),
              total: total,
            ),
          ),
        ),
      ),
    );
  }
}

class _PiePainter extends CustomPainter {
  const _PiePainter({
    required this.values,
    required this.colors,
    required this.total,
  });
  final List<double> values;
  final List<Color> colors;
  final double total;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    double startAngle = -math.pi / 2; // start at top

    for (int i = 0; i < values.length; i++) {
      final sweep = total > 0 ? (values[i] / total) * 2 * math.pi : 0.0;
      final paint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.fill;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweep,
        true,
        paint,
      );
      // Gap between slices
      startAngle += sweep;
    }

    // White center cut (make it look like a donut with thick rim — no, image shows solid pie)
  }

  @override
  bool shouldRepaint(_PiePainter old) => true;
}

// ─────────────────────────────────────────────────────────────────────────────
// Balance summary card
// ─────────────────────────────────────────────────────────────────────────────

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.currentDay,
    required this.total,
    required this.onToggle,
  });
  final bool currentDay;
  final double total;
  final ValueChanged<bool> onToggle;

  @override
  Widget build(BuildContext context) {
    final formatted = AccountEntry._fmt(total);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Text(
                  'Balance Summary',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF8E8E93)),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Current Day',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Switch(
                    value: currentDay,
                    onChanged: onToggle,
                    activeColor: Colors.white,
                    activeTrackColor: const Color(0xFF34C759),
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: const Color(0xFFE5E5EA),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ],
              ),
            ],
          ),
          const Text(
            'Totals for USD Favorite Accounts',
            style: TextStyle(fontSize: 13, color: Color(0xFF8E8E93)),
          ),
          const Text(
            '(Does not include Account Groups)',
            style: TextStyle(fontSize: 12, color: Color(0xFF8E8E93)),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                formatted,
                style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 4),
              const Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Text(
                  'USD',
                  style: TextStyle(fontSize: 13, color: Color(0xFF8E8E93)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Account list
// ─────────────────────────────────────────────────────────────────────────────

class _AccountList extends StatefulWidget {
  const _AccountList({required this.accounts, required this.onAccountTap});
  final List<AccountEntry> accounts;
  final void Function(AccountEntry, int) onAccountTap;

  @override
  State<_AccountList> createState() => _AccountListState();
}

class _AccountListState extends State<_AccountList> {
  final Set<int> _expandedGroups = {};

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // View All Balances
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                Text('View All Balances',
                    style: TextStyle(fontSize: 13, color: Color(0xFF8E8E93))),
                SizedBox(width: 4),
                Icon(Icons.chevron_right, color: Color(0xFF8E8E93), size: 18),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE5E5EA)),
          ...widget.accounts.asMap().entries.map((e) {
            final i = e.key;
            final acc = e.value;
            final isExpanded = _expandedGroups.contains(i);
            return _AccountRow(
              account: acc,
              isGroupExpanded: isExpanded,
              onTap: acc.isGroup
                  ? null
                  : () => widget.onAccountTap(acc, i),
              onGroupToggle: acc.isGroup
                  ? () => setState(() {
                        if (isExpanded) {
                          _expandedGroups.remove(i);
                        } else {
                          _expandedGroups.add(i);
                        }
                      })
                  : null,
            );
          }).toList(),
        ],
      ),
    );
  }
}

class _AccountRow extends StatelessWidget {
  const _AccountRow({
    required this.account,
    this.onTap,
    this.onGroupToggle,
    this.isGroupExpanded = false,
  });

  final AccountEntry account;
  final VoidCallback? onTap;
  final VoidCallback? onGroupToggle;
  final bool isGroupExpanded;

  @override
  Widget build(BuildContext context) {
    final isNegPrev = account.prevBalance < 0;

    return Column(
      children: [
        InkWell(
          onTap: onTap ?? onGroupToggle,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                // Drag handle
                const Icon(Icons.drag_handle, color: Color(0xFFAEAEB2), size: 20),
                const SizedBox(width: 8),
                // Colored dot
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: account.color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                // Name + masked number
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        account.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (account.maskedNumber.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          account.maskedNumber,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF8E8E93),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Curr / Prev balances
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _BalanceLine(
                      label: 'Curr',
                      balance: account.currBalanceFormatted,
                      currency: account.currCurrency,
                      isNegative: account.currBalance < 0,
                    ),
                    const SizedBox(height: 4),
                    _BalanceLine(
                      label: 'Prev',
                      balance: account.prevBalanceFormatted,
                      currency: account.prevCurrency,
                      isNegative: isNegPrev,
                    ),
                  ],
                ),
                const SizedBox(width: 6),
                // Chevron: right for accounts, up/down for groups
                account.isGroup
                    ? AnimatedRotation(
                        turns: isGroupExpanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 180),
                        child: const Icon(Icons.keyboard_arrow_down,
                            color: Color(0xFFAEAEB2), size: 22),
                      )
                    : const Icon(Icons.chevron_right,
                        color: Color(0xFFAEAEB2), size: 20),
              ],
            ),
          ),
        ),
        const Divider(height: 1, indent: 16, color: Color(0xFFE5E5EA)),
      ],
    );
  }
}

class _BalanceLine extends StatelessWidget {
  const _BalanceLine({
    required this.label,
    required this.balance,
    required this.currency,
    this.isNegative = false,
  });
  final String label;
  final String balance;
  final String currency;
  final bool isNegative;

  @override
  Widget build(BuildContext context) {
    final valueColor = isNegative ? const Color(0xFFC0392B) : Colors.black87;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Color(0xFF8E8E93)),
        ),
        const SizedBox(width: 6),
        Text(
          balance,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: valueColor,
          ),
        ),
        const SizedBox(width: 2),
        Padding(
          padding: const EdgeInsets.only(bottom: 1),
          child: Text(
            currency,
            style: const TextStyle(fontSize: 9, color: Color(0xFF8E8E93)),
          ),
        ),
      ],
    );
  }
}
